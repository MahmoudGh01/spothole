import 'dart:async';
import 'dart:math';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import '../../Models/Report.dart';
import '../../Utils/constants.dart';
import '../../ViewModels/authority_provider.dart';
import '../../Views/job_pages/job_application/job_applicationstages.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();
  final Location _locationController = Location();
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
  StreamSubscription<LocationData>? _locationSubscription;

  static const LatLng _pGooglePlex = LatLng(36.407866, 10.561065);
  LatLng? _currentP;
  LatLng? _previousP;
  LatLng? _sourceLocation;
  LatLng? _destinationLocation;

  Map<PolylineId, Polyline> polylines = {};
  BitmapDescriptor? _customIcon;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthorityProvider>(context, listen: false).fetchAllReports();
    });
    _initializeMap();
    _loadCustomMarker();
    getLocationUpdates().then(
          (_) {
        getPolylinePoints().then((coordinates) {
          generatePolyLineFromPoints(coordinates);
        });
      },
    );
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    _locationSubscription?.cancel(); // Cancel location updates
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<AuthorityProvider>(context);

    return Scaffold(
      body: FutureBuilder(
        future: _initializeMap(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return _currentP == null
                ? const Center(child: Text("Loading..."))
                : Stack(
              children: [
                GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _customInfoWindowController.googleMapController = controller;
                    if (!_mapController.isCompleted) {
                      _mapController.complete(controller);
                    }
                  },
                  initialCameraPosition: const CameraPosition(
                    target: _pGooglePlex,
                    zoom: 15,
                  ),
                  markers: _buildMarkers(reportProvider.reports),
                  polylines: Set<Polyline>.of(polylines.values),
                  onTap: (position) {
                    _customInfoWindowController.hideInfoWindow!();
                  },
                  onCameraMove: (position) {
                    _customInfoWindowController.onCameraMove!();
                  },
                ),
                CustomInfoWindow(
                  controller: _customInfoWindowController,
                  height: 100,
                  width: 200,
                  offset: 50,
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return BottomSheetContent(
                onLocationSubmitted: (source, destination) {
                  setState(() {
                    _sourceLocation = source;
                    _destinationLocation = destination;
                    polylines.clear();
                  });
                  getPolylinePoints().then((coordinates) {
                    generatePolyLineFromPoints(coordinates);
                  });
                },
              );
            },
          );
        },
        child: const Icon(Icons.directions),
      ),
    );
  }

  Future<void> _initializeMap() async {
    await getLocationUpdates();
  }

  Future<void> _loadCustomMarker() async {
    final BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/pothole.png',
    );
    setState(() {
      _customIcon = customIcon;
    });
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition newCameraPosition = CameraPosition(
      target: pos,
      zoom: 15,
    );
    if (mounted) {
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(newCameraPosition),
      );
    }
  }

  Future<void> getLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

/*    _locationSubscription = _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        LatLng newLocation = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        if (_previousP == null || _calculateDistance(_previousP!, newLocation) > 10) {
          _previousP = newLocation;
          if (mounted) {
            setState(() {
              _currentP = newLocation;
              _cameraToPosition(_currentP!);
            });
          }
        }
      }
    });*/
  }

  double _calculateDistance(LatLng start, LatLng end) {
    const double R = 6371; // Radius of the Earth in km
    double dLat = _degreeToRadian(end.latitude - start.latitude);
    double dLon = _degreeToRadian(end.longitude - start.longitude);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreeToRadian(start.latitude)) *
            cos(_degreeToRadian(end.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c * 1000; // Distance in meters
  }

  double _degreeToRadian(double degree) {
    return degree * pi / 180;
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];

    if (_sourceLocation == null || _destinationLocation == null) {
      return polylineCoordinates;
    }

    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: maps,
      request: PolylineRequest(
        origin: PointLatLng(_sourceLocation!.latitude, _sourceLocation!.longitude),
        destination: PointLatLng(_destinationLocation!.latitude, _destinationLocation!.longitude),
        mode: TravelMode.driving,
      ),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.black,
      points: polylineCoordinates,
      width: 8,
    );
    setState(() {
      polylines[id] = polyline;
    });
  }

  Set<Marker> _buildMarkers(List<Report> reports) {
    Set<Marker> markers = {};
    for (var report in reports) {
      markers.add(
        Marker(
          icon: _customIcon ?? BitmapDescriptor.defaultMarker,
          markerId: MarkerId(report.caseId),
          position: LatLng(report.latitude, report.longitude),
          onTap: () {
            _customInfoWindowController.addInfoWindow!(
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                width: double.infinity,
                height: double.infinity,
                child: InkWell(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                            image: DecorationImage(
                              image: NetworkImage(report.imageURL), // Replace with your image URL field
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Colors.black38,
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            report.description,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return ReportDetail(report: report);
                    },
                  ));
                },),
              ),
              LatLng(report.latitude, report.longitude),
            );
          },
        ),
      );
    }
    return markers;
  }
}

class BottomSheetContent extends StatefulWidget {
  final Function(LatLng source, LatLng destination) onLocationSubmitted;

  BottomSheetContent({required this.onLocationSubmitted});

  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _sourceController,
            decoration: const InputDecoration(
              labelText: 'Source Location',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _destinationController,
            decoration: const InputDecoration(
              labelText: 'Destination Location',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Convert the entered text to LatLng
              LatLng source = _convertToLatLng(_sourceController.text);
              LatLng destination = _convertToLatLng(_destinationController.text);

              widget.onLocationSubmitted(source, destination);
              Navigator.pop(context);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  LatLng _convertToLatLng(String location) {
    // For simplicity, assuming the input format is 'latitude,longitude'
    List<String> parts = location.split(',');
    double latitude = double.parse(parts[0].trim());
    double longitude = double.parse(parts[1].trim());
    return LatLng(latitude, longitude);
  }
}

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:job_seeker/ViewModels/authority_provider.dart';
import 'package:job_seeker/Views/job_gloabelclass/job_icons.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../../Utils/constants.dart';
import '../../ViewModels/report_provider.dart';
import '../job_pages/job_application/job_applicationstages.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location _locationController = Location();
  Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
  StreamSubscription<LocationData>? _locationSubscription;

  static const LatLng _pGooglePlex = LatLng(36.407866, 10.561065);
  static const LatLng _pApplePark = LatLng(36.379215, 10.538584);
  LatLng? _currentP;
  LatLng? _previousP;
  LatLng? _sourceLocation;
  LatLng? _destinationLocation;

  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthorityProvider>(context, listen: false).fetchAllReports();
    });
    _initializeMap();
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
                : GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                if (!_mapController.isCompleted) {
                  _mapController.complete(controller);
                }
              },
              initialCameraPosition: CameraPosition(
                target: _pGooglePlex,
                zoom: 15,
              ),
              markers: reportProvider.reports.map((report) {
               // BitmapDescriptor icon = BitmapDescriptor.asset(ImageConfiguration(), JobPngimage.logo) as BitmapDescriptor;

                return Marker(
                //  icon:  ,
                  markerId: MarkerId(report.caseId),
                  position: LatLng(report.latitude,report.longitude),
                  infoWindow: InfoWindow(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return  ReportDetail(report: report);
                        },
                      ));
                    },
                    title: report.description,
                    snippet: report.address,
                  ),
                );
              }).toSet(),
              polylines: Set<Polyline>.of(polylines.values),
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
        child: Icon(Icons.directions),
      ),
    );
  }

  Future<void> _initializeMap() async {
    await getLocationUpdates();
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 15,
    );
    if (mounted) {
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(_newCameraPosition),
      );
    }
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationSubscription = _locationController.onLocationChanged.listen((LocationData currentLocation) {
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
    });
  }

  double _calculateDistance(LatLng start, LatLng end) {
    const double R = 6371; // Radius of the Earth in km
    double dLat = _degreeToRadian(end.latitude - start.latitude);
    double dLon = _degreeToRadian(end.longitude - start.longitude);
    double a = sin(dLat/2) * sin(dLat/2) +
            cos(_degreeToRadian(start.latitude)) * cos(_degreeToRadian(end.latitude)) *
                sin(dLon/2) * sin(dLon/2);
    double c = 2 * atan2(sqrt(a), sqrt(1-a));
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
    PolylineId id = PolylineId("poly");
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
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _sourceController,
            decoration: InputDecoration(
              labelText: 'Source Location',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _destinationController,
            decoration: InputDecoration(
              labelText: 'Destination Location',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Convert the entered text to LatLng
              LatLng source = _convertToLatLng(_sourceController.text);
              LatLng destination = _convertToLatLng(_destinationController.text);

              widget.onLocationSubmitted(source, destination);
              Navigator.pop(context);
            },
            child: Text('Submit'),
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

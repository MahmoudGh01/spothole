import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';

import '../../Utils/constants.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location _locationController = Location();
  Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();

  static const LatLng _pGooglePlex = LatLng(36.407866, 10.561065);
  static const LatLng _pApplePark = LatLng(36.379215, 10.538584);
  LatLng? _currentP;

  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
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
    _locationController.onLocationChanged.drain(); // Cancel location updates
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              markers: {
                Marker(
                  markerId: const MarkerId("_currentLocation"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: _currentP!,
                ),
                Marker(
                  markerId: const MarkerId("_sourceLocation"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure),
                  position: _pGooglePlex,
                ),
                Marker(
                  markerId: const MarkerId("_destionationLocation"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure),
                  position: _pApplePark,
                )
              },
              polylines: Set<Polyline>.of(polylines.values),
            );
          }
        },
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
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
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

    _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        setState(() {

          _currentP = LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _cameraToPosition(_currentP!);
          print(_currentP);
        });
      }
    });
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];

    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: maps,
      request: PolylineRequest(
        origin: PointLatLng(_pGooglePlex.latitude, _pGooglePlex.longitude),
        destination: PointLatLng(_pApplePark.latitude, _pApplePark.longitude),
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

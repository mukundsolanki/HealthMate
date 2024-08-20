import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  LatLng? _currentPosition;
  Location location = Location();

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    LocationData _locationData = await location.getLocation();

    setState(() {
      _currentPosition = LatLng(_locationData.latitude!, _locationData.longitude!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map Page"),
      ),
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (controller) {
                mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 14.0,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('currentLocation'),
                  position: _currentPosition!,
                  infoWindow: InfoWindow(title: 'Your Location'),
                ),
              },
            ),
    );
  }
}

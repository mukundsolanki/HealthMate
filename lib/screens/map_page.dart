import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  LatLng? _currentPosition;
  Location location = Location();
  Set<Marker> _markers = {};
  String _selectedPlaceType = 'all';

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

    _getNearbyPlaces();
  }

  Future<void> _getNearbyPlaces() async {
    final String apiKey = 'Api_key';
    final String baseUrl = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
    final String location = '${_currentPosition!.latitude},${_currentPosition!.longitude}';
    final int radius = 1500; 

    final Map<String, List<String>> placeTypesMap = {
      'all': ['gym', 'hospital', 'pharmacy'],
      'gym': ['gym'],
      'hospital': ['hospital'],
      'pharmacy': ['pharmacy'],
    };

    _markers.clear();

    for (String type in placeTypesMap[_selectedPlaceType]!) {
      final String url = '$baseUrl?location=$location&radius=$radius&type=$type&key=$apiKey';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        for (var result in results) {
          final LatLng position = LatLng(
            result['geometry']['location']['lat'],
            result['geometry']['location']['lng'],
          );

          setState(() {
            _markers.add(
              Marker(
                markerId: MarkerId(result['place_id']),
                position: position,
                infoWindow: InfoWindow(
                  title: result['name'],
                  snippet: result['vicinity'],
                ),
              ),
            );
          });
        }
      } else {
        print('Failed to fetch places: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map Page"),
      ),
      body: Stack(
        children: [
          _currentPosition == null
              ? Center(child: CircularProgressIndicator())
              : GoogleMap(
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition!,
                    zoom: 14.0,
                  ),
                  markers: _markers,
                ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              color: Colors.white,
              child: DropdownButton<String>(
                value: _selectedPlaceType,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPlaceType = newValue!;
                    _getNearbyPlaces();
                  });
                },
                items: <String>['all', 'gym', 'hospital', 'pharmacy']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value[0].toUpperCase() + value.substring(1)),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MapPage(),
  ));
}

// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
// import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Leaflet GPS Tracking',
      home: MyHomePage(title: 'Flutter Leaflet GPS Tracking'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MapController _mapController = MapController();
  LocationData? _currentLocation;
  Location _location = Location();
  List<LatLng> _points = [];

  @override
  void initState() {
    super.initState();
    _location.onLocationChanged.listen((LocationData locationData) {
      setState(() {
        _currentLocation = locationData;
        _points.add(LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Map"),
      ),
      body: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: LatLng(0, 0),
                zoom: 13.0,
              ),
              children: [
                TileLayer(
                  
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                    // tileProvider: CachedNetworkTileProvider(),
                    userAgentPackageName: 'com.example.app',
                ),
                // PolylineLayerOptions(
                //   polylines: [
                //     Polyline(
                //       points: _points,
                //       strokeWidth: 4.0,
                //       color: Colors.blue,
                //     ),
                //   ],
                // ),
                PolylineLayer(
                    polylineCulling: false,
                    polylines: [
                        Polyline(
                          points: _points,
                          // points: [LatLng(30, 40), LatLng(20, 50), LatLng(25, 45),],
                          strokeWidth: 4.0,
                          color: Colors.blue,
                        ),
                    ],
                ),
                MarkerLayer(
                  markers: _currentLocation == null
                      ? []
                      : [
                          Marker(
                            width: 80.0,
                            height: 80.0,
                            point: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
                            builder: (ctx) => Container(
                              child: Icon(Icons.location_on),
                            ),
                          ),
                        ],
                ),
              ],
      ),
    );
  }
}
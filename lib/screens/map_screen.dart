import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsScreen extends StatefulWidget {
  final String? lat;
  final String? lng;

  const GoogleMapsScreen(this.lat, this.lng, {super.key});

  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  late CameraPosition _cameraPosition;
  late Set<Marker> _markers;
  late MarkerId _markerId;

  @override
  void initState() {
    super.initState();
    _cameraPosition = CameraPosition(
        target: LatLng(
          double.parse(widget.lat.toString()),
          double.parse(widget.lng.toString()),
        ),
        zoom: 15);
    _markers = {};
    _markerId = MarkerId(widget.lat.toString() + widget.lng.toString());
    _markers.add(
      Marker(
        markerId: _markerId,
        position: LatLng(
          double.parse(widget.lat.toString()),
          double.parse(widget.lng.toString()),
        ),
        infoWindow: const InfoWindow(
          title: 'Your Location',
          snippet: '...',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Map"),
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: _cameraPosition,
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          Future.delayed(const Duration(microseconds: 500), () {
            controller.showMarkerInfoWindow(_markerId);
          });
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToLocation,
        label: const Text("To your Location"),
        icon: const Icon(Icons.directions_car),
      ),
    );
  }

  Future<void> _goToLocation() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        _cameraPosition,
      ),
    );
  }
}

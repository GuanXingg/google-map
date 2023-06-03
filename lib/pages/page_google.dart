import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constants/const_color.dart';
import '../utils/current_location.dart';
import '../utils/custom_logger.dart';

class GooglePage extends StatefulWidget {
  const GooglePage({super.key});

  @override
  State<GooglePage> createState() => _GooglePageState();
}

class _GooglePageState extends State<GooglePage> {
  final Completer<GoogleMapController> kGgController = Completer<GoogleMapController>();

  final Set<Marker> markers = {};
  final Set<Circle> circles = {};
  final Set<Polyline> polylines = {};
  final Set<Polygon> polygons = {};

  LatLng? _initPos;

  void clearShape({bool marker = true, bool circle = true, bool polyline = true, bool polygon = true}) {
    if (marker) markers.clear();
    if (circle) circles.clear();
    if (polyline) polylines.cast();
    if (polygon) polygons.clear();
  }

  Future<void> _loadData() async {
    try {
      final currentPos = await getCurrentLocation();
      setState(() => _initPos = currentPos);
    } catch (err) {
      CLogger().error('>>> An occurred while load app resources, log: $err');
      setState(() => _initPos = const LatLng(0, 0));
    }
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_initPos == null)
          ? SpinKitRing(color: AppColor.highlight)
          : GoogleMap(
              initialCameraPosition: CameraPosition(target: _initPos!, zoom: 15),
              onMapCreated: (controller) => kGgController.complete(controller),
              markers: markers,
              circles: circles,
              polylines: polylines,
              polygons: polygons,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
            ),
    );
  }
}

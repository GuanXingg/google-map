import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Circle currentCircle(LatLng pos) {
  return Circle(
    circleId: const CircleId('cir-current'),
    center: pos,
    radius: 300,
    fillColor: Colors.blue.withOpacity(0.3),
    strokeColor: Colors.transparent,
  );
}

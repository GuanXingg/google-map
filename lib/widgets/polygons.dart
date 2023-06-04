import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Polygon customPolygon(String id, String color, List<LatLng> points) {
  return Polygon(
    polygonId: PolygonId(id),
    points: points,
    strokeColor: Colors.black.withOpacity(0.6),
    strokeWidth: 2,
    fillColor: Color(int.parse(color)).withOpacity(0.2),
  );
}

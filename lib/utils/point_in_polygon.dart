import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:point_in_polygon/point_in_polygon.dart';

bool checkPointInPolygon(LatLng point, List<LatLng> polygon) {
  final Point convertPoint = Point(x: point.latitude, y: point.longitude);
  final List<Point> convertPolygon = polygon.map((el) => Point(x: el.latitude, y: el.longitude)).toList();

  return Poly.isPointInPolygon(convertPoint, convertPolygon);
}

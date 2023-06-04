import 'package:google_maps_flutter/google_maps_flutter.dart';

LatLngBounds getBoundView(List<LatLng> listPoint) {
  final double minLat = listPoint.reduce((v, e) => (v.latitude < e.latitude) ? v : e).latitude;
  final double minLong = listPoint.reduce((v, e) => (v.longitude < e.longitude) ? v : e).longitude;
  final double maxLat = listPoint.reduce((v, e) => (v.latitude < e.latitude) ? e : v).latitude;
  final double maxLong = listPoint.reduce((v, e) => (v.longitude < e.longitude) ? e : v).longitude;

  return LatLngBounds(southwest: LatLng(minLat, minLong), northeast: LatLng(maxLat, maxLong));
}

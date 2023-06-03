import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<Position> _checkPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return Future.error('Location services are disabled.');

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return Future.error('Location permissions are denied');
  }

  if (permission == LocationPermission.deniedForever)
    return Future.error('Location permissions are permanently denied, we cannot request permissions.');

  return await Geolocator.getCurrentPosition();
}

Future<LatLng> getCurrentLocation() async {
  Position position = await _checkPermission();
  return LatLng(position.latitude, position.longitude);
}

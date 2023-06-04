import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_routes/google_maps_routes.dart';

Future<PointDistance> calculateDistance(LatLng fromPos, LatLng desPos) async {
  final DistanceCalculator distanceCalculator = DistanceCalculator();
  final String distanceRes = distanceCalculator.calculateRouteDistance([fromPos, desPos], decimals: 3);
  final double distance = double.parse(distanceRes.split(' ')[0]);

  final Map<String, dynamic> item = {
    'point': desPos,
    'distance': distance,
    'description': distanceRes,
  };

  return PointDistance.fromJson(item);
}

class PointDistance {
  late LatLng point;
  late double distance;
  late String description;

  PointDistance({required this.point, required this.distance, required this.description});

  PointDistance.fromJson(Map<String, dynamic> json) {
    point = json['point'];
    distance = json['distance'];
    description = json['description'];
  }
}

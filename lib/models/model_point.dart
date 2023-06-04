import 'package:google_maps_flutter/google_maps_flutter.dart';

class PointModel {
  late String name;
  late LatLng point;

  PointModel({required this.name, required this.point});

  PointModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    point = json['point'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['point'] = point;

    return data;
  }
}

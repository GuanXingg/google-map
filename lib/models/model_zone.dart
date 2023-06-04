import 'package:google_maps_flutter/google_maps_flutter.dart';

import './model_point.dart';

class ZoneModel {
  late String name;
  late String color;
  late List<LatLng> zone;
  late List<PointModel> pointList;

  ZoneModel({required this.name, required this.color, required this.zone, required this.pointList});

  ZoneModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    color = json['color'];
    zone = json['zone'];
    pointList = (json['pointList'] as List).map((el) => PointModel.fromJson(el)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['color'] = color;
    data['zone'] = zone;
    data['pointList'] = pointList.map((el) => el.toJson()).toList();

    return data;
  }
}

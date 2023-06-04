import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/model_coupon.dart';

class PointModel {
  late String name;
  late LatLng point;
  List<CouponModel>? couponList;

  PointModel({required this.name, required this.point, this.couponList});

  PointModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    point = json['point'];
    couponList = json['couponList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['point'] = point;
    data['couponList'] = couponList;

    return data;
  }
}

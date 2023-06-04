import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/model_coupon.dart';

Future<List<CouponModel>> handleCouponFile(Map<String, dynamic> rawFile) async {
  final SharedPreferences shared = await SharedPreferences.getInstance();
  final List<Map<String, dynamic>> couponDataList = [];

  final List<dynamic> rawCouponList = rawFile['coupons'];
  for (dynamic el in rawCouponList) {
    final Map<String, dynamic> item = {
      'id': el['id'],
      'name': el['name'],
      'description': el['description'],
      'place': el['place'],
      'expired': el['expired'],
    };
    couponDataList.add(item);
  }

  final List<Map<String, dynamic>> storeCouponDataList = couponDataList;
  final String encodeCouponDataList = jsonEncode(storeCouponDataList);
  await shared.setString('couponData', encodeCouponDataList);

  return couponDataList.map((e) => CouponModel.fromJson(e)).toList();
}

Future<List<CouponModel>?> firstLoadCouponData() async {
  final SharedPreferences shared = await SharedPreferences.getInstance();
  final List<CouponModel> couponDataList = [];

  final String? rawCouponData = shared.getString('couponData');
  if (rawCouponData == null) return null;

  final List<dynamic> parseCoupoonData = jsonDecode(rawCouponData);
  for (dynamic el in parseCoupoonData) {
    final Map<String, dynamic> item = {
      'id': el['id'],
      'name': el['name'],
      'description': el['description'],
      'place': el['place'],
      'expired': el['expired'],
    };
    couponDataList.add(CouponModel.fromJson(item));
  }

  return couponDataList;
}

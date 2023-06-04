import '../../models/model_coupon.dart';

Future<List<CouponModel>> handleCouponFile(Map<String, dynamic> rawFile) async {
  final List<CouponModel> couponDataList = [];

  final List<dynamic> rawCouponList = rawFile['coupons'];
  for (dynamic el in rawCouponList) {
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

import 'package:flutter/material.dart';

import '../../models/model_coupon.dart';
import '../../pages/page_coupon_list.dart';

PageRouteBuilder animateCouponListPage(List<CouponModel> couponList) {
  return PageRouteBuilder(
    pageBuilder: (_, __, ___) => CouponListPage(couponList: couponList),
    transitionDuration: const Duration(milliseconds: 500),
    transitionsBuilder: (_, animation, __, child) {
      const Offset begin = Offset(0.0, 1.0);
      const Offset end = Offset.zero;
      const Curve curve = Curves.ease;

      final Tween<Offset> tween = Tween(begin: begin, end: end);
      final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

      return SlideTransition(position: tween.animate(curvedAnimation), child: child);
    },
  );
}

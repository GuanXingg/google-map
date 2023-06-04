import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/const_color.dart';
import '../constants/const_space.dart';
import '../constants/const_typography.dart';
import '../functions/coupon_detail/animate_page.dart';
import '../models/model_coupon.dart';

class CouponListPage extends StatelessWidget {
  final List<CouponModel> couponList;

  const CouponListPage({super.key, required this.couponList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 20),
          child: Text('Coupon', style: AppText.title),
        ),
        const SizedBox(height: AppSpace.primary),
        Expanded(
            child: ListView.builder(
          itemCount: couponList.length,
          itemBuilder: (context, index) => ListTile(
            onTap: () => Navigator.push(context, animateCouponDetailPage(couponList[index])),
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRounded.primary),
                color: AppColor.highlight,
              ),
              child: Image.network(
                fit: BoxFit.cover,
                'https://static.vecteezy.com/system/resources/thumbnails/002/331/963/small/20-percent-off-sale-tag-sale-of-special-offers-discount-with-the-price-is-20-percent-vector.jpg',
              ),
            ),
            title: Text(couponList[index].name, style: AppText.standard),
            subtitle: Text(
              'Valid until ${DateFormat('dd-MM-yyyy').format(DateTime.parse(couponList[index].expired))}',
              style: AppText.label.copyWith(color: AppColor.unActive, fontStyle: FontStyle.italic),
            ),
          ),
        ))
      ]),
    );
  }
}

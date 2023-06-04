import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/model_coupon.dart';
import '../constants/const_color.dart';
import '../constants/const_space.dart';
import '../constants/const_typography.dart';
import '../utils/custom_logger.dart';
import '../widgets/custom_alert.dart';

class CouponDetailPage extends StatefulWidget {
  final CouponModel couponItem;

  const CouponDetailPage({super.key, required this.couponItem});

  @override
  State<CouponDetailPage> createState() => _CouponDetailPageState();
}

class _CouponDetailPageState extends State<CouponDetailPage> {
  Future<void> onTapGoToWebSite() async {
    try {
      final Uri url = Uri.parse('https://github.com/GuanXingg');
      if (!await launchUrl(url)) throw 'Error browse to website';
    } catch (err) {
      CLogger().error('>>> An occurred while browse to website!!!, log: $err');
      CAlert.error(context, content: 'Can not browse to website');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              width: double.infinity,
              height: 180,
              child: Image.network(
                fit: BoxFit.cover,
                'https://static.vecteezy.com/system/resources/thumbnails/002/331/963/small/20-percent-off-sale-tag-sale-of-special-offers-discount-with-the-price-is-20-percent-vector.jpg',
              ),
            ),
            const SizedBox(height: AppSpace.secondary),
            Padding(
              padding: const EdgeInsets.only(left: AppSpace.primary, right: AppSpace.primary, bottom: 100),
              child: Column(children: [
                Text('Valid until ${DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.couponItem.expired))}',
                    style: AppText.heading),
                const SizedBox(height: AppSpace.primary),
                Text('\t${widget.couponItem.description}',
                    textAlign: TextAlign.justify, style: AppText.primary.copyWith()),
              ]),
            ),
          ]),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: AppColor.unActive, blurRadius: 5, offset: const Offset(0, -2))],
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpace.primary),
              child: TextButton(
                onPressed: onTapGoToWebSite,
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(AppColor.primary),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRounded.primary)),
                  ),
                ),
                child: Text('Go to website', style: AppText.primary.copyWith(color: Colors.white)),
              ),
            ),
          ),
        )
      ]),
    );
  }
}

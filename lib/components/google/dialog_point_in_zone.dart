import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../constants/const_color.dart';
import '../../constants/const_space.dart';
import '../../constants/const_typography.dart';
import '../../functions/coupon/animate_page.dart';
import '../../models/model_point.dart';

class DialogPointInZone extends StatelessWidget {
  final List<PointModel> pointList;
  final void Function(LatLng) onTap;

  const DialogPointInZone({super.key, required this.pointList, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Padding(
      padding: const EdgeInsets.all(AppSpace.primary),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('Closest place', style: AppText.title),
        const SizedBox(height: AppSpace.primary),
        Expanded(
          child: ListView.builder(
            itemCount: pointList.length,
            itemBuilder: (_, index) => ListTile(
              onTap: () => (pointList[index].couponList == null)
                  ? null
                  : Navigator.push(context, animateCouponListPage(pointList[index].couponList!)),
              leading: Icon(Icons.location_on,
                  size: 30, color: (pointList[index].couponList == null) ? Colors.red : AppColor.primary),
              trailing: IconButton(onPressed: () => onTap(pointList[index].point), icon: const Icon(Icons.send)),
              title: Text(pointList[index].name, style: AppText.standard),
              subtitle: Text(
                (pointList[index].couponList == null) ? '' : 'Have ${pointList[index].couponList!.length} coupon',
                style: AppText.label.copyWith(color: AppColor.unActive, fontStyle: FontStyle.italic),
              ),
            ),
          ),
        )
      ]),
    ));
  }
}

import 'package:flutter/material.dart';

import '../../constants/const_color.dart';
import '../../constants/const_space.dart';
import '../../constants/const_typography.dart';
import '../../models/model_point.dart';

class DialogPointInZone extends StatelessWidget {
  final List<PointModel> pointList;

  const DialogPointInZone({super.key, required this.pointList});

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
              leading: const Icon(Icons.location_on, size: 30, color: Colors.red),
              title: Text(pointList[index].name, style: AppText.standard),
              subtitle: Text(
                'Have 4 coupon',
                style: AppText.label.copyWith(color: AppColor.unActive, fontStyle: FontStyle.italic),
              ),
            ),
          ),
        )
      ]),
    ));
  }
}

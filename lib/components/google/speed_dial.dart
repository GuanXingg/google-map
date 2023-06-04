import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../constants/const_color.dart';
import '../../constants/const_space.dart';

class MapSpeedDial extends StatelessWidget {
  final void Function() onTapShowAllZone;
  final void Function() onTapClosestZone;

  const MapSpeedDial({super.key, required this.onTapShowAllZone, required this.onTapClosestZone});

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      spaceBetweenChildren: AppSpace.primary,
      children: [
        _dialChild(
          onTap: onTapShowAllZone,
          label: 'Show all area',
          bgColor: AppColor.highlight,
          icon: Icons.area_chart,
        ),
        _dialChild(
          onTap: onTapClosestZone,
          label: 'Closest zone',
          bgColor: Colors.purple,
          icon: Icons.near_me,
        ),
      ],
      activeChild: const Icon(Icons.arrow_drop_down, size: 35),
      child: const Icon(Icons.arrow_drop_up, size: 35),
    );
  }

  SpeedDialChild _dialChild({
    required void Function() onTap,
    required String label,
    required Color bgColor,
    required IconData icon,
  }) {
    return SpeedDialChild(
      onTap: onTap,
      backgroundColor: bgColor,
      label: label,
      labelShadow: [],
      labelBackgroundColor: Colors.transparent,
      child: Icon(icon, color: Colors.white),
    );
  }
}

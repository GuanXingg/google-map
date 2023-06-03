import 'package:flutter/material.dart';

import '../constants/const_color.dart';

class FunctionItem extends StatelessWidget {
  final double size;
  final Color color;
  final IconData icon;
  final Color? iconColor;
  final double? iconSize;
  final void Function() onTap;

  const FunctionItem({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 40,
    this.color = Colors.white,
    this.iconSize,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: size, minHeight: size),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: AppColor.unActive, blurRadius: 5, offset: const Offset(0, 2))],
        color: color,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Icon(icon, size: iconSize, color: iconColor),
      ),
    );
  }
}

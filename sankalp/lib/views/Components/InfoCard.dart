import 'package:flutter/material.dart';
import 'package:sankalp/utils/constants.dart';

class InfoCard extends StatelessWidget {
  final Color color;
  final Widget child;
  final VoidCallback? onTap;

  const InfoCard({
    required this.color,
    required this.child,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(ScreenSize.getWidth(context)*0.045),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(ScreenSize.getWidth(context)*0.04),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(ScreenSize.getWidth(context)*0.045),
        ),
        child: child,
      ),
    );
  }
}

import 'package:flutter/material.dart';

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
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: child,
      ),
    );
  }
}

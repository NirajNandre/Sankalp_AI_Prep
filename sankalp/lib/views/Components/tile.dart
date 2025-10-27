import 'package:flutter/material.dart';
import 'package:sankalp/utils/constants.dart';

class ProfileTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ProfileTile({
    required this.title,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: ScreenSize.getHeight(context) * 0.065,
        margin: EdgeInsets.only(bottom: ScreenSize.getHeight(context) * 0.012),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(237, 241, 243, 100),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: ScreenSize.getWidth(context) * 0.04),
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: ScreenSize.getWidth(context) * 0.042),
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(right: ScreenSize.getWidth(context) * 0.04),
              child: Icon(Icons.chevron_right, color: Colors.black, size: ScreenSize.getWidth(context) * 0.07),
            ),
          ],
        ),
      ),
    );
  }
}

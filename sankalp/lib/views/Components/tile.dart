import 'package:flutter/material.dart';

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
        height: 50,
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Color.fromRGBO(237, 241, 243, 100),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 17),
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(right: 17),
              child: Icon(Icons.chevron_right, color: Colors.black, size: 28),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomButtons extends StatelessWidget {
  final VoidCallback musicButtonOnPressed;
  final VoidCallback profileButtonOnPressed;

  const BottomButtons({
    Key? key,
    required this.musicButtonOnPressed,
    required this.profileButtonOnPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.blue, // Set the color to blue
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: musicButtonOnPressed,
              child: Icon(
                FontAwesomeIcons.music,
                size: 30,
                color: Colors.black,
              ),
            ),
          ),
          VerticalDivider(
            width: 1,
            color: Colors.white,
          ),
          Expanded(
            child: InkWell(
              onTap: profileButtonOnPressed,
              child: Icon(
                Icons.person,
                size: 30,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

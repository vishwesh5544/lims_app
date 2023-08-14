import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/color_provider.dart';
import '../utils/text_utility.dart';

class CommonHeader extends StatelessWidget {
  String title;
  CommonHeader({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(color: ColorProvider.blueDarkShade),
      // margin: EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextUtility.getStyle(18.0, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

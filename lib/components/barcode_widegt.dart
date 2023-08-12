import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/barcode_utility.dart';

Widget barCodeWidget({required String text, required String barCode}) {
  return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(fontSize: 10),
        ),
        Container(
          padding: const EdgeInsets.all(6),
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          child: SvgPicture.string(
            BarcodeUtility.getBarcodeSvgString(barCode),
            width: 80,
            height: 40,
          ),
        )
      ]);
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/barcode_utility.dart';

Widget barCodeWidget({required String text, required String barCode}) {
  return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          width: 160,
          height: 80,
          child: SvgPicture.string(
            BarcodeUtility.getBarcodeSvgString(barCode),
            fit: BoxFit.fill,
          ),
        )
      ]);
}

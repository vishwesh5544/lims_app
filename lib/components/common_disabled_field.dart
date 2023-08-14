import 'package:flutter/material.dart';
import 'package:lims_app/utils/color_provider.dart';
import 'package:lims_app/utils/text_utility.dart';

class CommonGreyFiled extends StatelessWidget {
  final String title, value;
  final double? width;
  const CommonGreyFiled(
      {required this.title, required this.value, Key? key, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextUtility.getBoldStyle(13, color: Colors.black)),
        const SizedBox(height: 6),
        Container(
          width: width,
          decoration: BoxDecoration(
              color: ColorProvider.lightGreyColor,
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          child: TextField(
            enabled: false,
            readOnly: true,
            decoration: InputDecoration(
              constraints: const BoxConstraints(
                  maxWidth: 250, minWidth: 150, minHeight: 40, maxHeight: 45),
              border: const OutlineInputBorder(),
              fillColor: ColorProvider.lightGreyColor,
              hintText: value,
              hintStyle: const TextStyle(color: Colors.black),
              focusColor: ColorProvider.lightGreyColor,
            ),
          ),
        )
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lims_app/utils/color_provider.dart';
import 'package:lims_app/utils/text_utility.dart';

class CommonGreyFiled extends StatelessWidget {
  String title, value;
  CommonGreyFiled({required this.title, required this.value, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextUtility.getStyle(13)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
              color: ColorProvider.lightGreyColor,
              borderRadius: const BorderRadius.all(Radius.circular(5))
          ),
          child: TextField(
            enabled: false,
            readOnly: true,
            decoration: InputDecoration(
              constraints: const BoxConstraints(maxWidth: 250, minWidth: 150, minHeight: 40, maxHeight: 45),
              border: const OutlineInputBorder(),
              fillColor: Colors.grey,
              hintText: value,
              focusColor: Colors.grey,
            ),
          ),
        )
      ],
    );
  }
}

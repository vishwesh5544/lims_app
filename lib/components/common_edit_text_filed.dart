import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:lims_app/utils/color_provider.dart';

import '../utils/strings/add_patient_strings.dart';
import '../utils/text_utility.dart';
import '../utils/utils.dart';

class CommonEditText extends StatelessWidget {
  Function onChange;
  Function? onSubmit;
  TextEditingController controller;
  String hintText;
  String title;
  final List<TextInputFormatter>? inputFormatters;
  final List<FormFieldValidator<String>>? validators;
  final String name;
  final bool readOnly;
  final bool required;

  CommonEditText({
    required this.name,
    required this.onChange,
    required this.title,
    this.onSubmit,
    required this.controller,
    required this.hintText,
    this.inputFormatters,
    this.validators,
    this.readOnly = false,
    this.required = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextUtility.getStyle(13)),
        const SizedBox(height: 6),
        FormBuilderTextField(
          name: name,
          readOnly: readOnly,
          validator: FormBuilderValidators.compose([
            if (required) FormBuilderValidators.required(),
            if (validators != null) ...validators!,
          ]),
          controller: controller,
          style: TextUtility.getStyle(14, color: ColorProvider.darkGreyColor),
          onChanged: (value) {
            onChange.call(value);
          },
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
              hintStyle:
                  TextUtility.getStyle(14, color: ColorProvider.darkGreyColor),
              constraints: const BoxConstraints(
                maxWidth: 260,
                minWidth: 180,
                minHeight: 35,
              ),
              border: getOutLineBorder(),
              focusedErrorBorder: getOutLineBorder(),
              errorBorder: getOutLineBorder(),
              disabledBorder: getOutLineBorder(),
              enabledBorder: getOutLineBorder(),
              focusedBorder: getOutLineBorder(),
              hintText: hintText),
        )
      ],
    );
  }

// getBorder(){
//   return OutlineInputBorder(borderSide: BorderSide(color: ColorProvider.greyColor, width: 0.2),);
// }
}

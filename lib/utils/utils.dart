import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lims_app/utils/text_utility.dart';

import 'color_provider.dart';

showToast({String msg = ""}){
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      fontSize: 16.0
  );
}

commonBtn({String text = "Next", Color? bgColor, bool isEnable = false, required Function calll}){
  bgColor = bgColor??ColorProvider.blueDarkShade;
 return GestureDetector(
    onTap: (){
      calll.call();
    },
    child: Container(
        height: 45,
        width: 140,
        decoration: BoxDecoration(
            border: Border.all(
                color: ColorProvider.blueDarkShade,
                width: 2
            ),
            color: isEnable ? bgColor : Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(5))
        ),
        child: Center(child: Text(text, style:
        TextUtility.getBoldStyle(16, color: isEnable? Colors.white: Colors.black),))
    ),
  );
}
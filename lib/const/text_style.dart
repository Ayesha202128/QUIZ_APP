import 'package:flutter/material.dart';

Widget normalText({  //this is use in normal text
  String? text,
  Color? color,
  double? size,
}) {
  return Text(
    text!,
    style: TextStyle(
      fontFamily: "quick_semi",
      fontSize: size,
      color: color,
    ),
  );
}

Widget headingText({      //for heading
  String? text,
  Color? color,
  double? size,
}) {
  return Text(
    text!,
    style: TextStyle(
      fontFamily: "quick_bold",           //just change in bold
      fontSize: size,
      color: color,
    ),
  );
}

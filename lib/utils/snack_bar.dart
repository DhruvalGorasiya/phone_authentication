import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


snackBar({required BuildContext context, required String message, Color? color}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
    ),
  );
}

showToast({required String? msg}) {
  return Fluttertoast.showToast(
    msg: msg ?? "",
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

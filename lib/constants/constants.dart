import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Widget loadingWidget({double? size, double strokeWidth = 4}) {
  return Center(
    child: SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        color: Colors.black,
        strokeWidth: strokeWidth,
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

Widget otpField(
    {required BuildContext context,
    required int length,
    Function(String otp)? onCompleted,
    Function(String)? onChanged,
    Color? borderColor}) {
  return PinCodeTextField(
    length: 6,
    appContext: context,
    keyboardType: TextInputType.phone,
    cursorColor: Colors.black,
    backgroundColor: Colors.transparent,
    textStyle: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
    pinTheme: PinTheme(
      shape: PinCodeFieldShape.box,
      borderRadius: BorderRadius.circular(7),
      fieldHeight: MediaQuery.of(context).size.height * 0.05,
      fieldWidth: MediaQuery.of(context).size.height * 0.05,
      activeFillColor: Colors.white,
      selectedFillColor: Colors.white,
      // selectedColor: pink,
      selectedColor: Colors.black,
      // selectedColor: grey,
      inactiveColor: borderColor ?? Colors.black,
      activeColor: borderColor ?? Colors.black,
      inactiveFillColor: Colors.transparent,
    ),
    enableActiveFill: true,
    onCompleted: onCompleted,
    onChanged: onChanged,
  );
}

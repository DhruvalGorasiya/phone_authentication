import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phoneauthentication/constants/constants.dart';
import 'package:phoneauthentication/models/common_models.dart';
import 'package:phoneauthentication/utils/custom_print.dart';
import 'package:phoneauthentication/utils/snack_bar.dart';
import 'package:phoneauthentication/view/auth/otp_page.dart';
import 'package:phoneauthentication/view/auth/phone_page.dart';
import 'package:phoneauthentication/view/home_screen.dart';

class AuthVM extends ChangeNotifier {
  // PhonePage
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String phoneNumber = "";
  String dialCode = "+91";
  bool phoneNumberError = false;
  bool privacyPolicy = false;
  bool privacyPolicyError = false;
  bool phonePageLoading = false;
  String userName = "";

  // Phone Page init

  phonePageInit() {
    otpVerificationId = "";
    setPhoneNumber("");
    setPhonePageLoading(false);
    checkUserLoginStatus(navigatorKey.currentState!.context);
    notifyListeners();
  }

  setPhoneNumber(String val) {
    phoneNumber = val;
    notifyListeners();
  }

  setDialCode(String val) {
    dialCode = val;
    notifyListeners();
  }

  setPhonePageLoading(bool val) {
    phonePageLoading = val;
    notifyListeners();
  }

  void checkUserLoginStatus(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc =
            await _firestore.collection('Users').doc(user.uid).get();
        if (userDoc.exists && userDoc["name"] != null) {
          userName = userDoc["name"];
          notifyListeners();
          navigatorKey.currentState?.pushReplacementNamed(HomeScreen.name);
        } else {
          _askForUserName(context, user.uid);
        }
      } catch (e) {
        customPrint(e.toString());
      }
    } else {
      Future.delayed(Duration(seconds: 2));
      navigatorKey.currentState?.pushReplacementNamed(PhoneNumberPage.name);
    }
  }

  void _askForUserName(BuildContext context, String uid) {
    TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter Your Name"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: "Your Name"),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  userName = nameController.text;
                  notifyListeners();
                  await _firestore
                      .collection('Users')
                      .doc(uid)
                      .set({"name": userName});
                  navigatorKey.currentState?.pushReplacementNamed(
                      HomeScreen.name,
                      arguments: userName);
                }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  onTapPhoneContinue({required GlobalKey<FormState> formKey}) {
    // Send Code
    try {
      customPrint(
          "OTP SENT ====>> +$dialCode${phoneNumber.replaceAll(" ", "")}");
      setPhonePageLoading(true);
      FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+$dialCode${phoneNumber.replaceAll(" ", "")}",
        codeSent: (verificationId, forceResendingToken) {
          customPrint("verificationId $verificationId");
          customPrint("forceResendingToken === $forceResendingToken");

          showToast(msg: otpSendMessage);
          otpVerificationId = verificationId;
          navigatorKey.currentState?.pushNamed(
            OtpPage.name,
            arguments: OtpPageModel(
              dialCode: dialCode,
              number: phoneNumber,
            ),
          );
          setPhonePageLoading(false);
        },
        verificationCompleted: (phoneAuthCredential) {},
        verificationFailed: (error) {
          customPrint("Error ===>>> ${error.message}");
          setPhonePageLoading(false);
          showToast(msg: error.message);
        },
        codeAutoRetrievalTimeout: (verificationId) {
          customPrint("Otp Send Time Out");
          setPhonePageLoading(false);
          // showToast(msg: "Otp Send Time Out");
        },
      );
    } catch (e) {
      setPhonePageLoading(false);
      customPrint("Error : onTapPhoneContinue ==>> $e");
      showToast(msg: somethingWentWrong);
    }
  }

  // OtpPage

  int timerSeconds = 30;
  Timer? timer;
  bool otpError = false;
  bool otpPageLoading = false;
  bool otpSendAgainLoading = false;
  String otp = "";
  String otpVerificationId = "";

  // Otp page init

  otpPageInit() {
    timerSeconds = 30;
    setOtp("");
    setOtpError(false);
    setOtpPageLoading(false);
    notifyListeners();
    startTimer();
  }

  setOtpError(bool val) {
    otpError = val;
    notifyListeners();
  }

  setOtpPageLoading(bool val) {
    otpPageLoading = val;
    notifyListeners();
  }

  setOtpSendAgainLoading(bool val) {
    otpSendAgainLoading = val;
    notifyListeners();
  }

  setOtp(String val) {
    otp = val;
    notifyListeners();
  }

  bool get sendAgainCondition => timerSeconds == -1;

  bool get otpBtnCondition => otp.length != 6;

  void startTimer() {
    timerSeconds = 60;
    notifyListeners();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds >= 0) {
        timerSeconds--;
        notifyListeners();
      } else {
        timer.cancel();
        notifyListeners();
      }
    });
  }

  onTapSendAgain() {
    try {
      setOtpSendAgainLoading(true);
      FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "$dialCode${phoneNumber.replaceAll(" ", "")}",
        codeSent: (verificationId, forceResendingToken) {
          customPrint("verificationId $verificationId");
          customPrint("forceResendingToken === $forceResendingToken");
          setOtpSendAgainLoading(false);
          showToast(msg: otpReSendMessage);
          otpVerificationId = verificationId;
          timerSeconds = 30;
          startTimer();
          notifyListeners();
        },
        verificationCompleted: (phoneAuthCredential) {},
        verificationFailed: (error) {
          customPrint("Error ===>>> ${error.message}");
          setOtpSendAgainLoading(false);
          showToast(msg: error.message);
        },
        codeAutoRetrievalTimeout: (verificationId) {
          customPrint("Otp Send Time Out");
          setOtpSendAgainLoading(false);
        },
      );
    } catch (e) {
      setOtpSendAgainLoading(false);
      customPrint("Error : onTapSendAgain ==>> $e");
      showToast(msg: somethingWentWrong);
    }
  }

  onTapOtpContinue(
      {required OtpPageModel otpPageModel,
      required BuildContext context}) async {
    try {
      setOtpPageLoading(true);
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: otpVerificationId,
        smsCode: otp,
      );

      customPrint("verificationId ==>> $otpVerificationId, $otp");
      try {
        await FirebaseAuth.instance
            .signInWithCredential(phoneAuthCredential)
            .then(
          (value) async {
            if (value.user != null) {
              setOtpError(false);
              try {
                customPrint("woring");
                // showToast(msg: "SuccessFull!");
                // navigatorKey.currentState
                //     ?.pushReplacementNamed(HomeScreen.name);
                setOtpPageLoading(false);
                checkUserLoginStatus(context);
              } catch (e) {
                customPrint("Error : onTapOtpContinue ==>> $e");
                setOtpPageLoading(false);
                showToast(msg: "$somethingWentWrong\n${e.toString()}");
              }
            } else {
              setOtpPageLoading(false);
              setOtpError(true);
            }
          },
        );
      } on FirebaseAuthException catch (e) {
        customPrint("Error : onTapOtpContinue ==>> $e");
        setOtpPageLoading(false);
        setOtpError(true);
        showToast(msg: "${e.message}");
      }
    } catch (e) {
      customPrint("Error : onTapOtpContinue ==>> $e");
      setOtpPageLoading(false);
      showToast(msg: "$somethingWentWrong\n${e.toString()}");
    }
  }

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    navigatorKey.currentState?.pushReplacementNamed(PhoneNumberPage.name);
  }
}

const otpSendMessage = "otp has been send to your phone number";
const otpReSendMessage = "otp has been Re-send to your phone number";
const somethingWentWrong = "something went wrong";

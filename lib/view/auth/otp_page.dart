import 'package:flutter/material.dart';
import 'package:phoneauthentication/constants/constants.dart';
import 'package:phoneauthentication/models/common_models.dart';
import 'package:phoneauthentication/view/widgets/otp_field.dart';
import 'package:phoneauthentication/viewmodel/auth_vm.dart';
import 'package:provider/provider.dart';

class OtpPage extends StatefulWidget {
  static const name = "OtpPage";
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthVM>().otpPageInit();
    });
  }

  @override
  void deactivate() {
    super.deactivate();
    context.read<AuthVM>().timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    OtpPageModel arg =
        ModalRoute.of(context)?.settings.arguments as OtpPageModel;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Verify OTP',
          style: TextStyle(color: Colors.white),
        ),
      ),
      bottomNavigationBar: (context.watch<AuthVM>().otpPageLoading)
          ? Container(
              margin: const EdgeInsets.only(left: 16, right: 16),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width,
                child: loadingWidget(),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: ElevatedButton(
                  style: ButtonStyle(
                    padding: const WidgetStatePropertyAll(
                      EdgeInsets.symmetric(vertical: 20),
                    ),
                    backgroundColor: WidgetStatePropertyAll(
                        context.watch<AuthVM>().otpBtnCondition
                            ? Colors.grey.withOpacity(0.5)
                            : Colors.black),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                  onPressed: () {
                    context.read<AuthVM>().onTapOtpContinue(otpPageModel: arg,context: context);
                  },
                  child: const Text(
                    'Send OTP',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            otpField(
              context: context,
              length: 6,
              onChanged: (otp) {
                context.read<AuthVM>().setOtp(otp);
              },
              borderColor:
                  context.watch<AuthVM>().otpError ? Colors.red : Colors.black,
            ),
            Text(
              context.watch<AuthVM>().otpError
                  ? "The code entered is incorrect, please try again"
                  : "",
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

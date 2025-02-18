import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:phoneauthentication/constants/constants.dart';
import 'package:phoneauthentication/utils/custom_print.dart';
import 'package:phoneauthentication/viewmodel/auth_vm.dart';
import 'package:provider/provider.dart';

class PhoneNumberPage extends StatefulWidget {
  static const name = "PhoneNumberPage";
  const PhoneNumberPage({super.key});

  @override
  State<PhoneNumberPage> createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Phone Verification',
          style: TextStyle(color: Colors.white),
        ),
      ),
      bottomNavigationBar: (context.watch<AuthVM>().phonePageLoading)
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
                    backgroundColor: const WidgetStatePropertyAll(Colors.black),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                  onPressed: () {
                    context.read<AuthVM>().onTapPhoneContinue(formKey: key);
                  },
                  child: const Text(
                    'Send OTP',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IntlPhoneField(
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                initialCountryCode: 'IN',
                disableLengthCheck: false,
                onCountryChanged: (value) {
                  context.read<AuthVM>().setDialCode(value.dialCode ?? "");
                },
                onChanged: (phone) {
                  context.read<AuthVM>().setPhoneNumber(phone.number);
                },
                validator: (phone) {
                  if (phone == null || phone.countryISOCode != 'IN') {
                    return 'Please enter a valid Indian number';
                  }
                  return null;
                },
                countries: const <Country>[
                  Country(
                    name: "India",
                    nameTranslations: {
                      "en": "India",
                    },
                    flag: "🇮🇳",
                    code: "IN",
                    dialCode: "91",
                    minLength: 10,
                    maxLength: 10,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

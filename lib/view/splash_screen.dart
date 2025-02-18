import 'package:flutter/material.dart';
import 'package:phoneauthentication/viewmodel/auth_vm.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  static const name = "SplashPage";

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthVM>().phonePageInit();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Splash',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phoneauthentication/constants/constants.dart';
import 'package:phoneauthentication/firebase_options.dart';
import 'package:phoneauthentication/view/home_screen.dart';
import 'package:phoneauthentication/view/splash_screen.dart';
import 'package:provider/provider.dart';

import 'view/auth/otp_page.dart';
import 'view/auth/phone_page.dart';
import 'viewmodel/auth_vm.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthVM>(create: (context) => AuthVM()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.name,
        supportedLocales: const [
          Locale("en"),
        ],
        routes: {
          SplashScreen.name: (context) => const SplashScreen(),
          PhoneNumberPage.name: (context) => const PhoneNumberPage(),
          OtpPage.name: (context) => const OtpPage(),
          HomeScreen.name: (context) => const HomeScreen(),
        },
      ),
    );
  }
}

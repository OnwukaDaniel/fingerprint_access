import 'dart:async';
import 'dart:developer';

import 'package:biometric_storage/biometric_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fingerprint app',
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final String baseName = 'default'; 
  final LocalAuthentication auth = LocalAuthentication(); 
  Color accessColor = Colors.white;
  String accessName = '';

  @override
  void initState() {
    super.initState();
    //auth.isDeviceSupported().then(
    //      (bool isSupported) => setState(() => _supportState = isSupported
    //      ? _SupportState.supported
    //      : _SupportState.unsupported),
    //);

    _checkAuthenticate();
  } 

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Check biometric',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
      setState(() {
        if (authenticated == true) {
          accessName = "Access Granted";
          accessColor = Colors.green;
        } else {
          accessName = "Access Denied";
          accessColor = Colors.redAccent;
        }
      });
    } on PlatformException catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Material(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(18)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(e.message!, style: const TextStyle(color: Colors.white))
                ],
              ),
            ),
          );
        },
      );
      print(e);
      return;
    }
    if (!mounted) return;
  } 

  Future<CanAuthenticateResponse> _checkAuthenticate() async {
    final response = await BiometricStorage().canAuthenticate();
    if (response == CanAuthenticateResponse.success) {
      log('Authentication was possible: $response');
    } else {
      log('Authentication was not possible: $response');
    }
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        backgroundColor: Colors.black45,
        title: const Text("Door app", style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: StatefulBuilder(
          builder: (_, void Function(void Function()) setState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 200),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.privacy_tip_outlined,
                        color: Colors.white,
                        size: 50,
                      ),
                      SizedBox(width: 20),
                      Text(
                        "Access",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                  Text(
                    accessName,
                    style: TextStyle(
                      fontSize: 25,
                      color: accessColor,
                    ),
                  ),
                  const SizedBox(height: 200),
                  const Spacer(),
                  InkWell(
                    onTap: _authenticate,
                    child: const Icon(
                      Icons.fingerprint,
                      size: 70,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Empty"),
    );
  }
}

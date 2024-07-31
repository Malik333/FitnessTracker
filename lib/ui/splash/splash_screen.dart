import 'dart:async';
import 'package:fitness_tracker/ui/home/home_screen.dart';
import 'package:fitness_tracker/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  static const String route = "splash_screen";

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () async {

        if (context.mounted) {
          Navigator.of(context, rootNavigator: true)
              .pushNamedAndRemoveUntil(
              HomeScreen.route, (Route<dynamic> route) => false);
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png'),
            ],
          ),
        ),
      ),
    );
  }
}

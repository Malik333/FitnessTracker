import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_tracker/firebase_options.dart';
import 'package:fitness_tracker/routes/route_generator.dart';
import 'package:fitness_tracker/ui/splash/splash_screen.dart';
import 'package:fitness_tracker/utils/colors.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateRoute: RouteGenerator().generateRoute,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primary),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColor.primary,
        ),
      ),
      initialRoute: SplashScreen.route,
      debugShowCheckedModeBanner: false,
    );
  }
}

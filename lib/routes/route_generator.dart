import 'package:fitness_tracker/bloc/activities/activities_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../ui/home/home_screen.dart';
import '../ui/splash/splash_screen.dart';

class RouteGenerator {

  Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case SplashScreen.route:
        return MaterialPageRoute(
          builder: (context) {
            return const SplashScreen();
          },
        );
      case HomeScreen.route:
        return MaterialPageRoute(
          builder: (context) {
            return BlocProvider<ActivitiesBloc>(
              create: (context) => ActivitiesBloc(),
              child: const HomeScreen(),
            );
          },
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Error while loading new page'),
        ),
      );
    });
  }
}

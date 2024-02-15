// router.dart
import 'package:flutter/material.dart';
import 'package:maps_marker/screens/DetailsStation.dart';
import 'package:maps_marker/screens/ServicesScreen.dart';
import 'package:maps_marker/screens/StationsScreen.dart';
import 'package:maps_marker/screens/gazole_input.dart';
import 'package:maps_marker/screens/home_screen.dart';
import 'package:maps_marker/screens/input_details.dart';
import 'package:maps_marker/screens/login_screen.dart';
import 'package:maps_marker/screens/register_screen.dart';
import 'package:maps_marker/screens/stationPage.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => WelcomePage());
      case '/station':
        return MaterialPageRoute(builder: (_) => StationPage());
      case '/service':
        return MaterialPageRoute(builder: (_) => ServicesScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/register':
        return MaterialPageRoute(builder: (_) => SignUpPage());
      case '/station-service':
        return MaterialPageRoute(builder: (_) => StationsScreen());
      case '/details':
        return MaterialPageRoute(
            builder: (_) => DetailsStation(
                  stationId: '',
                  nameId: '',
                ));
      case '/details-input':
        return MaterialPageRoute(
            builder: (_) => InputDetails(
                  stationId: '',
                  nameId: '',
                ));
      case '/gazole-input':
        return MaterialPageRoute(
            builder: (_) => GazoleListScreen(
                  stationId: '',
                ));
      default:
        return MaterialPageRoute(builder: (_) => WelcomePage());
    }
  }
}

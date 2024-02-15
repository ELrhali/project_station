import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:maps_marker/router/router.dart';
import 'package:maps_marker/screens/home_screen.dart';
// import 'package:maps_marker/screens/DetailsStation.dart';
import 'package:maps_marker/screens/stationPage.dart';
//import 'package:maps_marker/screens/home_screen.dart';
// import 'package:maps_marker/screens/stationPage.dart';
import 'package:maps_marker/services/auth_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: 'Station',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
          bodyText1: GoogleFonts.montserrat(textStyle: textTheme.bodyText1),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: authService.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            final bool isLoggedIn = snapshot.data ?? false;
            return isLoggedIn ? StationPage() : WelcomePage();
          }
        },
      ),
      // home: const StationPage(),
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}

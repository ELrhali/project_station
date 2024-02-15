import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_marker/screens/DetailsStation.dart';
import 'package:maps_marker/screens/home_screen.dart';
import 'package:maps_marker/screens/test.dart';
import 'package:maps_marker/services/allStation_service.dart';
import 'package:maps_marker/services/auth_service.dart';
import 'package:maps_marker/services/station_manger.dart';
import 'package:maps_marker/services/station_service.dart';

class StationPage extends StatefulWidget {
  const StationPage({Key? key}) : super(key: key);

  @override
  State<StationPage> createState() => StationPageState();
}

class StationPageState extends State<StationPage> {
  final AuthService authService = AuthService();
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Map<String, Marker> _markers = {};

  TextEditingController _cityController = TextEditingController();

  CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(31.791702, -7.092620),
    zoom: 5,
  );

  @override
  void initState() {
    super.initState();
    AllStationService.toutesLesStations();
  }

  Future<void> _logout(BuildContext context) async {
    await authService.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => WelcomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => _logout(context),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xfffbb448), Color(0xffe46b10)],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      hintText: 'Enter ville',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Cacher le clavier
                    FocusScope.of(context).unfocus();

                    // Appeler la fonction de recherche
                    _onSearch();
                  },
                  child: Text('Rechercher'),
                ),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: Set<Marker>.of(_markers.values),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateMarkers(String city) async {
    print(city);
    try {
      List<Map<String, dynamic>> allStations = StationManager().allStations;
      List<Map<String, dynamic>> stations = [];

      // Vérifiez si la ville existe dans AllStations
      bool cityExists = allStations.any(
          (station) => station['city'].toLowerCase() == city.toLowerCase());

      if (cityExists) {
        // Ville trouvée dans AllStations, utilisez ces stations
        stations = allStations
            .where((station) =>
                station['city'].toLowerCase() == city.toLowerCase())
            .toList();
      } else {
        // Ville non trouvée dans AllStations, cherchez par ville
        stations = await StationService.trouverStationsGazole(city);
      }

      _markers.clear(); // Clear existing markers

      if (stations.isNotEmpty) {
        LatLng firstStationCoordinates = LatLng(
          stations[0]['latitude'],
          stations[0]['longitude'],
        );

        print("First Station Coordinates: $firstStationCoordinates");

        _kGooglePlex = CameraPosition(
          target: firstStationCoordinates,
          zoom: 14.0,
        );

        for (var item in stations) {
          String id = item['place_id'];
          String name = item['name'];
          _markers[id] = Marker(
            markerId: MarkerId(id),
            position: LatLng(item['latitude'], item['longitude']),
            infoWindow: InfoWindow(
              title: item['name'],
            ),
            icon: BitmapDescriptor.defaultMarker,
            onTap: () {
              // Navigate to DetailsStation screen with the selected id
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsStation(
                    stationId: id,
                    nameId: name,
                  ),
                  // builder: (context) => StationsScreenTest(stationId: id),
                  // builder: (context) => InputDetails(
                  //   stationId: id,
                  //   nameId: name,
                  // ),
                ),
              );
            },
          );
        }

        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));

        setState(() {});
      }
    } catch (e) {
      print("Error in _generateMarkers: $e");
    }
  }

  void _onMarkerTapped(Map<String, dynamic> markerData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Station Details"),
          content: Text(
              "Station ID: ${markerData['id']} Nom: ${markerData['name']}"),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _onSearch() {
    String city = _cityController.text;
    _generateMarkers(city);
  }
}

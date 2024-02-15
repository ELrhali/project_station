import 'package:flutter/material.dart';
import 'package:maps_marker/services/staion_ById.dart';

class StationsScreenTest extends StatefulWidget {
  final String stationId;

  StationsScreenTest({required this.stationId});

  @override
  _StationsScreenTestState createState() => _StationsScreenTestState();
}

class _StationsScreenTestState extends State<StationsScreenTest> {
  final StationService stationService = StationService();
  late Future<List<Station>> futureStations;

  @override
  void initState() {
    super.initState();
    futureStations = stationService.fetchStations(widget.stationId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stations List'),
      ),
      body: FutureBuilder<List<Station>>(
        future: futureStations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError && snapshot.error != null) {
            return Text('Error: ${snapshot.error}');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final station = snapshot.data![index];

                // Build a custom ListTile to display information from gazoles and services
                return ListTile(
                  title: Text(station.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('City: ${station.city}'),
                      if (station.gazoles.isNotEmpty)
                        Text('Dissel: ${station.gazoles[0]["dissel"]}'),
                      if (station.services.isNotEmpty)
                        Text('Service Name: ${station.services[0]["name"]}'),
                      if (station.services.isNotEmpty)
                        Text(
                            'Service Description: ${station.services[0]["description"]}'),
                      if (station.services.isNotEmpty)
                        Text(
                            'Service Type: ${station.services[0]["typeService"]}'),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

class StationService {
  Future<List<Station>> fetchStations(String stationId) async {
    try {
      final String baseUrl =
          "http://192.168.100.5:8082/stations_list?station_id=$stationId";

      final response = await http.get(Uri.parse(baseUrl));
      print(response);
      if (response.statusCode == 200) {
        final contentType = response.headers['content-type'];
        if (contentType != null && contentType.contains('application/json')) {
          final Map<String, dynamic> data = json.decode(response.body);
          List<Station> stations = [Station.fromJson(data)];
          print(data);

          return stations;
        } else {
          throw Exception('Invalid Content-Type in the response');
        }
      } else {
        throw Exception(
            'Failed to load data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print(e.toString());
      throw Exception(
          'Erreur lors de la récupération de toutes les stations by id');
    }
  }

  Future<List<Station>> fetchServiceByType(
      String stationId, String typeService) async {
    try {
      final String baseUrl =
          "http://192.168.100.5:8082/stations_list?station_id=$stationId";

      final response = await http.get(Uri.parse(baseUrl));
      print(response);
      if (response.statusCode == 200) {
        final contentType = response.headers['content-type'];
        if (contentType != null && contentType.contains('application/json')) {
          final Map<String, dynamic> data = json.decode(response.body);
          List<Station> stations = [Station.fromJson(data)];
          print(data);

          return stations;
        } else {
          throw Exception('Invalid Content-Type in the response');
        }
      } else {
        throw Exception(
            'Failed to load data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print(e.toString());
      throw Exception(
          'Erreur lors de la récupération de toutes les stations by id');
    }
  }
}

class Station {
  final String placeId;
  final String name;
  final String city;
  final double latitude;
  final double longitude;
  final String icon;
  final List<Map<String, dynamic>> gazoles;
  final List<Map<String, dynamic>> services;

  Station({
    required this.placeId,
    required this.name,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.icon,
    required this.gazoles,
    required this.services,
  });
  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      placeId: json['place_id'] ?? '',
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0,
      icon: json['icon'] ?? '',
      gazoles: List<Map<String, dynamic>>.from(json['gazoles'] ?? []),
      services: List<Map<String, dynamic>>.from(json['services'] ?? []),
    );
  }
}

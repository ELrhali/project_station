import 'dart:convert';
import 'package:http/http.dart' as http;

class GazoleStation {
  final String UrlGazole = "http://192.168.100.5:8083";
  Future<Gazole> createGazole(Gazole gazole) async {
    try {
      if (gazole.stationId.isNotEmpty) {
        final response = await http.post(
          Uri.parse(UrlGazole),
          headers: {"Content-Type": "application/json"},
          body: json.encode(gazole.toJson()),
        );

        if (response.statusCode == 201) {
          return Gazole.fromJson(json.decode(response.body));
        } else {
          print(
              "Failed to create gazole. Status code: ${response.statusCode}, Body: ${response.body}");
          throw Exception("Failed to create gazole");
        }
      } else {
        print(
            "Error creating gazole: Station ID is blank. gazole details: $gazole");
        throw Exception("Failed to create gazole: Station ID is blank.");
      }
    } catch (e) {
      print("Error creating gazole: $e");
      throw Exception("Failed to create gazole");
    }
  }

  Future<List<Gazole>> getGazoles({String? stationId}) async {
    String url = UrlGazole;

    url += "/gazoles?station_id=$stationId";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Gazole> gazoles = data.map((item) => Gazole.fromJson(item)).toList();
      return gazoles;
    } else {
      throw Exception("Failed to load gazoles");
    }
  }

  Future<void> updateGazole(Gazole gazole) async {
    final response = await http.put(
      Uri.parse('$UrlGazole/${gazole.id}/'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(gazole.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update gazole");
    }
  }
}

class Gazole {
  final int id;
  double? ese; // changed from ese to essance
  double? premium;
  double? dissel;
  String stationId;

  Gazole({
    required this.id,
    this.ese,
    this.premium,
    this.dissel,
    required this.stationId,
  });

  factory Gazole.fromJson(Map<String, dynamic> json) {
    return Gazole(
      id: json['id'],
      ese: json['essance'] is String
          ? double.parse(json['essance'])
          : json['essence'],
      premium: json['premium'] is String
          ? double.parse(json['premium'])
          : json['premium'],
      dissel: json['dissel'] is String
          ? double.parse(json['dissel'])
          : json['dissel'],
      stationId: json['station_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'essance': ese, // changed from ese to essance
      'premium': premium,
      'dissel': dissel,
      'station_id': stationId,
    };
  }
}

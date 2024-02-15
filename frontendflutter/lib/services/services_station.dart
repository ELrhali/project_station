import 'dart:convert';
import 'package:http/http.dart' as http;

class ServiceStaionGazole {
  final String UrlService = "http://192.168.100.5:8084";
  Future<Service> createService(Service service) async {
    try {
      if (service.stationId.isNotEmpty) {
        final response = await http.post(
          Uri.parse(UrlService),
          headers: {"Content-Type": "application/json"},
          body: json.encode(service.toJson()),
        );

        if (response.statusCode == 201) {
          return Service.fromJson(json.decode(response.body));
        } else {
          print(
              "Failed to create service. Status code: ${response.statusCode}, Body: ${response.body}");
          throw Exception("Failed to create service");
        }
      } else {
        print(
            "Error creating service: Station ID is blank. Service details: $service");
        throw Exception("Failed to create service: Station ID is blank.");
      }
    } catch (e) {
      print("Error creating service: $e");
      throw Exception("Failed to create service");
    }
  }

  Future<List<Service>> getServices({String? stationId}) async {
    String url = UrlService;
    List<Service> services = [];

    if (stationId != null) {
      url += "/services?station_id=$stationId";
    }
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        services = data.map((item) => Service.fromJson(item)).toList();
        return services;
      } else {
        throw Exception("Failed to load services");
      }
    } catch (e) {
      print(e.toString());
    }
    return services;
  }

  Future<List<Service>> getServicesByType(
      {String? stationId, String? typeService}) async {
    String url = UrlService;
    List<Service> servicesByType = [];

    if (stationId != null) {
      url += "/services?station_id=$stationId&typeService=$typeService";
    }
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        servicesByType = data.map((item) => Service.fromJson(item)).toList();
        return servicesByType;
      } else {
        throw Exception("Failed to load services");
      }
    } catch (e) {
      print(e.toString());
    }
    return servicesByType;
  }

  Future<List<Service>> getAllServices({String? stationId}) async {
    final response = await http.get(Uri.parse(UrlService));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Service> services =
          data.map((item) => Service.fromJson(item)).toList();
      return services;
    } else {
      throw Exception("Failed to load services");
    }
  }

  Future<void> updateService(Service service) async {
    final response = await http.put(
      Uri.parse('$UrlService/${service.id}/'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(service.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update service");
    }
  }

  Future<void> deleteService(int serviceId) async {
    final response = await http.delete(Uri.parse('$UrlService/$serviceId/'));

    if (response.statusCode != 204) {
      throw Exception("Failed to delete service");
    }
  }
}

class Service {
  final int id;
  final String? name;
  final double? price;
  String stationId;
  final String? description;
  final String? typeService;
  Service({
    required this.id,
    required this.name,
    this.price,
    required this.stationId,
    this.description,
    this.typeService,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      price:
          json['price'] is String ? double.parse(json['price']) : json['price'],
      stationId: json['station_id'] ??
          '', // Handle null value by providing a default value
      description: json['description'] ??
          '', // Handle null value by providing a default value
      typeService: json['typeService'] ??
          '', // Handle null value by providing a default value
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'station_id': stationId,
      'description': description,
      'typeService': typeService,
    };
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "http://192.168.100.5:8086"; //192.168.100.5
  Future<String?> register(
    String nom,
    String prenom,
    String phone,
    String ville,
    String username,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/registre'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'first_name': nom,
        'last_name': prenom,
        'phone': phone,
        'city': ville,
        "username": username,
        'email': email,
        'password': password,
        'role': "user",
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Enregistrement réussi
      return null; // Pas d'erreur
    } else {
      // Gérer les erreurs d'enregistrement
      return 'Erreur  de l\'enregistrement';
    }
  }

  Future<String?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Login réussi
      String token = jsonDecode(response.body)['access'];
      await saveToken(token);
      return null; // Pas d'erreur
    } else {
      // Gérer les erreurs de login
      return 'Erreur d\'authentification';
    }
  }

  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('access', token);
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access');
  }

  Future<bool> isLoggedIn() async {
    String? token = await getToken();
    return token != null;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('access');
  }
}

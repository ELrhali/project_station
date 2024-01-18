import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "http://192.168.100.5:8080/convert/auth/v1/auth"; // Remplacez par l'URL de votre backend

  Future<String?> register(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/newuser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Enregistrement réussi, vous pouvez ajouter des actions supplémentaires ici
      return null; // Pas d'erreur
    } else {
      // Gérer les erreurs d'enregistrement
      return 'Erreur lors de l\'enregistrement';
    }
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService authService = AuthService();

  Future<void> _register() async {
    String email = _usernameController.text;
    String password = _passwordController.text;

    String? error = await authService.register(email, password);

    if (error == null) {
      // Enregistrement réussi, rediriger ou faire d'autres actions nécessaires
      print('Enregistrement réussi');
    } else {
      // Afficher un message d'erreur
      print('Erreur: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Nom d\'utilisateur'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: Text('S\'inscrire'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: RegisterPage(),
  ));
}

import 'dart:convert'; // Pour jsonDecode
import 'package:http/http.dart' as http;
import 'package:smarth_save/models/user_model.dart';
import 'package:smarth_save/services/api.dart';

import 'api_routes.dart';

class ApiUserService {
  final API api = API();

  Future<dynamic> register(UserModel user) async {
    // Construction de l'URL
    String url = api.baseURL + registerRoute;
    // Envoi de la requête POST à l'API
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(user.toMap()), // Utilisez `body` avec une chaîne JSON
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    print("il est connecter ${response.body}");


    // Vérification du statut de la réponse
    if (response.statusCode == 200) {
      // La réponse est correcte, on peut la parser en JSON
      return true;
    } else {
      throw Exception('Failed to register user');
    }
  }

  Future<dynamic> login(String email, String password) async {
    String url = api.baseURL + loginRoute;
    var body = jsonEncode({
      "email": email,
      "password": password,
    });

    try {
      // Envoi de la requête POST à l'API
      final response = await http.post(
        Uri.parse(url),
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      // Vérification du statut de la réponse

      if (response.statusCode == 200) {
        print("Response: ${jsonDecode(utf8.decode(response.bodyBytes))}");

        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        print("Response: ${jsonDecode(utf8.decode(response.bodyBytes))}");

        return jsonDecode(utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      throw Exception('Failed to login user: $e');
    }
  }

  Future<dynamic> modifmotdepasse(String email) async {
    // Construction de l'URL
    String url = api.baseURL + modifmotdepassefRoute;
    var body = jsonEncode({
      "email": email,
    });
    // Envoi de la requête POST à l'API
    final response = await http.post(Uri.parse(url), body: body, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    
    print("Response: ${jsonDecode(utf8.decode(response.bodyBytes))}");


    // Vérification du statut de la réponse
    if (response.statusCode == 200) {
    return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
    return jsonDecode(utf8.decode(response.bodyBytes));
    }
  }
}

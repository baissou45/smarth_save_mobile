import 'dart:convert'; // Pour jsonDecode
import 'package:http/http.dart' as htt;
import 'package:smarth_save/models/user_model.dart';
import 'package:smarth_save/services/api.dart';

import 'api_routes.dart';

class APIService {
  final API api = API();


  Future<dynamic> register( String nom, String prenom, String email, String password) async {

    // Construction de l'URL
    String url = api.baseURL + registerRoute;

    // Envoi de la requête POST à l'API
    final response = await htt.post(Uri.parse(url), body:
    {
      "nom": nom,
      "prenom": prenom,
      "email": email,
      "password": password,
    },
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    // Vérification du statut de la réponse
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }
    else {
      return jsonDecode(response.body);
    }
  }

  Future<dynamic> login( String email, String password) async {

    // Construction de l'URL
    String url = api.baseURL + loginRoute;

    // Envoi de la requête POST à l'API
    final response = await htt.post(Uri.parse(url), body:
    {
      "email": email,
      "password": password,
    },
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    // Vérification du statut de la réponse
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }
    else {
      return jsonDecode(response.body);
    }
  }

  Future<dynamic> modifmotdepasse(String email) async {
    // Construction de l'URL
    String url = api.baseURL + modifmotdepassefRoute;

    // Envoi de la requête POST à l'API
    final response = await htt.patch(Uri.parse(url), body:
    {
      
      "email": email,
    }, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    // Vérification du statut de la réponse
    if (response.statusCode == 200) {
      return true;
    }
    else {
      return jsonDecode(response.body)["error"];
    }
  }

}

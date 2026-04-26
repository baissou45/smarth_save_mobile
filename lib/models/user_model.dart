import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  String? id;
  String? nom;
  String? prenom;
  String? email;
  String? password;
  String? token;
  double patrimoineEpargne;
  double patrimoineTotal;

  UserModel({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.password,
    this.token,
    this.patrimoineEpargne = 0.0,
    this.patrimoineTotal = 0.0,
  });

  // Pour convertir un JSON en UserModel
  UserModel.fromMap(Map<String, dynamic> json)
      : patrimoineEpargne = (json['patrimoine_epargne'] as num?)?.toDouble() ?? 0.0,
        patrimoineTotal = (json['patrimoine_total'] as num?)?.toDouble() ?? 0.0 {
    id = json['id']?.toString();
    nom = json['nom'];
    prenom = json['prenom'];
    email = json['email'];
    password = json['password'];
    token = json['token'];
  }

  // Méthode pour convertir UserModel en Map (pour l'enregistrer)
  Map<String, dynamic> toMap() => {
    "id": id,
    "nom": nom,
    "prenom": prenom,
    "email": email,
    "password": password,
    "token": token,
    "patrimoine_epargne": patrimoineEpargne,
    "patrimoine_total": patrimoineTotal,
  };

  // Méthode asynchrone pour sauvegarder un utilisateur
  static Future<void> saveUser(UserModel user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String data = json.encode(user.toMap());
    await pref.setString("user", data);
  }

  // Méthode asynchrone pour récupérer un utilisateur
  static Future<UserModel?> getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? data = pref.getString("user");

    if (data != null) {
      try {
        Map<String, dynamic> decodedData = json.decode(data);
        return UserModel.fromMap(decodedData);
      } catch (e) {
        print("Erreur lors de la désérialisation de l'utilisateur : $e");
        return null;
      }
    } else {
      return null;
    }
  }

  // Méthode asynchrone pour supprimer l'utilisateur
  static Future<void> clearUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove('user');
  }
}
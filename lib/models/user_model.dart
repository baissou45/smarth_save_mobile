import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
String? nom;
String? prenom;
String? email;
String? password;
// Variable statique pour l'utilisateur en session
static UserModel? sessionUser;
UserModel({
  required this.nom,
  required this.prenom,
  required this.email,
  required this.password,
});

// Pour convertir un JSON en UserModel
UserModel.fromMap(Map<String, dynamic> json) {
  nom = json['nom'];
  prenom = json['prenom'];
  email = json['email'];
  password = json['password'];
}

// Méthode pour convertir UserModel en Map (pour l'enregistrer)
Map<String, dynamic> toMap() => {
  "nom": nom,
  "prenom": prenom,
  "email": email,
  "password": password,
};


 // Méthode asynchrone pour sauvegarder un utilisateur
 static Future<void> saveUser(UserModel user) async {
SharedPreferences pref = await SharedPreferences.getInstance();
String data = json.encode(user.toMap());  // Convertir l'utilisateur en JSON
await pref.setString("user", data);  // Sauvegarde
}

// Méthode asynchrone pour récupérer un utilisateur
static  getUser() async {
SharedPreferences pref = await SharedPreferences.getInstance();
String? data = pref.getString("user");  // Récupération de la chaîne JSON

if (data != null) {
  // Si les données existent, on les décode et les assigne à sessionUser
  Map<String, dynamic> decodedData = json.decode(data);
  sessionUser = UserModel.fromMap(decodedData);
  print("Utilisateur récupéré : ${sessionUser!.nom}");
  return sessionUser;
} else {
  print("Aucun utilisateur trouvé.");
  return null;
}
}


// Fonction utilitaire pour convertir une valeur en booléen
bool? _parseBool(dynamic value) {
  if (value is bool) {
    return value;
  } else if (value is String) {
    return value.toLowerCase() == 'true';
  }
  return null;
}

// Fonction utilitaire pour convertir en DateTime
DateTime? _parseDateTime(dynamic value) {
  if (value is String) {
    return DateTime.tryParse(value);
  } else if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value);
  }
  return null;
}
}
class UserModel {
String? nom;
String? prenom;
String? email;
String? password;
DateTime? createdAt;

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
  createdAt = _parseDateTime(json['createdAt']);
}

// Méthode pour convertir UserModel en Map (pour l'enregistrer)
Map<String, dynamic> toMap() => {
  "nom": nom,
  "prenom": prenom,
  "email": email,
  "password": password,
  "createdAt": createdAt?.toIso8601String(),
};

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
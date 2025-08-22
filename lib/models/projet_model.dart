class ProjetModel {
final String nom;
final String categorie;
final String periode;
final String montant;

ProjetModel({
  required this.nom,
  required this.categorie,
  required this.periode,
  required this.montant,
});

// Méthode pour convertir un projet en JSON (utile pour Firebase ou APIs)
Map<String, dynamic> toJson() {
  return {
    'nom': nom,
    'categorie': categorie,
    'periode': periode,
    'montant': montant,
  };
}

// Méthode pour créer un projet depuis un JSON (par ex. depuis Firebase)
factory ProjetModel.fromJson(Map<String, dynamic> json) {
  return ProjetModel(
    nom: json['nom'] ?? '',
    categorie: json['categorie'] ?? '',
    periode: json['periode'] ?? '',
    montant: json['montant'] ?? '',
  );
}
}

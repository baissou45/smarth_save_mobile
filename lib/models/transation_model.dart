class Categorie {
int? id;
String? libelle;

Categorie({this.id, this.libelle});

factory Categorie.fromJson(Map<String, dynamic> json) {
  return Categorie(
    id: json['id'],
    libelle: json['libelle'],
  );
}

Map<String, dynamic> toJson() {
  return {
    'id': id,
    'libelle': libelle,
  };
}
}

class Institution {
int? id;
String? libelle;
String? logo;

Institution({this.id, this.libelle, this.logo});

factory Institution.fromJson(Map<String, dynamic> json) {
  return Institution(
    id: json['id'],
    libelle: json['libelle'],
    logo: json['logo'],
  );
}

Map<String, dynamic> toJson() {
  return {
    'id': id,
    'libelle': libelle,
    'logo': logo,
  };
}
}

class TransactionModel {
String? trie;
String? type;
Categorie? categorie; // On stocke l'objet complet de la catégorie
DateTime? date;
String? filter;
String? groupeBy;
int? limit;
int? id;
Institution? institution; // On stocke l'objet complet de l'institution
String? montant;
String? devise;
String? commentaire;
String? destinataire;
String? destinataireLogo;
DateTime? dateEmission;
DateTime? dateValidation;

static TransactionModel? sessionTransaction;

TransactionModel({
  this.trie,
  this.type,
  this.categorie,
  this.date,
  this.filter,
  this.groupeBy,
  this.limit,
  this.id,
  this.institution,
  this.montant,
  this.devise,
  this.commentaire,
  this.destinataire,
  this.destinataireLogo,
  this.dateEmission,
  this.dateValidation,
});

Map<String, dynamic> toJson() {
  return {
    'trie': trie,
    'type': type,
    'categorie': categorie?.toJson(), // ✅ Envoie l'objet complet de la catégorie
    'date': date?.toIso8601String(),
    'filter': filter,
    'groupeBy': groupeBy,
    'limit': limit,
    'id': id,
    'institution': institution?.toJson(), // ✅ Envoie l'objet complet de l'institution
    'montant': montant,
    'devise': devise,
    'commentaire': commentaire,
    'destinataire': destinataire,
    'destinataireLogo': destinataireLogo,
    'dateEmission': dateEmission?.toIso8601String().split('T')[0],
    'dateValidation': dateValidation?.toIso8601String().split('T')[0],
  };
}

// Convertir depuis JSON
factory TransactionModel.fromJson(Map<String, dynamic> json) {
  return TransactionModel(
    trie: json['trie'],
    type: json['type'],
    categorie: json['categorie'] != null
        ? Categorie.fromJson(json['categorie']) // ✅ Récupère l'objet complet de la catégorie
        : null,
    institution: json['institution'] != null
        ? Institution.fromJson(json['institution']) // ✅ Récupère l'objet complet de l'institution
        : null,
    date: json['date'] != null ? DateTime.parse(json['date']) : null,
    filter: json['filter'],
    groupeBy: json['groupeBy'],
    limit: json['limit'],
    id: json['id'],
    montant:
        (json['montant'] is num) ? (json['montant'] as num).toString() : null,
    devise: json['devise'],
    commentaire: json['commentaire'],
    destinataire: json['destinataire'],
    destinataireLogo: json['destinataireLogo'],
    dateEmission: json['date_emission'] != null
        ? DateTime.parse(json['date_emission'])
        : null,
    dateValidation: json['date_validation'] != null
        ? DateTime.parse(json['date_validation'])
        : null,
  );
}
}

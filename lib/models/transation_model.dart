class TransactionModel {
String? trie;
String? type;
double? categorie;
DateTime? date;
String? filter;
String? groupeBy;
int? limit;
int? id;
Institution? institution;
Categorie? categorieModel;
double? montant;
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
  this.categorieModel,
  this.montant,
  this.devise,
  this.commentaire,
  this.destinataire,
  this.destinataireLogo,
  this.dateEmission,
  this.dateValidation,
});

// Méthode pour convertir l'objet en JSON
Map<String, dynamic> toJson() {
  return {
    'trie': trie,
    'type': type,
    'categorie': categorie,
    'date': date?.toIso8601String(),
    'filter': filter,
    'groupeBy': groupeBy,
    'limit': limit,
    'id': id,
    'institution': institution?.toJson(),
    'categorieModel': categorieModel?.toJson(),
    'montant': montant,
    'devise': devise,
    'commentaire': commentaire,
    'destinataire': destinataire,
    'destinataireLogo': destinataireLogo,
    'dateEmission': dateEmission?.toIso8601String(),
    'dateValidation': dateValidation?.toIso8601String(),
  };
}

// Méthode pour créer un objet à partir de JSON
factory TransactionModel.fromJson(Map<String, dynamic> json) {
  return TransactionModel(
    trie: json['trie'],
    type: json['type'],
    categorie: json['categorie'],
    date: json['date'] != null ? DateTime.parse(json['date']) : null,
    filter: json['filter'],
    groupeBy: json['groupeBy'],
    limit: json['limit'],
    id: json['id'],
    institution: json['institution'] != null
        ? Institution.fromJson(json['institution'])
        : null,
    categorieModel: json['categorieModel'] != null
        ? Categorie.fromJson(json['categorieModel'])
        : null,
    montant: json['montant'],
    devise: json['devise'],
    commentaire: json['commentaire'],
    destinataire: json['destinataire'],
    destinataireLogo: json['destinataireLogo'],
    dateEmission: json['dateEmission'] != null
        ? DateTime.parse(json['dateEmission'])
        : null,
    dateValidation: json['dateValidation'] != null
        ? DateTime.parse(json['dateValidation'])
        : null,
  );
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

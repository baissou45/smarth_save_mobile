class Bank {
  final int institutionId;
  final String institutionName;
  final String? institutionLogo;
  final String? brandColor; // Couleur personnalisée de la banque
  final List<Account> accounts;

  Bank({
    required this.institutionId,
    required this.institutionName,
    required this.accounts,
    this.institutionLogo,
    this.brandColor,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      institutionId: json['institution_id'] ?? 0,
      institutionName: json['institution_name'] ?? 'Unknown Bank',
      institutionLogo: json['institution_logo'],
      brandColor: json['brand_color'], // Ex: "#1F2937"
      accounts: (json['accounts'] as List?)
          ?.map((account) => Account.fromJson(account))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'institution_id': institutionId,
      'institution_name': institutionName,
      'institution_logo': institutionLogo,
      'brand_color': brandColor,
      'accounts': accounts.map((acc) => acc.toJson()).toList(),
    };
  }

  double getTotalBalance() {
    return accounts.fold(0.0, (sum, acc) => sum + (acc.solde ?? 0.0));
  }
}

class Account {
  final int id;
  final String name;
  final String type; // checking, savings, investment
  final String? subtype;
  final double? solde;
  final bool estEpargne;
  final String? logo;

  Account({
    required this.id,
    required this.name,
    required this.type,
    required this.estEpargne,
    this.solde,
    this.subtype,
    this.logo,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown Account',
      type: json['type'] ?? 'checking',
      solde: double.parse(json['solde'].toString()),
      estEpargne: json['est_epargne'] == 1,
      subtype: json['subtype'],
      logo: json['institution_logo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'solde': solde,
      'est_epargne': estEpargne,
      'subtype': subtype,
      'institution_logo': logo,
    };
  }

  String getAccountTypeLabel() {
    switch (type.toLowerCase()) {
      case 'checking':
        return 'Compte courant';
      case 'savings':
        return 'Compte épargne';
      case 'investment':
        return 'Investissement';
      default:
        return type;
    }
  }

  String formatBalance() {
    if (solde == null) return '0.00 €';
    return '${solde?.toStringAsFixed(2)} €';
  }
}

class PatrimoineResponse {
  final double patrimoine;
  final List<Bank> banks;

  PatrimoineResponse({
    required this.patrimoine,
    required this.banks,
  });

  factory PatrimoineResponse.fromJson(Map<String, dynamic> json) {
    return PatrimoineResponse(
      patrimoine: (json['patrimoine'] is num)
          ? (json['patrimoine'] as num).toDouble()
          : 0.0,
      banks: (json['banks'] as List?)
          ?.map((bank) => Bank.fromJson(bank))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patrimoine': patrimoine,
      'banks': banks.map((b) => b.toJson()).toList(),
    };
  }

  String formatPatrimoine() {
    return '${patrimoine.toStringAsFixed(2)} €';
  }
}

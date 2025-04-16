import 'package:flutter/material.dart';
import 'package:smarth_save/models/transation_model.dart';
import 'dart:convert'; // Pour convertir JSON en objets Dart
import 'package:flutter/services.dart'; // Pour charger les fichiers depuis les assets

class Transactionprovider extends ChangeNotifier {
  List<TransactionModel> _transactions = [];
  

  List<TransactionModel> get transactions => _transactions;

  Future<void> loadTransactions() async {
    try {
      // Charge le fichier JSON depuis les assets
      final String response = await rootBundle.loadString('assets/data.json');
      final Map<String, dynamic> data = json.decode(response);

      // Parse les données JSON en une liste de Transaction
      _transactions = (data['data'] as List)
          .map((transaction) => TransactionModel.fromJson(transaction))
          .toList();
      notifyListeners(); // Notify listeners that data has been updated
      // _transactions.forEach((transactions) {
        
      // });
    } catch (e) {
      print('Erreur lors du chargement des transactions: $e');
    }
  }
}

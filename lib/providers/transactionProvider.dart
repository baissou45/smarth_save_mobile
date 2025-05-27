import 'package:flutter/material.dart';
import 'package:smarth_save/models/transation_model.dart';
import 'dart:convert'; // Pour convertir JSON en objets Dart
import 'package:flutter/services.dart';
import 'package:smarth_save/services/api_transaction_service.dart'; // Pour charger les fichiers depuis les assets

class Transactionprovider extends ChangeNotifier {
  List<TransactionModel> _transactions = [];
  bool _isLoading = false;

  List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;

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
      print("Erreur lors du chargement des transactions: $e");
    }
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> getTransactions() async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await ApiTransactionService().getTransaction();
      final data = json.decode(response);
      _transactions = (data['data'] as List)
          .map((transaction) => TransactionModel.fromJson(transaction))
          .toList();
      print("transactions provider: ${_transactions}");
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print("Erreur lors de la récupération des transactions: $e");
    }
  }

  Future<void> getTransactionByDate(String date) async {
    try {
      _isLoading = true;
      notifyListeners();
    } catch (e) {
      print("Erreur lors de la récupération des transactions: $e");
    }
  }

  Future<void> getTransactionByType(String type) async {
    try {
      _isLoading = true;
      notifyListeners();
    } catch (e) {
      print("Erreur lors de la récupération des transactions: $e");
    }
  }
}

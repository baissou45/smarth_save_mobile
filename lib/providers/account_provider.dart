import 'package:flutter/material.dart';
import 'package:smarth_save/models/account_model.dart';
import 'package:smarth_save/services/api_account_service.dart';

class AccountProvider extends ChangeNotifier {
  final ApiAccountService _apiService = ApiAccountService();

  PatrimoineResponse? _patrimoineResponse;
  bool _isLoading = false;
  String? _errorMessage;

  PatrimoineResponse? get patrimoineResponse => _patrimoineResponse;
  List<Bank> get banks => _patrimoineResponse?.banks ?? [];
  double get patrimoine => _patrimoineResponse?.patrimoine ?? 0.0;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Charge les comptes groupés par banque
  Future<void> loadAccountsGroupedByBank() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _patrimoineResponse = await _apiService.getAccountsGroupedByBank();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Charge uniquement le patrimoine (appel plus léger)
  Future<void> loadPatrimoine() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final patrimoine = await _apiService.getPatrimoine();
      if (_patrimoineResponse != null) {
        _patrimoineResponse =
            PatrimoineResponse(patrimoine: patrimoine, banks: _patrimoineResponse!.banks);
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Force la resynchronisation de tous les comptes
  Future<void> resyncAccounts() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _apiService.resyncAccounts();

      // Recharge les comptes après la resync
      await loadAccountsGroupedByBank();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Échange un token Plaid public pour lier une banque
  Future<void> exchangePlaidToken(String publicToken) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _apiService.exchangePlaidToken(publicToken);

      // Recharge les comptes après l'ajout d'une nouvelle banque
      await loadAccountsGroupedByBank();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Obtient une banque spécifique par son ID
  Bank? getBankById(int institutionId) {
    try {
      return banks.firstWhere((bank) => bank.institutionId == institutionId);
    } catch (e) {
      return null;
    }
  }

  /// Obtient un compte spécifique par son ID
  Account? getAccountById(int accountId) {
    try {
      for (final bank in banks) {
        for (final account in bank.accounts) {
          if (account.id == accountId) {
            return account;
          }
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Obtient le solde total de tous les comptes d'une banque
  double getBankTotalBalance(int institutionId) {
    final bank = getBankById(institutionId);
    return bank?.getTotalBalance() ?? 0.0;
  }

  /// Obtient tous les comptes marqués comme épargne
  List<Account> getSavingsAccounts() {
    final savingsAccounts = <Account>[];
    for (final bank in banks) {
      savingsAccounts.addAll(bank.accounts.where((acc) => acc.estEpargne));
    }
    return savingsAccounts;
  }

  /// Efface les erreurs
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

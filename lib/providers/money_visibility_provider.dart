import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoneyVisibilityProvider with ChangeNotifier {
  bool _isBalanceVisible = true;
  late SharedPreferences _prefs;
  static const String _visibilityKey = 'balance_visibility';

  bool get isBalanceVisible => _isBalanceVisible;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _isBalanceVisible = _prefs.getBool(_visibilityKey) ?? true;
    notifyListeners();
  }

  Future<void> toggleBalance() async {
    _isBalanceVisible = !_isBalanceVisible;
    await _prefs.setBool(_visibilityKey, _isBalanceVisible);
    notifyListeners();
  }

  Future<void> setBalanceVisible(bool visible) async {
    _isBalanceVisible = visible;
    await _prefs.setBool(_visibilityKey, _isBalanceVisible);
    notifyListeners();
  }
}

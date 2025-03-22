import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smarth_save/models/user_model.dart';
import 'package:smarth_save/services/api_user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _token;
  UserModel? _user;
  String? _message;
  String? _error;

  bool get isLoading => _isLoading;
  String? get token => _token;
  bool get isLoggedIn => _token != null;
  UserModel? get user => _user;
  String? get message => _message;
  String? get error => _error;

  get response => null;

  Future<bool> register(UserModel user) async {
    _isLoading = true; // Début du chargement
    notifyListeners(); // Notifier les écouteurs que l'état a changé

    try {
      await APIService().register(user); // Appel à l'API
      return true; // Retourner true en cas de succès
    } catch (e) {
      rethrow; // Relancer l'exception pour que le Controller puisse la gérer
    } finally {
      _isLoading = false; // Fin du chargement
      notifyListeners(); // Notifier les écouteurs que l'état a changé
    }
  }

  Future<dynamic> login(String email, String password) async {
    _isLoading = true; // Début du chargement
    notifyListeners(); // Notifier les écouteurs que l'état a changé
    try {
      var response = await APIService().login(email, password);
      _message = response["message"];
      _token = response['token'];
      await _saveToken(_token!);
      _user = UserModel.fromMap(response['data']);
      await UserModel.saveUser(_user!);
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<dynamic> modifmotdepasse(String email) async {
    try {
      var response = await APIService().modifmotdepasse(email);
      print("la reponse ${response["erreur"]}");
      if (response.containsKey('erreur')) {
        _error = response["erreur"];
      } else {
        _message = response["message"];
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');

    print('on es la ${_token} ${isLoggedIn}');
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user');
    _token = null;
    notifyListeners();
  }
}

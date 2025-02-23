import 'package:flutter/material.dart';
import 'package:smarth_save/models/user_model.dart';
import 'package:smarth_save/services/api_user_service.dart';

class UserProvider extends ChangeNotifier {
  dynamic response;
  UserModel? _user;

  UserModel? get user => _user;

  Future<dynamic> register(
      String nom, String prenom, String email, String password) async {
    try {
      response = await APIService().register(nom, prenom, email, password);
      if (response.statusCode == 200) {
        _user = UserModel.fromMap(response);
      }
      notifyListeners();
    } catch (e) {
      response = e.toString();
    }
    return response;
  }

  Future<dynamic> login(String email, String password) async {
    try {
      response = await APIService().login(email, password);
      if (response.statusCode == 200) {
        _user = UserModel.fromMap(response);
      }

      notifyListeners();
    } catch (e) {
      response = e.toString();
    }
    return response;
  }

  Future<dynamic> modifmotdepasse(String email) async {
    try {
      response = await APIService().modifmotdepasse(email);
      if (response.statusCode == 200) {
        _user = UserModel.fromMap(response);
      }
      notifyListeners();
    } catch (e) {
      response = e.toString();
    }
    return response;
  }
}

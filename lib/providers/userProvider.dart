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
  bool get isLoggedIn => _token?.trim().isNotEmpty ?? false;
  UserModel? get user => _user;
  String? get message => _message;
  String? get error => _error;

  /// Récupère l'utilisateur actuellement connecté (null si pas connecté)
  UserModel? getCurrentUser() => _user;

  /// Retourne le nom d'affichage de l'utilisateur
  String getDisplayName() {
    if (_user == null) return 'Utilisateur';
    final prenom = _user?.prenom ?? '';
    final nom = _user?.nom ?? '';
    return '$prenom $nom'.trim();
  }

  Future<bool> register(UserModel user) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await ApiUserService().register(user);
      return true;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    _message = null;
    notifyListeners();

    try {
      var response = await ApiUserService().login(email, password);
      _message = response["message"];
      _token = response['token'];
      _user = UserModel.fromMap(response['data']);

      await _saveToken(_token!);
      await UserModel.saveUser(_user!);

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      print("Erreur lors de la connexion : $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginWithGoogle() async {
    _isLoading = true;
    _error = null;
    _message = null;
    notifyListeners();

    try {
      var response = await ApiUserService().loginWithGoogle();
      _message = response['message'];
      _token = response['token'];
      _user = UserModel.fromMap(response['data']);

      await _saveToken(_token!);
      await UserModel.saveUser(_user!);

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      print('Erreur lors de la connexion Google : $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> modifyPassword(String email) async {
    _isLoading = true;
    _error = null;
    _message = null;
    notifyListeners();

    try {
      var response = await ApiUserService().modifmotdepasse(email);
      if (response.containsKey('erreur')) {
        _error = response["erreur"];
      } else {
        _message = response["message"];
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Met à jour le profil de l'utilisateur et synchronise le state
  Future<void> updateProfile({
    required String nom,
    required String prenom,
    required String email,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await ApiUserService().updateProfile(
        nom: nom,
        prenom: prenom,
        email: email,
      );

      // Mettre à jour le modèle local
      if (_user != null) {
        _user!.nom = nom;
        _user!.prenom = prenom;
        _user!.email = email;
        await UserModel.saveUser(_user!);
      }

      _message = "Profil mis à jour avec succès";
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Charge le token et l'utilisateur au démarrage de l'app
  Future<void> loadToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('auth_token');

      if (_token != null && _token!.isNotEmpty) {
        // Charger l'utilisateur sauvegardé
        _user = await UserModel.getUser();
        print('✓ Utilisateur chargé : ${_user?.prenom} ${_user?.nom}');
      } else {
        print('✗ Pas de token trouvé');
      }
    } catch (e) {
      print('Erreur lors du chargement du token : $e');
      _error = e.toString();
    } finally {
      notifyListeners();
    }
  }

  /// Déconnecte l'utilisateur et nettoie l'état
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      _token = null;
      _user = null;
      _message = null;
      _error = null;

      await UserModel.clearUser();

      print('✓ Utilisateur déconnecté');
    } catch (e) {
      print('Erreur lors de la déconnexion : $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
}

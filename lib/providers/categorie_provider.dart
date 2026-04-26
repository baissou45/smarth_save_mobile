import 'package:flutter/material.dart';
import 'package:smarth_save/models/categorie.dart';
import 'package:smarth_save/services/api_categorie_service.dart';

class CategorieProvider with ChangeNotifier {
  List<Categorie> _availableCategories = [];
  List<Categorie> _userCategories = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Categorie> get availableCategories => _availableCategories;
  List<Categorie> get userCategories => _userCategories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load all available categories
  Future<void> loadAvailableCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final categories = await ApiCategorieService().getAllCategories();
      _availableCategories = categories;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load user's categories with spending data (from budget_dashboard endpoint)
  Future<void> loadUserCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final categories = await ApiCategorieService().getBudgetDashboard();
      _userCategories = categories;
      _error = null;
    } catch (e) {
      _error = e.toString();
      // Fallback to getMyCategories if budget_dashboard fails
      try {
        final categories = await ApiCategorieService().getMyCategories();
        _userCategories = categories;
        _error = null;
      } catch (fallbackError) {
        _error = fallbackError.toString();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add category with plafond
  Future<bool> addCategory(int id, double plafond) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Call POST /api/users_categories/{id} endpoint with {plafond: X}
      final category =
          _availableCategories.firstWhere((cat) => cat.id == id);
      category.total = plafond;
      _userCategories.add(category);
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update category plafond
  Future<bool> updateCategory(int id, double plafond) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Call PUT /api/users_categories/{id} endpoint
      final category =
          _userCategories.firstWhere((cat) => cat.id == id);
      category.total = plafond;
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete category
  Future<bool> deleteCategory(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Call DELETE /api/users_categories/{id} endpoint
      _userCategories.removeWhere((cat) => cat.id == id);
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Helper: get category IDs already added by user
  List<int> getUserCategoryIds() {
    return _userCategories.map((cat) => cat.id ?? 0).toList();
  }
}

import 'package:flutter/material.dart';
import 'package:smarth_save/models/projet_model.dart';
import 'package:smarth_save/services/api_projet_service.dart';

class ProjetProvider extends ChangeNotifier {
  final ApiProjetService _service = ApiProjetService();

  List<ProjetModel> _projets = [];
  bool _isLoading = false;
  String? _error;

  List<ProjetModel> get projets => _projets;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProjets() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _projets = await _service.getProjects();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _projets = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createProjet({
    required String titre,
    required String description,
    required double montantPrev,
    required DateTime dateVoulue,
    String? image,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newProjet = await _service.createProject(
        titre: titre,
        description: description,
        montantPrev: montantPrev,
        dateVoulue: dateVoulue,
        image: image,
      );
      _projets.add(newProjet);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProjet(
    int id, {
    double? montant,
    double? montantPrev,
    DateTime? dateVoulue,
    String? description,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updated = await _service.updateProject(
        id,
        montant: montant,
        montantPrev: montantPrev,
        dateVoulue: dateVoulue,
        description: description,
      );

      final index = _projets.indexWhere((p) => p.id == id);
      if (index != -1) {
        _projets[index] = updated;
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteProjet(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _service.deleteProject(id);
      _projets.removeWhere((p) => p.id == id);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

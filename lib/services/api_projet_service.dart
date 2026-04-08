import 'package:smarth_save/models/projet_model.dart';
import 'package:smarth_save/services/api_routes.dart';
import 'package:smarth_save/services/dio_client.dart';
import 'package:flutter/material.dart';

class ApiProjetService {
  final DioClient _dio = DioClient.instance;

  // Colors for projects
  static const List<Color> _projectColors = [
    Color(0xFF2196F3), // Blue
    Color(0xFF4CAF50), // Green
    Color(0xFFFF9800), // Orange
    Color(0xFFE91E63), // Pink
    Color(0xFF9C27B0), // Purple
  ];

  Color _getColorForIndex(int index) {
    return _projectColors[index % _projectColors.length];
  }

  List<ProjetModel> _parseProjects(dynamic response) {
    List<ProjetModel> projects = [];
    int index = 0;
    for (var item in response['data']) {
      projects.add(
        ProjetModel.fromJson(item, _getColorForIndex(index)),
      );
      index++;
    }
    return projects;
  }

  Future<List<ProjetModel>> getProjects() async {
    final response = await _dio.get(projetRoute);
    return _parseProjects(response);
  }

  Future<ProjetModel> createProject({
    required String titre,
    required String description,
    required double montantPrev,
    required DateTime dateVoulue,
    String? image,
  }) async {
    final response = await _dio.post(
      projetRoute,
      data: {
        'titre': titre,
        'description': description,
        'montant_prev': montantPrev,
        'date_voulue': dateVoulue.toIso8601String(),
        'image': image,
      },
    );

    if (response['status'] == 'success') {
      return ProjetModel.fromJson(response['data']);
    }
    throw Exception('Failed to create project');
  }

  Future<ProjetModel> getProject(int id) async {
    final response = await _dio.get('$projetRoute/$id');

    if (response['status'] == 'success') {
      return ProjetModel.fromJson(response['data']);
    }
    throw Exception('Project not found');
  }

  Future<ProjetModel> updateProject(
    int id, {
    double? montant,
    double? montantPrev,
    DateTime? dateVoulue,
    String? description,
  }) async {
    final data = <String, dynamic>{};
    if (montant != null) data['montant'] = montant;
    if (montantPrev != null) data['montant_prev'] = montantPrev;
    if (dateVoulue != null) data['date_voulue'] = dateVoulue.toIso8601String();
    if (description != null) data['description'] = description;

    final response = await _dio.put(
      '$projetRoute/$id',
      data: data,
    );

    if (response['status'] == 'success') {
      return ProjetModel.fromJson(response['data']);
    }
    throw Exception('Failed to update project');
  }

  Future<void> deleteProject(int id) async {
    final response = await _dio.delete('$projetRoute/$id');

    if (response['status'] != 'success') {
      throw Exception('Failed to delete project');
    }
  }
}

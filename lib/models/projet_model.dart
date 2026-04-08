import 'package:flutter/material.dart';

class ProjetModel {
  final int id;
  final String titre;
  final String? image;
  final String? description;
  final double montant;
  final double montantPrev;
  final DateTime? dateVoulue;
  final double progress;
  final Color color;

  ProjetModel({
    required this.id,
    required this.titre,
    required this.montant,
    required this.montantPrev,
    required this.progress,
    required this.color,
    this.image,
    this.description,
    this.dateVoulue,
  });

  factory ProjetModel.fromJson(Map<String, dynamic> json, [Color? color]) {
    final montantPrev = (json['montant_prev'] as num?)?.toDouble() ?? 0.0;
    final montant = (json['montant'] as num?)?.toDouble() ?? 0.0;
    final progress = montantPrev > 0 ? montant / montantPrev : 0.0;

    return ProjetModel(
      id: json['id'] as int,
      titre: json['titre'] as String? ?? '',
      image: json['image'] as String?,
      description: json['description'] as String?,
      montant: montant,
      montantPrev: montantPrev,
      dateVoulue: json['date_voulue'] != null
          ? DateTime.parse(json['date_voulue'] as String)
          : null,
      progress: (progress).clamp(0.0, 1.0),
      color: color ?? Colors.blue,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'image': image,
      'description': description,
      'montant': montant,
      'montant_prev': montantPrev,
      'date_voulue': dateVoulue?.toIso8601String(),
      'progress': progress,
    };
  }
}

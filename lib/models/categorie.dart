import 'package:flutter/material.dart';

class Categorie {
  int? id;
  String? label;
  double? spent;
  double? progress;
  double? total;
  Color? color;
  IconData? icon;

  Categorie(
      {this.id,
      this.label,
      this.spent,
      this.progress,
      this.total,
      this.color,
      this.icon});

  Categorie.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    spent = double.parse(json['spent'].toString());
    progress = double.parse(json['progress'].toString());
    total = double.parse(json['total'].toString());
    color = Color(int.parse(json['color'].replaceFirst('#', '0xFF')));
    icon = getIconFromString(json['icon']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['label'] = label;
    data['spent'] = this.spent;
    data['progress'] = this.progress;
    data['total'] = this.total;
    data['color'] = this.color;
    return data;
  }

  IconData getIconFromString(String iconName) {
    switch (iconName) {
      case 'restaurant_outlined':
        return Icons.restaurant_outlined;
      case 'home_outlined':
        return Icons.home_outlined;
      case 'directions_car_outlined':
        return Icons.directions_car_outlined;
      case 'sports_esports_outlined':
        return Icons.sports_esports_outlined;
      case 'health_and_safety_outlined':
        return Icons.health_and_safety_outlined;
      case 'work_outlined':
        return Icons.work_outlined;
      case 'trending_up_outlined':
        return Icons.trending_up_outlined;
      case 'sell_outlined':
        return Icons.sell_outlined;
      case 'school_outlined':
        return Icons.school_outlined;
      case 'shield_outlined':
        return Icons.shield_outlined;
      case 'request_quote_outlined':
        return Icons.request_quote_outlined;
      case 'savings_outlined':
        return Icons.savings_outlined;
      case 'subscriptions_outlined':
        return Icons.subscriptions_outlined;
      case 'card_giftcard_outlined':
        return Icons.card_giftcard_outlined;
      case 'receipt_long_outlined':
        return Icons.receipt_long_outlined;
      case 'help_outlined':
        return Icons.help_outlined;
      default:
        return Icons.help; // fallback
    }
  }
}

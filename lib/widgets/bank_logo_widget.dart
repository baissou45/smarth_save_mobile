import 'package:flutter/material.dart';

class BankLogoWidget extends StatelessWidget {
  final String bankName;
  final String? logoUrl;
  final String? brandColor;
  final double size;

  const BankLogoWidget({
    super.key,
    required this.bankName,
    this.logoUrl,
    this.brandColor,
    this.size = 48,
  });

  Color _parseColor(String? hexColor) {
    if (hexColor == null) return const Color(0xFF14B8A6); // Teal par défaut
    try {
      return Color(int.parse(hexColor.replaceFirst('#', '0xff')));
    } catch (_) {
      return const Color(0xFF14B8A6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _parseColor(brandColor);

    // Si on a un logo URL, afficher l'image avec fallback
    if (logoUrl != null && logoUrl!.isNotEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bgColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            logoUrl!,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return _buildFallback(bgColor);
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: SizedBox(
                  width: size * 0.4,
                  height: size * 0.4,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            },
          ),
        ),
      );
    }

    // Fallback: icône
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: _buildFallback(bgColor),
    );
  }

  Widget _buildFallback(Color bgColor) {
    return Center(
      child: Icon(
        Icons.account_balance,
        color: bgColor,
        size: size * 0.5,
      ),
    );
  }
}

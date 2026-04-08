import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum OnboardingButtonType { primary, ghost }

Widget onbordingBtn({
  required String label,
  required VoidCallback? onPressed,
  OnboardingButtonType type = OnboardingButtonType.ghost,
  bool isLoading = false,
}) {
  final bool isPrimary = type == OnboardingButtonType.primary;
  final Color primary = const Color(0xFF0F766E);

  return AnimatedContainer(
    duration: const Duration(milliseconds: 220),
    curve: Curves.easeOut,
    decoration: BoxDecoration(
      gradient: isPrimary
          ? const LinearGradient(
              colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : null,
      color: isPrimary ? null : Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      border: isPrimary
          ? null
          : Border.all(
              color: primary.withOpacity(0.22),
            ),
      boxShadow: isPrimary
          ? [
              BoxShadow(
                color: primary.withOpacity(0.25),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ]
          : null,
    ),
    child: TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        minimumSize: const Size(110, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        child: isLoading
            ? const SizedBox(
                key: ValueKey('loading'),
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2.2),
              )
            : Text(
                label,
                key: const ValueKey('label'),
                style: GoogleFonts.poppins(
                  color: isPrimary ? Colors.white : const Color(0xFF111827),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    ),
  );
}

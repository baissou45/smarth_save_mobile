// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';

// ─── Brand ────────────────────────────────────────────────────────────────────
const Color kTeal        = Color(0xFF009688);
const Color kTealLight   = Color(0xFF4DD0E1);
const Color kOrange      = Color(0xFFFF6B35);
const Color kNavyDark    = Color(0xFF0A0E27);  // bottom nav, headers sombres
const Color kNavyMid     = Color(0xFF131557);  // headers, gradients

// ─── Backgrounds ──────────────────────────────────────────────────────────────
const Color kBgPage      = Color(0xFFF5F6FA);  // fond général de toutes les pages
const Color kBgCard      = Colors.white;        // fond des cards

// ─── Text ─────────────────────────────────────────────────────────────────────
const Color kTextPrimary   = Color(0xFF0A0E27);
const Color kTextSecondary = Color(0xFF8E9AB5);
const Color kTextHint      = Color(0xFFB8C1D6);

// ─── Semantic ─────────────────────────────────────────────────────────────────
const Color kSuccess = Color(0xFF22C55E);
const Color kWarning = Color(0xFFF59E0B);
const Color kDanger  = Color(0xFFEF4444);

// ─── Legacy aliases (gardés pour la compat avec le code existant) ─────────────
const Color kPrimaryColor  = kOrange;
const Color kPrimaryColor1 = kTeal;
const Color kPrimaryColor2 = kTealLight;
const Color kPrimaryColor3 = Color(0xFFA1A1A1);
const Color kBackgroundColor = kNavyMid;
const Color kSecondColor     = Color(0xFFC4D0EB);
const Color kSecondColor2    = Color(0xFFF5F5F5);
const Color kSecondColor3    = Color(0xFFEBEBEB);
const Color foregroundColor  = Color(0xFFFFD4CE);
const Color seedColor        = Colors.white;

// ─── Text Colors (legacy) ─────────────────────────────────────────────────────
const Color primaryButtonTextColor = Colors.white;
const Color errorToastTextColor    = Colors.white;
const Color showSimpleSnackText    = Colors.white;

// ─── Widget Colors (legacy) ───────────────────────────────────────────────────
Color errorToastColor       = Colors.red.shade700;
const Color successToastColor = Colors.green;
const Color warningToastColor = Colors.orange;
const Color infoToastColor    = Colors.blue;

// ─── Helpers ──────────────────────────────────────────────────────────────────

/// Couleur de barre de progression selon le pourcentage (0.0 → 1.0)
Color budgetBarColor(double progress) {
  if (progress >= 0.9) return kDanger;
  if (progress >= 0.7) return kWarning;
  return kTeal;
}

/// Gradient standard brand (navy → teal)
const LinearGradient kBrandGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [kNavyMid, kTeal],
);

/// Gradient header sombre
const LinearGradient kHeaderGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [kNavyDark, kNavyMid],
);

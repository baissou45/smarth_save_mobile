import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget onboard(
  String image,
  String title,
  String description,
) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final maxImageHeight = constraints.maxHeight * 0.44;
      final imageHeight = maxImageHeight.clamp(200.0, 340.0);
      final width = constraints.maxWidth;

      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: width,
                constraints: BoxConstraints(maxHeight: imageHeight),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFFFFF), Color(0xFFEAF4FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 14,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(14),
                child: Image.asset(
                  'assets/images/$image',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 26),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  height: 1.2,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 14),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    height: 1.55,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF4B5563),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

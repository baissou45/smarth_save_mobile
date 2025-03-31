import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget onbordingBtn({
  required String label,
  required VoidCallback onPressed,
}) {
  return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: GoogleFonts.poppins(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
      ));
}

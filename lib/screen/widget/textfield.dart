import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SVTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final Widget? prefix;
  final String? label;
  final TextInputType? keyboardType;
  final bool? obscureText;

  const SVTextField({
    super.key,
    this.controller,
    this.hint,
    this.keyboardType,
    this.label,
    this.obscureText,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none
        ),
        labelStyle: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.black, // Couleur du texte du label
        ),
        hintStyle: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.black, // Couleur du texte de l'indice
        ),
        prefixIcon: prefix,
        labelText: label,
        hintText: hint ?? "",
        filled: true, // Active le remplissage
        fillColor: Colors.white, // Couleur de fond du champ

      ),
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.black, // Couleur du texte de l'utilisateur
      ),
    );
  }
}

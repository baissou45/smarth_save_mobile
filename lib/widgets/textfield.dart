import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SVTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hint;
  final Widget? prefix;
  final String? label;
  final TextInputType? keyboardType;
  final bool isPassword; // Nouveau paramètre pour indiquer si c'est un champ de mot de passe

  const SVTextField({
    super.key,
    this.controller,
    this.hint,
    this.keyboardType,
    this.label,
    this.prefix,
    this.isPassword = false, // Par défaut, ce n'est pas un champ de mot de passe
  });

  @override
  _SVTextFieldState createState() => _SVTextFieldState();
}

class _SVTextFieldState extends State<SVTextField> {
  bool _obscureText = true; // État pour gérer la visibilité du texte

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false, // Appliquer obscureText uniquement pour les mots de passe
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
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
        prefixIcon: widget.prefix,
        labelText: widget.label,
        hintText: widget.hint ?? "",
        filled: true, // Active le remplissage
        fillColor: Colors.white, // Couleur de fond du champ
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText; // Basculer la visibilité du texte
                  });
                },
              )
            : null, // Afficher l'icône uniquement pour les mots de passe
      ),
      keyboardType: widget.keyboardType,
      style: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.black, // Couleur du texte de l'utilisateur
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer ${widget.hint}';
        }
        return null;
      },
    );
  }
}
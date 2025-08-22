import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SVTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hint;
  final Widget? prefix;
  final String? label;
  final TextInputType? keyboardType;
  final bool isPassword;

  const SVTextField({
    super.key,
    this.controller,
    this.hint,
    this.keyboardType,
    this.label,
    this.prefix,
    this.isPassword = false,
  });

  @override
  _SVTextFieldState createState() => _SVTextFieldState();
}

class _SVTextFieldState extends State<SVTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return 
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null && widget.label!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Text(
              widget.label!,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),

          
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.keyboardType,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: widget.hint ?? "",
            hintStyle: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black.withOpacity(0.6),
            ),
            prefixIcon: widget.prefix,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer ${widget.hint ?? 'une valeur'}';
            }
            return null;
          },
        ),
      
      
        ],
    );
  
    }
}

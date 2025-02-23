import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

  //FONTS---------------------------------------
  TextStyle boldFont(Color color, double size) {
    return GoogleFonts.poppins(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle normalFont(Color color, double? size) {
    return GoogleFonts.montserrat(
      color: color,
      fontSize: size,
    );
  }

  TextStyle modFont(Color color, double? size, FontWeight fontWeight) {
    return GoogleFonts.montserrat(
      color: color,
      fontSize: size,
      fontWeight: fontWeight,
    );
  }


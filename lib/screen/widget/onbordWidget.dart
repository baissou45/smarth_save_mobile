import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget onboard(
  String image,
  String title,
  String description,
) {
  return Center(
    child: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
         Image(
          image: AssetImage("assets/images/$image"),
        ),
        const SizedBox(
          height: 60,
        ),
        Text(title,
            style: GoogleFonts.poppins(
                fontSize: 16, fontWeight: FontWeight.w900)),
        const SizedBox(
          height: 40,
        ),
        SizedBox(
          width: 270,
          child: Text(
              description,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w500)),
        ),
      ]),
    ),
  );
}

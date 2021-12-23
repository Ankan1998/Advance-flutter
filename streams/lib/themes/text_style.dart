import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class TextStyles{
  TextStyles._();

  static TextStyle largeTitle = TextStyle(
      fontFamily: GoogleFonts.poppins().fontFamily,
      fontWeight: FontWeight.w100,
      letterSpacing: 2.0,
      fontSize: 18.0
  );

  static TextStyle largeTitle2 = largeTitle.copyWith(
    fontWeight: FontWeight.w700
  );

  static TextStyle button1 = TextStyle(
      fontFamily: GoogleFonts.roboto().fontFamily,
      fontWeight: FontWeight.w200,
      fontSize: 20.0,
      color: Colors.grey[100]
  );

  static TextStyle button2 = TextStyle(
  fontSize: 20,
  color: Colors.white
  );

}
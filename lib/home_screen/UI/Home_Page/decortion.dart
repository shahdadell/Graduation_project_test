import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/App_Images/app_images.dart';
import 'package:graduation_project/Theme/theme.dart';

InputDecoration searchFieldDecoration() {
  return InputDecoration(
      prefixIcon: Padding(
        padding: const EdgeInsets.all(12),
        child: Image.asset(
          AppImages.search,
          width: 10,
          height: 10,
          color: MyTheme.iconGrayColor,
        ),
      ),
      hintText: "What are you looking for?",
      hintStyle: GoogleFonts.rubik(
        color: MyTheme.iconGrayColor,
        fontWeight: FontWeight.w400,
        fontSize: 16,
      ),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide.none));
}

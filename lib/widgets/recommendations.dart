import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecommendationsPopup extends StatelessWidget {
  final String recommendation;

  RecommendationsPopup({required this.recommendation});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 8),
            Text(
              'Study Recommendations',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 25, 54, 218)),
            ),
            SizedBox(height: 16),
            Text(
              recommendation,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 13.0,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            CupertinoButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Container(
                child: Text(
                  'Close',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.0,
                    color: const Color.fromARGB(255, 90, 0, 180),
                  ),
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 255, 144, 198),
                      const Color.fromARGB(255, 182, 162, 255),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 255, 173, 250),
                      offset: const Offset(0, 1),
                      blurRadius: 6,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.only(
                  top: 20,
                  bottom: 15,
                  left: 10,
                  right: 10,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

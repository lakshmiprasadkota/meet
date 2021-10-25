import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class ButtonWidget extends StatelessWidget {
  ButtonWidget({  this.buttonWidth ,  this.name });
  double ?buttonWidth;
  String ?name;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: buttonWidth,

        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 9),
        decoration: BoxDecoration(
          color: Color(0xFF232939),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            name!  ,
            style: GoogleFonts.poppins(
              fontSize:12,
              fontWeight: FontWeight.w500,
              color: Color(0xFFe6d888),)
          ),
        ));
  }
}
import 'package:flutter/material.dart';
import 'package:rehabis/globalVars.dart';

Widget contactCard(double width,int n, String phoneNumber, String role) {
  return Padding(
    padding: const EdgeInsets.only(bottom:8.0),
    child: Container(
      width: width*0.68,
      height: 60,
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.05),
            offset: Offset(1,1),
            spreadRadius: 10,
            blurRadius: 20,
          ),
          BoxShadow(
            color: primaryColor.withOpacity(0.05),
            offset: Offset(-1, -1),
            spreadRadius: -10,
            blurRadius: 20,
          )
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: width*0.05),
            child: Text(
              n.toString(),
              style: TextStyle(
                color: primaryColor
              ),
            ),
          ),
          Container(
            width: 1.3,
            height: 40,
            color: primaryColor.withOpacity(0.6),
          ),
          Text(
            phoneNumber,
            style: TextStyle(
              color: primaryColor
            ),
          ),
          Container(
          width: 1.3,
          height: 40,
          color: primaryColor.withOpacity(0.6),
        ),
          Padding(
            padding: EdgeInsets.only(right: width * 0.05),
            child: Text(
              role,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryColor
              ),
            ),
          )
      ]),
    ),
  );
}

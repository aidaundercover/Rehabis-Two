import 'package:flutter/material.dart';

Widget slider(int n, double width) {
  return SizedBox(
    width: width*0.84,
    child: Column(
      children: [
        SizedBox(height: 80,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: width*0.27,
              height: 8,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 123, 205, 126),
                borderRadius: BorderRadius.circular(10),
              )
            ),
            Container(
                width: width * 0.27,
                height: 8,
                decoration: BoxDecoration(
                  color: n>1 ? Color.fromARGB(255, 123, 205, 126) : Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                )),
            Container(
                width: width * 0.27,
                height: 8,
                decoration: BoxDecoration(
                  color: n == 3 ? Color.fromARGB(255, 123, 205, 126) : Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                )),
          ],
        ),
        SizedBox(height: 40,)
      ],
    ),
  );
}

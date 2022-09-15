import 'package:flutter/material.dart';
import 'package:rehabis/globalVars.dart';

class Goals extends StatefulWidget {
  const Goals({Key? key}) : super(key: key);

  @override
  State<Goals> createState() => _GoalsState();
}

List weekDays = [
  {
    'day': "M",
    'done': false,
  },
  {
    'day': "T",
    'done': false,
  },
  {
    'day': "W",
    'done': false,
  },
  {
    'day': "T",
    'done': false,
  },
  {
    'day': "F",
    'done': false,
  },
  {
    'day': "S",
    'done': false,
  },
  {
    'day': "S",
    'done': false,
  },

];

class _GoalsState extends State<Goals> {

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [

          Text("Week Goal", style: TextStyle()),

          Row(
            children:List.generate(
              7, (int index) => Padding(padding: EdgeInsets.symmetric(horizontal:10),
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.2)
                ),
                child: Text(weekDays[index]['day'],)))
            )
          )
        
      ]),
    );
  }
}

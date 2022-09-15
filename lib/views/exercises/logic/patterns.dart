import 'package:flutter/material.dart';

class WhatComesNext extends StatefulWidget {
  const WhatComesNext({Key? key}) : super(key: key);

  @override
  State<WhatComesNext> createState() => _WhatComesNextState();
}

class _WhatComesNextState extends State<WhatComesNext> {
  @override
  Widget build(BuildContext context) {
    
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    
    return Scaffold(
      // body: ListWheelScrollView(),
    );
  }
}

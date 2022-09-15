import 'package:flutter/material.dart';

class SomePage extends StatefulWidget {
  final String payload;
  const SomePage({Key? key, required this.payload}) : super(key: key);

  @override
  State<SomePage> createState() => _SomePageState();
}

class _SomePageState extends State<SomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        Text(widget.payload, style: TextStyle(fontSize: 30),)
      ]),
    );
  }
}

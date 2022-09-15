import 'package:flutter/material.dart';

class Event {
  final String title;
  final String desc;
  final DateTime from;
  final DateTime to;
  final Color bc;
  final bool isAllday;

  const Event({
    required this.from,
    required this.to,
    this.bc = Colors.purple,
    this.isAllday = false,
    required this.title,
    required this.desc,
  });


}
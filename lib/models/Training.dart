import 'package:flutter/material.dart';

class Training {
  final String title;
  final String skill;
  final int minutes;
  final int level;
  final Widget page;
  final String instruction;
  final String img ;

  Training(
      { required this.instruction,
      required this.level,
      required this.img,
      required this.skill,
      required this.title,
      required this.minutes,
      required this.page});

  factory Training.fromMap(map) {
    return Training(
        title: map['title'],
        level: map['level'],
        skill: map['skill'],
        page: map['page'],
        minutes: map["minutes"],
        instruction: map["instruction"],
        img: map["img"]);
  }
}

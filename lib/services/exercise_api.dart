import 'package:firebase_database/firebase_database.dart';
import 'package:rehabis/globalVars.dart';
import 'package:intl/intl.dart';



uploadExercise(String equipment, int count, String time, String type,
    String skill, int level) async {
  try {
    String date = DateFormat('yyyy-MM-dd-hh-mm-ss').format(DateTime.now());


    DatabaseReference ref =
        FirebaseDatabase.instance.ref("Users/$iinGlobal/Trainings/$date/");

    var training = {
      "Equipment": equipment,
      "Count": count,
      "Time": time,
      "Type": type,
      'Skill': skill,
      'level': level,
      'Date' : DateFormat('yyyy-MM-dd-hh-mm').format(DateTime.now())
    };

    await ref.set(training);
  } catch (e) {
    print(e);
  }
}

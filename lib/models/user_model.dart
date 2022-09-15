import 'dart:convert';

class User {
  String name;
  String iin;
  List modelData;

  User({
    required this.name,
    required this.iin,
    required this.modelData,
  });

  static User fromMap(Map<String, dynamic> user) {
    return  User(
      iin: user['iin'],
      name: user['name'],
      modelData: jsonDecode(user['model_data']),
    );
  }

  toMap() {
    return {
      'name': name,
      'iin': iin,
      'model_data': jsonEncode(modelData),
    };
  }
}
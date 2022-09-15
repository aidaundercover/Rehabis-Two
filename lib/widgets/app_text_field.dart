import 'package:flutter/material.dart';
import 'package:rehabis/globalVars.dart';

class AppTextField extends StatelessWidget {
  const AppTextField(
      {Key? key,
      required this.labelText,
      required this.controller,
      this.keyboardType = TextInputType.text,
      this.autofocus = false,
      this.isPassword = false})
      : super(key: key);
  final String labelText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool autofocus;
  final bool isPassword;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: autofocus,
      cursorColor: primaryColor,
      maxLength: labelText == 'IIN' ? 12 : 50,
      validator: (value) {
        if (labelText == 'IIN') {
          int month = int.parse(value![2] + value[3]);
          int day = int.parse(value[4] + value[5]);

          if (value.length == 12) {
            if (month > 0 && month < 13 && day > 0 && day < 32) {
            } else {
              value = '';
              return 'IIN is not a valid';
            }
          } else {
            value = '';
            return 'IIN consists of 12 characters';
          }
        }
      },
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        counterStyle: const TextStyle(fontFamily: "Inter"),
        labelText: labelText,
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey[200],
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        focusedBorder: new OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(
            const Radius.circular(12.0),
          ),
        ),
      ),
      obscureText: isPassword,
      keyboardType: keyboardType,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:rehabis/globalVars.dart';

class AppButton extends StatefulWidget {
  AppButton(
      {required this.onPressed,
      required this.text,
      required this.mainContext,
      this.color = const Color(0xFFcc65ff),
      this.icon = const Icon(
        Icons.add,
        color: Colors.white,
      )});
  final void Function()? onPressed;
  final String text;
  final Icon icon;
  final Color color;
  BuildContext mainContext;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: widget.color,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: primaryColor.withOpacity(0.3),
              blurRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        width: MediaQuery.of(widget.mainContext).size.width * 0.8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.text,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              width: 10,
            ),
            widget.icon
          ],
        ),
      ),
    );
  }
}

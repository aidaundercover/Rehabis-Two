import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:rehabis/main.dart';
import 'package:rehabis/services/facenet_service.dart';
import 'package:rehabis/services/ml_kit_service.dart';
import 'package:rehabis/views/auth/sign_in.dart';
import 'package:rehabis/views/auth/sign_up.dart';

class CameraHeader extends StatefulWidget {
  CameraHeader(this.title,
      {Key? key, required this.onBackPressed, required this.text, required this.mainContext})
      : super(key: key);
  final String title;
  final void Function()? onBackPressed;
  final String text;
  BuildContext mainContext;

  @override
  State<CameraHeader> createState() => _CameraHeaderState();
}

class _CameraHeaderState extends State<CameraHeader> {
  final FaceNetService _faceNetService = FaceNetService.faceNetService;
  final MLKitService _mlKitService = MLKitService();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(widget.mainContext).size.width,
      height: 150,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Colors.black, Colors.transparent],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: widget.onBackPressed,
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              height: 50,
              width: 50,
              child: const Center(child: Icon(Icons.arrow_back)),
            ),
          ),
          Text(
            widget.title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          TextButton(
              onPressed: () {
                Navigator.of(widget.mainContext).push(MaterialPageRoute(
                    builder: (context) => widget.text == 'Sign In'
                        ? SignIn(
                            cameraDescription: cameraDescription,
                            mainContext: widget.mainContext,
                          )
                        : SignUp(
                            cameraDescription: cameraDescription,
                            mainContext: widget.mainContext,
                          )));
              },
              child: Container(
                alignment: Alignment.center,
                child: Text(widget.text,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontFamily: "Inter",
                        fontSize: 16,
                        decoration: TextDecoration.underline)),
              ))
        ],
      ),
    );
  }
}

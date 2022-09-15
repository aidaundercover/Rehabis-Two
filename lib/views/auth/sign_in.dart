import 'dart:io';

import 'package:camera/camera.dart';
import 'package:rehabis/globalVars.dart';
import 'package:rehabis/main.dart';
import 'package:rehabis/services/camera_service.dart';
import 'package:rehabis/services/facenet_service.dart';
import 'package:rehabis/services/ml_kit_service.dart';
import 'package:rehabis/views/auth/sign_up.dart';
import 'package:rehabis/widgets/FacePainter.dart';
import 'package:rehabis/widgets/auth_action_button.dart';
import 'package:rehabis/widgets/camera_header.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:math' as math;

import 'package:rxdart/rxdart.dart';

class SignIn extends StatefulWidget {
  final CameraDescription cameraDescription;
  final mainContext;

  const SignIn(
      {Key? key, required this.cameraDescription, required this.mainContext})
      : super(key: key);

  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  CameraService _cameraService = CameraService();
  MLKitService _mlKitService = MLKitService();
  FaceNetService _faceNetService = FaceNetService.faceNetService;
  GlobalKey key = GlobalKey<SignInState>();

  late Future _initializeControllerFuture;

  bool cameraInitializated = false;
  bool _detectingFaces = false;
  bool pictureTaked = false;

  // switchs when the user press the camera
  bool _saving = false;
  bool _bottomSheetVisible = false;

  late String imagePath;
  late Size imageSize;
  Face? faceDetected;

  _onBackPressed() {
    startup();

    Navigator.of(context).pop();
    
  }

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();

  //   widget.dependOnInheritedWidgetOfExactType();
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      _start();
    
  }

  @override
  Widget build(BuildContext context) {
    final double mirror = math.pi;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    if (_cameraService.cameraController.value.isInitialized) {
      return Scaffold(
        body: Stack(
          children: [
            FutureBuilder(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (pictureTaked) {
                      return Container(
                        width: width,
                        height: height,
                        child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(mirror),
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: Image.file(File(imagePath)),
                            )),
                      );
                    } else {
                      bool isPortrait = MediaQuery.of(context).orientation ==
                          Orientation.portrait;
                      return isPortrait
                          ? Transform.scale(
                              scale: 1.0,
                              child: AspectRatio(
                                aspectRatio:
                                    MediaQuery.of(context).size.aspectRatio,
                                child: OverflowBox(
                                  alignment: Alignment.center,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Container(
                                      width: width,
                                      height: width *
                                          _cameraService.cameraController.value
                                              .aspectRatio,
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: <Widget>[
                                          CameraPreview(
                                              _cameraService.cameraController),
                                          CustomPaint(
                                            painter: FacePainter(
                                                isPortrait: true,
                                                face: faceDetected,
                                                imageSize: imageSize),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : AspectRatio(
                              aspectRatio:
                                  MediaQuery.of(widget.mainContext).size.aspectRatio,
                              child: OverflowBox(
                                alignment: Alignment.center,
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: SizedBox(
                                    width: width,
                                    height: width *
                                        _cameraService
                                            .cameraController.value.aspectRatio,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: <Widget>[
                                        CameraPreview(
                                            _cameraService.cameraController),
                                        CustomPaint(
                                          painter: FacePainter(
                                              isPortrait: false,
                                              face: faceDetected,
                                              imageSize: imageSize),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
            CameraHeader(
              "LOGIN",
              onBackPressed: _onBackPressed,
              text: "Sign Up",
              mainContext: widget.mainContext,
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: !_bottomSheetVisible
            ? AuthActionButton(
                _initializeControllerFuture,
                onPressed: onShot,
                isLogin: true,
                reload: _reload,
                context: widget.mainContext,
              )
            : Container(
                // padding: EdgeInsets.all(10),
                // decoration: BoxDecoration(
                //   color: Colors.white
                // ),
                // child: Text("User was not identified", style: TextStyle(color: primaryColor, fontFamily: 'Inter')),
                ),
      );
    }
    else {
      return Center(child: CircularProgressIndicator(color: primaryColor));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // Dispose of the controller when the widget is disposed.
    // if (!mounted) _cameraService.dispose();
    _cameraService.cameraController.dispose();
  }

  void _start() async {
    _initializeControllerFuture =
        _cameraService.startService(widget.cameraDescription);
    await _initializeControllerFuture;

    mounted
        ? setState(() {
            cameraInitializated = true;
          })
        : () {};

    _frameFaces();
  }

  void _frameFaces() {
    imageSize = _cameraService.getImageSize();

    _cameraService.cameraController.startImageStream((image) async {
      if (_cameraService.cameraController != null) {
        // if its currently busy, avoids overprocessing
        if (_detectingFaces) return;

        _detectingFaces = true;

        try {
          List<Face> faces = await _mlKitService.getFacesFromImage(image,
              MediaQuery.of(context).orientation == Orientation.portrait);

          if (faces != null) {
            if (faces.length > 0) {
              // preprocessing the image
              mounted
                  ? setState(() {
                      faceDetected = faces[0];
                    })
                  : () {};

              if (_saving) {
                _saving = false;
                _faceNetService.setCurrentPrediction(image, faceDetected!);
              }
            } else {
              mounted
                  ? setState(() {
                      faceDetected = null;
                    })
                  : () {};
            }
          }

          _detectingFaces = false;
        } catch (e) {
          print(e);
          _detectingFaces = false;
        }
      }
    });
  }

  Future<bool> onShot() async {
    if (faceDetected == null) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('No face detected!'),
          );
        },
      );

      return false;
    } else {
      _saving = true;

      await Future.delayed(const Duration(milliseconds: 500));
      await _cameraService.cameraController.stopImageStream();
      await Future.delayed(const Duration(milliseconds: 200));
      XFile file = await _cameraService.takePicture();

      mounted
          ? setState(() {
              _bottomSheetVisible = true;
              pictureTaked = true;
              imagePath = file.path;
            })
          : () {};

      return true;
    }
  }

  _reload() {
    mounted
        ? setState(() {
            _bottomSheetVisible = false;
            cameraInitializated = false;
            pictureTaked = false;
          })
        : () {};
    this._start();
  }
}

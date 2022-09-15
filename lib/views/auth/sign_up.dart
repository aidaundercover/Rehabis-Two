import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:rehabis/globalVars.dart';
import 'package:rehabis/services/camera_service.dart';
import 'package:rehabis/services/facenet_service.dart';
import 'package:rehabis/services/ml_kit_service.dart';
import 'package:rehabis/widgets/FacePainter.dart';
import 'package:rehabis/widgets/auth_action_button.dart';
import 'package:rehabis/widgets/camera_header.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:math' as math;

import '../../main.dart';

class SignUp extends StatefulWidget {
  final CameraDescription cameraDescription;
  BuildContext mainContext;

  SignUp({Key? key, required this.cameraDescription, required this.mainContext})
      : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late String imagePath;
  Face? faceDetected;
  late Size imageSize;

  bool _detectingFaces = false;
  bool pictureTaked = false;

  late Future _initializeControllerFuture;
  bool cameraInitializated = false;

  // switchs when the user press the camera
  bool _saving = false;
  bool _bottomSheetVisible = false;

  // service injection
  final MLKitService _mlKitService = MLKitService();
  final CameraService _cameraService = CameraService();
  final FaceNetService _faceNetService = FaceNetService.faceNetService;

  _onBackPressed() {
    // dispose();
    startup();
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /// starts the camera & start framing faces
    _start();
  }

  @override
  Widget build(BuildContext context) {
    const double mirror = math.pi;
    final width = MediaQuery.of(widget.mainContext).size.width;
    final height = MediaQuery.of(widget.mainContext).size.height;
    if (_cameraService.cameraController.value.isInitialized) {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              FutureBuilder(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (pictureTaked) {
                      return SizedBox(
                        width: width,
                        height: height,
                        child: Transform(
                            alignment: Alignment.center,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: Image.file(File(imagePath)),
                            ),
                            transform: Matrix4.rotationY(mirror)),
                      );
                    } else {
                      bool isPortrait =
                          MediaQuery.of(widget.mainContext).orientation ==
                              Orientation.portrait;
                      return isPortrait
                          ? Transform.scale(
                              scale: 1.0,
                              child: AspectRatio(
                                aspectRatio: MediaQuery.of(widget.mainContext)
                                    .size
                                    .aspectRatio,
                                child: OverflowBox(
                                  alignment: Alignment.center,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: SizedBox(
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
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : AspectRatio(
                              aspectRatio: MediaQuery.of(widget.mainContext)
                                  .size
                                  .aspectRatio,
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
                                        ),
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
                },
              ),
              CameraHeader(
                "SIGN UP",
                onBackPressed: _onBackPressed,
                text: "Sign In",
                mainContext: widget.mainContext,
              )
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: !_bottomSheetVisible
              ? Padding(
                padding: const EdgeInsets.only(left: 100.0),
                child: AuthActionButton(
                    _initializeControllerFuture,
                    onPressed: mounted ? onShot : () {},
                    isLogin: false,
                    reload: _reload,
                    context: widget.mainContext,
                  ),
              )
              : Container());
    } else {
      return Center(child: CircularProgressIndicator(color: primaryColor));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // Dispose of the controller when the widget is disposed.
    _cameraService.dispose();
    // _cameraService.cameraController.dispose();
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
          List<Face> faces = await _mlKitService.getFacesFromImage(
              image,
              MediaQuery.of(widget.mainContext).orientation ==
                  Orientation.portrait);

          if (faces.isNotEmpty) {
            mounted
                ? setState(() {
                    faceDetected = faces[0];
                  })
                : () {};

            if (_saving) {
              _faceNetService.setCurrentPrediction(image, faceDetected!);

              if (mounted) {
                setState(() {
                  _saving = false;
                });
              }
            }
          } else {
            mounted
                ? setState(() {
                    faceDetected = null;
                  })
                : () {};
          }

          _detectingFaces = false;
        } catch (e) {
          print(e);
          _detectingFaces = false;
        }
      }
    });
  }

  _reload() {
    mounted
        ? setState(() {
            _bottomSheetVisible = false;
            cameraInitializated = false;
            pictureTaked = false;
          })
        : () {};
    _start();
  }

  /// handles the button pressed event
  Future<bool> onShot() async {
    if (faceDetected == null) {
      showDialog(
        context: widget.mainContext,
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
      imagePath = file.path;

      mounted
          ? setState(() {
              _bottomSheetVisible = true;
              pictureTaked = true;
            })
          : () {};

      return true;
    }
  }
}

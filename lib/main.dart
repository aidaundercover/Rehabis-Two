import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rehabis/services/ml_kit_service.dart';
import 'package:rehabis/globalVars.dart';
import 'package:rehabis/services/facenet_service.dart';
import 'package:rehabis/views/first_view/fisrt_view.dart';
import 'package:rehabis/views/main/calendar.dart';
import 'package:rehabis/views/main/home.dart';
import 'package:rehabis/views/main/profile.dart';
import 'package:rehabis/views/main/voice.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode) exit(1);
  };

  runApp(MyApp());
}

late CameraDescription cameraDescription;

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
FaceNetService _faceNetService = FaceNetService.faceNetService;
MLKitService _mlKitService = MLKitService();

class _MyAppState extends State<MyApp> {


  bool loading = false;

  void initState() {
    super.initState();

    startup();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !loading
        ? MaterialApp(
            // scaffoldMessengerKey: scaffoldMessengerKey,
            debugShowCheckedModeBanner: false,
            home: isLoggedIn ? Main() : FirstView())
        : CircularProgressIndicator(
            color: secondPrimaryColor,
          );
  }


}



void startup() async {
  // _setLoading(true);

  List<CameraDescription> cameras = await availableCameras();

  /// takes the front camera
  cameraDescription = cameras.firstWhere(
    (CameraDescription camera) =>
        camera.lensDirection == CameraLensDirection.front,
  );

  // start the services
  await _faceNetService.loadModel();
  //  await _dataBaseService.loadDB();
  _mlKitService.initialize();

  // _setLoading(false);
}

class Main extends StatefulWidget {
  const Main({key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MainState();
  }
}

class _MainState extends State<Main> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    const HomePage(),
    Calendar(),
    const Voice(),
    const ProfileMain()
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: 0,
        height: 60.0,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.calendar_month, size: 30),
          Icon(Icons.support, size: 30),
          Icon(Icons.person, size: 30),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: secondPrimaryColor,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}

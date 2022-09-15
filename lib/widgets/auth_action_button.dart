import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rehabis/database/database.dart';
import 'package:rehabis/globalVars.dart';
import 'package:rehabis/models/user_model.dart';
import 'package:rehabis/services/authentication.dart';
import 'package:rehabis/services/camera_service.dart';
import 'package:rehabis/services/facenet_service.dart';
import 'package:rehabis/views/first_view/select_your_weak.dart';
import 'package:rehabis/widgets/app_button.dart';
import 'app_text_field.dart';

class AuthActionButton extends StatefulWidget {
  AuthActionButton(this._initializeControllerFuture,
      {Key? key,
      required this.onPressed,
      required this.isLogin,
      required this.reload,
      required this.context});
  final Future _initializeControllerFuture;
  final Function onPressed;
  final bool isLogin;
  final Function reload;
  BuildContext context;

  @override
  _AuthActionButtonState createState() => _AuthActionButtonState();
}

/// service injection
final FaceNetService _faceNetService = FaceNetService.faceNetService;
final CameraService _cameraService = CameraService();

final TextEditingController _nameController = TextEditingController(text: '');
final TextEditingController _iinController = TextEditingController(text: '');

final GlobalKey<FormState> _weirdKey = GlobalKey<FormState>();

bool validateAndSave() {
  final FormState form = _weirdKey.currentState!;
  if (form.validate()) {
    print('Form is valid');
    return true;
  } else {
    print('Form is invalid');
    return false;
  }
}

User? predictedUser;

Future _signUp(context) async {
  /// gets predicted data from facenet service (user face detected)
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  List? predictedData = _faceNetService.predictedData;
  print('AuthactionPredicatedData: $predictedData');
  String? name = _nameController.text;
  String? iin = _iinController.text;

  avatarPath = _cameraService.imagePath!;
  User userToSave = User(
    name: name,
    iin: iin,
    modelData: predictedData,
  );

  Auth.signUp(context, _nameController, _iinController);

  /// creates a new user in the 'database'

  await databaseHelper.insert(userToSave);
  _faceNetService.setPredictedData(null);

  // Auth.signUp(context, _nameController, _iinController);
}

/// resets the face stored in the face net sevice

Future _signIn(context) async {
  try {
    var user = await _predictUser();

    Auth.signIn(context, user?.iin);
    avatarPath = _cameraService.imagePath!;
  } catch (e) {
    Fluttertoast.showToast(msg: "No user found");
  }
}

Future<User?> _predictUser() async {
  User? userAndPass = await _faceNetService.predict();
  return userAndPass;
}

class _AuthActionButtonState extends State<AuthActionButton> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(widget.context).size.width;
    return SizedBox(
      width: width * 0.8,
      height: 100,
      child: Center(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: InkWell(
            onTap: () async {
              try {
                // Ensure that the camera is initialized.
                await widget._initializeControllerFuture;
                // onShot event (takes the image and predict output)
                bool faceDetected = await widget.onPressed();

                if (faceDetected) {
                  if (widget.isLogin) {
                    var user = await _predictUser();
                    print("NullIssue======${user?.name}");
                    if (user != null) {
                      predictedUser = user;
                    } else {
                      predictedUser = null;
                    }
                  }

                  PersistentBottomSheetController bottomSheetController =
                      Scaffold.of(context).showBottomSheet((context) =>
                          signSheet(widget.context, predictedUser, width));
                  bottomSheetController.closed
                      .whenComplete(() => widget.reload());
                }
              } catch (e) {
                // If an error occurs, log the error to the console.
                print("dataFromdatabaseAuth1==$e");

                showDialog(
                    context: widget.context,
                    builder: (context) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Dialog(
                          child: Container(
                            width: 200,
                            height: 80,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "Error occured! Try again",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter'),
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: primaryColor.withOpacity(0.3),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: primaryColor.withOpacity(0.1),
                    blurRadius: 1,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              width: MediaQuery.of(widget.context).size.width * 0.7,
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'CAPTURE',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.camera_alt, color: Colors.white)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  signSheet(context, User? predictedUser, double width) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.isLogin && predictedUser != null
              ? Text(
                  'Hi, ' + predictedUser.name + '!',
                  style: TextStyle(fontSize: 20),
                )
              : widget.isLogin
                  ? Container(
                      child: Text(
                      'User not found 😞',
                      style: TextStyle(fontSize: 20),
                    ))
                  : Container(),
          Form(
            key: _weirdKey,
            child: Column(
              children: [
                widget.isLogin
                    ? Container()
                    : Column(children: [
                        SizedBox(
                          width: width * 0.7,
                          child: AppTextField(
                            controller: _iinController,
                            labelText: "IIN",
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: width * 0.7,
                          child: AppTextField(
                            controller: _nameController,
                            labelText: "Your Name",
                          ),
                        )
                      ]),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),
                widget.isLogin && predictedUser != null
                    ? SizedBox(
                        width: width * 0.55,
                        child: AppButton(
                          text: 'LOGIN',
                          onPressed: () async {
                            if (validateAndSave())
                              _signIn(widget.context);
                            else {}
                          },
                          mainContext: widget.context,
                          icon: Icon(
                            Icons.login,
                          ),
                        ),
                      )
                    : !widget.isLogin
                        ? SizedBox(
                            width: width * 0.55,
                            child: AppButton(
                              text: 'SIGN UP',
                              mainContext: widget.context,
                              onPressed: () async {
                                if (validateAndSave()) {
                                  await _signUp(widget.context);
                                }
                              },
                              icon: Icon(
                                Icons.person_add,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:rehabis/globalVars.dart';
import 'package:rehabis/main.dart';
import 'package:rehabis/views/auth/sign_up.dart';
import 'package:rehabis/services/facenet_service.dart';
import 'package:rehabis/services/ml_kit_service.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';


class FirstView extends StatelessWidget {
  const FirstView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children:[
                Container(
                height: height*0.76,
                    width: width*0.8,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                        secondPrimaryColor,
                        secondPrimaryColor,
                        secondPrimaryColor.withOpacity(0.7)
                  , secondPrimaryColor
                      ])
                      
                    ),
                  ),
                  SizedBox(
                  height: height * 0.76,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/logo_white.png', width: width*0.4,),
                        const Text(
                          "Start your recovery\nwith Rehabis!",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.asset('assets/first_bc.png'),
                          ],
                        )
                      ]),
                ),
                ]
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => SignUp(cameraDescription: cameraDescription, mainContext: context,)));
                  },
                  child: Container(
                    width: width*0.15,
                    height: 35,
                    decoration: BoxDecoration(
                      color: secondPrimaryColor,
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35)),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.arrow_forward_ios, color: Colors.white,)
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rehabis/globalVars.dart';
import 'package:rehabis/nft/nft_maket_main.dart';
import 'package:rehabis/video_call/index.dart';
import 'package:rehabis/widgets/home_view_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    double percentage = value * 100;

    return StreamBuilder(
        stream: FirebaseDatabase.instance.ref('User/$iinGlobal/Name').onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () {
                          print('Opening NFT MARKET SCREEN');
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const OnBoardingScreen()));
                        },
                        child: appBar(width, height, context)),
                    exercises(width, height),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const IndexPage()));
                      },
                      child: Container(
                        width: 300,
                        height: 55,
                        child: Text(
                          'VIDEO CALL ',
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                    ),
                    recomendations(width, context),
                  ],
                ),
              ),
            );
          } else {
            return Center(
                child: CircularProgressIndicator(
              color: primaryColor,
            ));
          }
        });
  }
}

// {
//   "instruction":"Нажмите на каждый символ в порядке слева направо, сверху вниз",
//     "level": 1,
//     "img": 'assets/arrow_sky.png',
//     "skill": "Motorics",
//     "title": "Same symbols",
//     "minutes": 3,
//     "page": ExercizeOne()
// },
// {
//   "instruction":
//         "Прослушайте текст и выберете изображение которое отобржает сказанное",
//     "level": 2,
//     "img": "assets/sound.png",
//     "skill": "Speech",
//     "title": "Similiar sounds",
//     "minutes": 1,
//     "page": ExerciseTwo()
// },
// {
//   "instruction": "Найдите лишнее среди 4-х изображений",
//       "level": 3,
//       "img": "assets/redundant.png",
//       "skill": "Problem Solving",
//       "title": "What's execess",
//       "minutes": 2,
//       "page": ExerciseThree()
// }

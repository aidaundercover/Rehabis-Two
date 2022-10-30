import 'package:flutter/material.dart';
import 'package:rehabis/globalVars.dart';
import 'package:rive/rive.dart';

class MyRehabis extends StatefulWidget {
  const MyRehabis({Key? key}) : super(key: key);

  @override
  State<MyRehabis> createState() => _MyRehabisState();
}

class _MyRehabisState extends State<MyRehabis> {
  RiveAnimationController  _controller = SimpleAnimation('idle');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Future.delayed(Duration(milliseconds: nftDelay), () {
    //   _controller.isActive = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Container(
      color: backgroundColor,
      child: SizedBox(
         width: width > 850
            ? width * 0.22
            : width > 799
                ? width * 0.4
                : width * 0.5,
        child: RiveAnimation.asset(
          'assets/rehabis.riv',
          
          controllers: [_controller],
        ),
      ),

      // child: Image.asset(
      //     "assets/robot_neutral.png",
          // width: width > 850
          //     ? width * 0.22
          //     : width > 799
          //         ? width * 0.4
          //         : width * 0.5,
      //   )
    );
  }
}

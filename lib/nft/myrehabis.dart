import 'package:flutter/material.dart';
import 'package:rehabis/globalVars.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart' show rootBundle;

class MyRehabis extends StatefulWidget {
  const MyRehabis({Key? key}) : super(key: key);

  @override
  State<MyRehabis> createState() => _MyRehabisState();
}

class _MyRehabisState extends State<MyRehabis>
    with SingleTickerProviderStateMixin {
  //RiveAnimationController  _controller = SimpleAnimation('idle');

  Artboard? _riveArtboard;

  // @override
  // void initState() {
  // super.initState();
  // rootBundle.load(
  //   'assets/rehabis.riv',
  // ).then((data) {
  //   // Load the RiveFile from the binary data.
  //   final file = RiveFile.import(data);

  //   // The artboard is the root of the animation
  //   // and gets drawn in the Rive widget.
  //   final artboard = file.mainArtboard;
  //   var controller =
  //       StateMachineController.fromArtboard(artboard, 'State Machine 1');
  //   if (controller != null) {
  //     artboard.addController(controller);
  //   }
  //   setState(() => _riveArtboard = artboard);
  // });
  //}

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Image.asset(
      "assets/robot_neutral.png",
      width: width > 850
          ? width * 0.22
          : width > 799
              ? width * 0.4
              : width * 0.5,
    );

    // return Center(
    //   child: SizedBox(
    //      width: width > 850
    //         ? width * 0.22
    //         : width > 799
    //             ? width * 0.4
    //             : width * 0.5,
    //     child:  _riveArtboard != null
    //         ? Rive(artboard: _riveArtboard!,fit: BoxFit.fitWidth, alignment: Alignment.center,)
    //         : const Center(
    //             child: CircularProgressIndicator(),
    //           ),
    //   ),
    // );
  }
}

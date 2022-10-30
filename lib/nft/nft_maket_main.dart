// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:iconsax/iconsax.dart';
// //import 'package:rehabis/animations/animations.dart';
// import 'package:rehabis/globalVars.dart';
// import 'package:rehabis/views/main/home.dart';

// class OnBoardingScreen extends StatelessWidget {
//   const OnBoardingScreen({Key? key}) : super(key: key);

//   final double _padding = 40;
//   final _headingStyle = const TextStyle(
//     fontWeight: FontWeight.w200,
//     fontFamily: 'Inter',
//     color: Colors.black,
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 50.h),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: _padding),
//               child: const _AppBar(),
//             ),
//             SizedBox(height: 40.h),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: _padding),
//                 child: Row(
//                   children: <Widget>[
//                     SvgPicture.asset(
//                       'assets/flash.svg',
//                     ),
//                     SizedBox(width: 8.w),
//                     Text(
//                       'Started',
//                       style: TextStyle(
//                         fontSize: 12.r,
//                       ),
//                     ),
//                   ],
//                 ),

//             ),
//             SizedBox(height: 16.h),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: _padding),
//               child: RichText(
//                     text: TextSpan(
//                       style: TextStyle(
//                         fontSize: 40.r,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'Inter',
//                         color: Colors.black,
//                         height: 1.3,
//                       ),
//                       children: [
//                         TextSpan(
//                           text: 'Discover ',
//                           style: _headingStyle,
//                         ),
//                         const TextSpan(
//                           text: 'NFT Artwork',
//                         ),
//                         TextSpan(
//                           text: 'Of Those Who',
//                           style: _headingStyle,
//                         ),
//                       ],
//                     ),
//                   ),

//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: _padding),

//                   child: Row(
//                     children: <Widget>[
//                       Text(
//                         'Recovered',
//                         style: TextStyle(
//                           fontSize: 40.r,
//                           fontWeight: FontWeight.bold,
//                           fontFamily: 'Inter',
//                           color: Colors.black,
//                           height: 1.3,
//                         ),
//                       ),
//                       const ColoredText(text: 'from Stroke'),
//                     ],
//                   ),
//             ),
//             SizedBox(height: 24.h),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: _padding),

//                 child: Text(
//                   'Digital marketplace of non-fungible tokens, that were generated as a result of FULL recovery of stroke patients',
//                   style: bodyTextStyle,

//               ),
//             ),
//             SizedBox(height: 40.h),
//             Container(
//               height: 200.h,
//               padding: EdgeInsets.only(left: _padding),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                        Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: const <Widget>[
//                           EventStat(
//                             title: '12.1K+',
//                             subtitle: 'Art Work',
//                           ),
//                           EventStat(
//                             title: '1.7M+',
//                             subtitle: 'Artist',
//                           ),
//                           EventStat(
//                             title: '45K+',
//                             subtitle: 'Auction',
//                           ),
//                         ],
//                       ),
//                   SizedBox(width: 60.w),
//                   Expanded(

//                         child: Container(
//                           padding: EdgeInsets.all(24.r),
//                           decoration: const BoxDecoration(
//                             color: Color(0xffe6d9fe),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               GestureDetector(
//                                 onTap: () {
//                                   Navigator.of(context).push(
//                                     MaterialPageRoute(builder: (_) => HomePage())

//                                   );
//                                 },
//                                 child: Container(
//                                   width: 40.r,
//                                   height: 40.r,
//                                   decoration: const BoxDecoration(
//                                     color: Color(0xffcab2ff),
//                                   ),
//                                   child: const Icon(Iconsax.arrow_right_1),
//                                 ),
//                               ),
//                               SizedBox(height: 24.h),
//                               Text(
//                                 'Discover \nArtwork',
//                                 style: TextStyle(
//                                   fontSize: 24.r,
//                                   height: 1.3,
//                                   fontWeight: FontWeight.bold,
//                                   letterSpacing: 9,
//                                 ),
//                               ),
//                               SizedBox(height: 12.h),
//                               Divider(
//                                 thickness: 2,
//                                 endIndent: 120.w,
//                                 color: Colors.black,
//                               ),
//                             ],
//                           ),
//                         ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20.h),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: _padding),

//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Text(
//                         'Supported By',
//                         style: bodyTextStyle,
//                       ),
//                       SvgPicture.asset(
//                         'assets/images/binance.svg',
//                         width: 24.r,
//                       ),
//                       SvgPicture.asset(
//                         'assets/images/huobi.svg',
//                         width: 22.r,
//                       ),
//                       SvgPicture.asset(
//                         'assets/images/xrp.svg',
//                         width: 22.r,
//                       ),
//                     ],
//                   ),
//                 ),

//           ])
//       )
//     );
//   }
// }

// class _AppBar extends StatelessWidget {
//   const _AppBar({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         const AppLogo(),
//         Container(
//           width: 40.r,
//           height: 40.r,
//           decoration: const BoxDecoration(
//             shape: BoxShape.circle,
//             color: Colors.black,
//           ),
//           child: const Center(
//             child: Icon(
//               Iconsax.wallet_1,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class AppLogo extends StatelessWidget {
//   const AppLogo({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       'A.',
//       style: TextStyle(
//         fontSize: 26.r,
//         fontWeight: FontWeight.bold,
//       ),
//     );
//   }
// }

// class ColoredText extends StatelessWidget {
//   const ColoredText({Key? key, required this.text}) : super(key: key);
//   final String text;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 100.w,
//       child: Stack(
//         fit: StackFit.loose,
//         children: [
//           Positioned(
//             bottom: 0,
//             left: 10.w,
//             child: Container(
//               width: 85.w,
//               height: 30.r,
//               color: primaryColor.withOpacity(0.6),
//             ),
//           ),
//           Text(
//             text,
//             style: TextStyle(
//               fontSize: 40.r,
//               fontWeight: FontWeight.bold,
//               fontFamily: 'Inter',
//               color: Colors.black,
//               height: 1.3,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class EventStat extends StatelessWidget {
//   const EventStat({Key? key, required this.title, required this.subtitle})
//       : super(key: key);

//   final String title;
//   final String subtitle;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 16.r,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(height: 8.h),
//         Text(
//           subtitle,
//           style: TextStyle(
//             fontSize: 14.r,
//             color: Colors.black54,
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

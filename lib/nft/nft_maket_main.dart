import 'package:flutter/material.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rehabis/animations/animations.dart';
import 'package:rehabis/globalVars.dart';

import '../views/main/home.dart';
import 'package:rehabis/views/main/home.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final double _padding = 40;

  final _headingStyle = const TextStyle(
    fontWeight: FontWeight.w200,
    fontFamily: 'Inter',
    color: Colors.black,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SingleChildScrollView(
            child:
                Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height: 50),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: _padding),
        child: const _AppBar(),
      ),
      SizedBox(height: 40),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: _padding),
        child: Row(
          children: <Widget>[
            SvgPicture.asset(
              'assets/flash.svg',
            ),
            const SizedBox(width: 8),
            Text(
              'Started',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 16),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: _padding),
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
              color: Colors.black,
              height: 1.3,
            ),
            children: [
              TextSpan(
                text: 'Discover ',
                style: _headingStyle,
              ),
              const TextSpan(
                text: 'NFT Artwork ',
              ),
              TextSpan(
                text: 'Of Those Who',
                style: _headingStyle,
              ),
            ],
          ),
        ),
      ),

      Padding(
        padding: EdgeInsets.symmetric(horizontal: _padding),
        child: Row(
          children: <Widget>[
            Text(
              'Recovered ',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
                color: Colors.black,
                height: 1.3,
              ),
            ),
            const ColoredText(text: 'from Stroke'),
          ],
        ),
      ),
      const SizedBox(height: 24),
      Padding(
         padding: EdgeInsets.symmetric(horizontal: _padding),
        child: Text(
          'Digital marketplace of non-fungible tokens, that were generated as a result of FULL recovery of stroke patients',
          style: TextStyle(
            fontSize: 22
          ),
        ),
      ),
      const SizedBox(height: 40),
      Container(
        height: 250,
        width: width*0.9,
        padding: EdgeInsets.only(left: _padding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const <Widget>[
                EventStat(
                  title: '12.1K+',
                  subtitle: 'Art Work',
                ),
                EventStat(
                  title: '1.7M+',
                  subtitle: 'Artist',
                ),
                EventStat(
                  title: '45K+',
                  subtitle: 'Auction',
                ),
              ],
            ),
            SizedBox(width: 60),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color(0xffe6d9fe),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => HomePage()));
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xffcab2ff),
                        ),
                        child: const Icon(Iconsax.arrow_right_1),
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Discover \nArtwork',
                      style: TextStyle(
                        fontSize: 24,
                        height: 1.3,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 9,
                      ),
                    ),
                    SizedBox(height: 12),
                    Divider(
                      thickness: 2,
                      endIndent: 120,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      
    ])));
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const AppLogo(),
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
          child: const Center(
            child: Icon(
              Iconsax.wallet_1,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class AppLogo extends StatelessWidget {
  const AppLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      nameGlobal[0].isNotEmpty ? nameGlobal[0] + '.' : 'U.',
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class ColoredText extends StatelessWidget {
  const ColoredText({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //width: 0,
      child: Stack(
        fit: StackFit.loose,
        children: [
          Positioned(
            bottom: 0,
            left: 90,
            child: Container(
              width: 120,
              height: 30,
              color: primaryColor.withOpacity(0.6),
            ),
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
              color: Colors.black,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class EventStat extends StatelessWidget {
  const EventStat({Key? key, required this.title, required this.subtitle})
      : super(key: key);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

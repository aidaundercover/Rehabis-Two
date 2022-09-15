import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rehabis/globalVars.dart';

class CollectionsMain extends StatefulWidget {
  const CollectionsMain({Key? key}) : super(key: key);

  @override
  State<CollectionsMain> createState() => _CollectionsMainState();
}

class _CollectionsMainState extends State<CollectionsMain> {
  @override
  Widget build(BuildContext context) {

    TextStyle titleStyle = TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: "Inter",
        fontSize: 19,
        color: Colors.grey.shade500);

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;


    return Center(
      child: SizedBox(
        width: width*0.98,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          SizedBox(height: 30),
          Text('Training Collections', style: TextStyle(color: primaryColor, fontSize: 28, fontFamily: "Inter")),
          SizedBox(height: 30),
          StreamBuilder(
            stream: FirebaseDatabase.instance.ref("Users/$iinGlobal/Trainigs").onValue,
            builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
              if(snapshot.hasData) {
                return Column(children: [
                  Text('Recent', style: titleStyle),
                ],);
              } else return Container();
            }),
            
          
          

        ]),
      ),
    );

  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streams/chapters/streamController.dart';

import 'custom_widget/custom_button.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Advance Flutter"
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomTextButton(
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => StreamControllerPage()));
                      },
                      title: "StreamBuilder",
                      textStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                      ),
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}

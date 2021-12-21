import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streams/custom_widget/custom_button.dart';

class Streams{
  Stream<int> countStream() async* {
    for (int i = 10; i >= 0; i--) {
      yield i;
      await Future.delayed(Duration(seconds: 1));
    }
  }
}

class StreamsPage extends StatefulWidget {
  const StreamsPage({Key key}) : super(key: key);

  @override
  _StreamsPageState createState() => _StreamsPageState();
}

class _StreamsPageState extends State<StreamsPage> {

  Streams strs = Streams();
  StreamSubscription strsub;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                strsub.cancel();
                Navigator.of(context).pop();
              },
            ),
            title: Text("Streams"),
            centerTitle: true,
          ),
          body:Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomTextButton(
                    onPressed: (){
                      strsub = strs.countStream().listen((event) {
                        print(event);
                      });
                    },
                    title: "Start Streams",
                    textStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                    ),
                  ),
                  SizedBox(height: 20,),
                  CustomTextButton(
                    onPressed: (){
                      strsub.cancel();
                    },
                    title: "Cancel streams",
                    textStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                    ),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streams/custom_widget/custom_button.dart';
import 'package:streams/themes/text_style.dart';

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
  int stream_val;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
                if(strsub!=null){
                  strsub.cancel();
                }

              },
            ),
            title: Text("Streams"),
            centerTitle: true,
          ),
          body:Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                      stream_val.toString(),
                      style: TextStyles.largeTitle,
                  ),
                  SizedBox(height: 10,),
                  CustomTextButton(
                    onPressed: (){
                      strsub = strs.countStream().listen((event) {
                        setState(() {
                          stream_val = event;
                        });
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

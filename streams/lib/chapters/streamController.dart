import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streams/custom_widget/custom_button.dart';

class StreamControllerClass{
  StreamController<int> _controller = StreamController<int>.broadcast();
  Stream<int> get outpipe => _controller.stream;
  Sink<int> get inpipe => _controller.sink;
}

class StreamControllerPage extends StatefulWidget {
  const StreamControllerPage({Key key}) : super(key: key);

  @override
  _StreamControllerPageState createState() => _StreamControllerPageState();
}

class _StreamControllerPageState extends State<StreamControllerPage> {

  StreamControllerClass _ctrlcls = StreamControllerClass();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text("Stream Builder"),
            centerTitle: true,
          ),
          body:Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  StreamBuilder<int>(
                      stream: _ctrlcls._controller.stream,
                      builder: (BuildContext context,AsyncSnapshot<int> snapshot){
                        if(!snapshot.hasData){
                          return Text("Has No data");
                        }
                        // Getting number from the stream as comes from stream
                        return Text(snapshot.data.toString());

                      }
                  ),
                  CustomTextButton(
                      onPressed: ()async {
                        // It is sending number one by one to sink at a delay of 1 sec
                        for(int i=0;i<10;i++){
                          if(!_ctrlcls._controller.isClosed) {
                            _ctrlcls._controller.sink.add(i);
                            await Future.delayed(Duration(seconds: 1));
                          }
                        }
                      },
                    title: "Stream-Builder",
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

  @override
  void dispose(){
    _ctrlcls._controller.close();
    super.dispose();
  }
}
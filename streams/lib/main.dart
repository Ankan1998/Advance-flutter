import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class StreamControllerClass{
  StreamController<int> _controller = StreamController<int>.broadcast();
  Stream<int> get outpipe => _controller.stream;
  Sink<int> get inpipe => _controller.sink;
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  StreamControllerClass _ctrlcls = StreamControllerClass();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                ElevatedButton(
                    onPressed: ()async {
                      // It is sending number one by one to sink at a delay of 1 sec
                      for(int i=0;i<10;i++){
                        _ctrlcls._controller.sink.add(i);
                        await Future.delayed(Duration(seconds: 1));
                      }
                    },
                    child: Text(
                      "press me"
                    )
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
  }
}

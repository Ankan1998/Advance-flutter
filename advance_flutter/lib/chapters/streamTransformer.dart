import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streams/custom_widget/custom_button.dart';
import 'package:streams/themes/text_style.dart';

class XStreamTransformer{

  StreamController<int> _controller = StreamController<int>.broadcast();
  Stream<int> get outpipe => _controller.stream;
  Sink<int> get inpipe => _controller.sink;

  StreamTransformer xstTrans = StreamTransformer<int,int>.fromHandlers(
    handleData: (data, sink){
      sink.add(data*10);
    }
  );
}


class StreamTransformerPage extends StatefulWidget {
  const StreamTransformerPage({Key key}) : super(key: key);

  @override
  _StreamTransformerPageState createState() => _StreamTransformerPageState();
}

class _StreamTransformerPageState extends State<StreamTransformerPage> {

  XStreamTransformer _xStreamTransformer = XStreamTransformer();

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
            title: Text("Stream Transformer"),
            centerTitle: true,
          ),
          body:Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Original",
                        style: TextStyles.largeTitle2,
                      ),
                      SizedBox(width: 10,),
                      StreamBuilder<int>(
                        // stream is transformed with StreamTransformer
                          stream: _xStreamTransformer.outpipe,
                          builder: (BuildContext context,AsyncSnapshot<int> snapshot){
                            if(!snapshot.hasData){
                              return Text(
                                "Has No data",
                                style: TextStyles.largeTitle,
                              );
                            }
                            // Getting number from the stream as comes from stream
                            return Text(
                              snapshot.data.toString(),
                              style: TextStyles.largeTitle,
                            );

                          }
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          "Transformed",
                        style: TextStyles.largeTitle2,
                      ),
                      SizedBox(width: 10,),
                      StreamBuilder<int>(
                        // stream is transformed with StreamTransformer
                          stream: _xStreamTransformer.outpipe.transform(_xStreamTransformer.xstTrans),
                          builder: (BuildContext context,AsyncSnapshot<int> snapshot){
                            if(!snapshot.hasData){
                              return Text(
                                "Has No data",
                                style: TextStyles.largeTitle,
                              );
                            }
                            // Getting number from the stream as comes from stream
                            return Text(
                              snapshot.data.toString(),
                              style: TextStyles.largeTitle,
                            );

                          }
                      ),
                    ],
                  ),
                  CustomTextButton(
                    onPressed: ()async {
                      // It is sending number one by one to sink at a delay of 1 sec
                      for(int i=0;i<10;i++){
                        if(!_xStreamTransformer._controller.isClosed) {
                          _xStreamTransformer.inpipe.add(i);
                          await Future.delayed(Duration(seconds: 1));
                        }
                      }
                    },
                    title: "Stream-Transformer",
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
    _xStreamTransformer._controller.close();
    super.dispose();
  }
}

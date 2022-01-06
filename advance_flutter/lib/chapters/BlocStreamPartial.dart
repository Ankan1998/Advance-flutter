import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streams/themes/text_style.dart';

// Bloc Event
abstract class StreamBlocEvent extends Equatable {
  const StreamBlocEvent();

  @override
  List<Object> get props => [];
}

class TextStreamEvent extends StreamBlocEvent{
  final String textQuery;

  TextStreamEvent(this.textQuery);
}
// Multiple Object passing through Stream
class StreamModel{
  String result;
  Color col;
}

// Bloc class
class StreamBloc{
  StreamModel stm = StreamModel();
  // Event StreamController
  StreamController<TextStreamEvent> _eventController = StreamController<TextStreamEvent>();
  Sink<TextStreamEvent> get eventSink => _eventController.sink;

  // State StreamController
  StreamController<StreamModel> _stateController = StreamController<StreamModel>();
  Stream<StreamModel> get outState => _stateController.stream;
  Sink<StreamModel> get inState => _stateController.sink;


  StreamBloc(){
    _eventController.stream.listen((event) {
      if(event.textQuery.length<5){
        stm.result = "keep Going";
        stm.col = Colors.blue;
        inState.add(stm);
      } else {
        stm.result = "Too much words";
        stm.col = Colors.red;
        inState.add(stm);
      }
    });
  }

}

class BlocStreamPartialPage extends StatefulWidget {
  const BlocStreamPartialPage({Key key}) : super(key: key);

  @override
  _BlocStreamPartialPageState createState() => _BlocStreamPartialPageState();
}

class _BlocStreamPartialPageState extends State<BlocStreamPartialPage> {
  final StreamBloc streamBloc = StreamBloc();

  Widget getErrorText(String errorText, Color colors) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
          height: 28,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                errorText,
                style: TextStyle(
                    fontSize: 20,
                    color: colors,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Bloc Stream Partial"),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: StreamBuilder(
              stream: streamBloc.outState,
              builder: (context, snapshot) {
                return Column(
                  children: [
                    Container(
                      child: Text(
                        "If input < 5 --> keep going else too much words",
                        textAlign: TextAlign.center,
                        style: TextStyles.largeTitle2,
                      ),
                    ),
                    Container(
                      width:300,
                      child: TextFormField(
                        onChanged: (val){
                          streamBloc.eventSink.add(TextStreamEvent(val));
                        },

                      ),
                    ),
                    snapshot.hasData?
                    getErrorText(snapshot.data.result.toString(),snapshot.data.col)
                        :Container()
                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}

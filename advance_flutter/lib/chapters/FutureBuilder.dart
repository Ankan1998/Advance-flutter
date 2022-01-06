import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streams/custom_widget/custom_button.dart';

// Repository to fetch Data
class Fakerepo {
  Dio dio = new Dio();

  Future<FakeModel> fetchData(String query) async {
    FakeModel fm = FakeModel();
    try {
      var response = await dio.get(
          'https://jsonplaceholder.typicode.com/todos/${query}'
      );
      fm = FakeModel.fromJson(response.data);
      fm.error = null;
      return fm;
    } catch (e) {
      fm.error = "Something went wrong";
      return fm;
    }
  }
}

//Model class
class FakeModel {
  int userId;
  int id;
  String title;
  bool completed;
  String error;

  FakeModel({this.userId, this.id, this.title, this.completed,this.error});

  FakeModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
    completed = json['completed'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['id'] = this.id;
    data['title'] = this.title;
    data['completed'] = this.completed;
    data['error'] = this.error;
    return data;
  }
}

class FutureBuilderPage extends StatefulWidget {
  const FutureBuilderPage({Key key}) : super(key: key);

  @override
  _FutureBuilderPageState createState() => _FutureBuilderPageState();
}

class _FutureBuilderPageState extends State<FutureBuilderPage> {
  Fakerepo fr = Fakerepo();
  final myController = TextEditingController();


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
            title: Text("Future Builder"),
            centerTitle: true,
          ),
          body:Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: 50,
                    child: TextField(
                      controller: myController,
                    ),
                  ),
                  SizedBox(height: 20,),
                  FutureBuilder(
                      future: fr.fetchData(myController.text),
                      builder: (BuildContext context,AsyncSnapshot snapshot){
                        if(snapshot.connectionState== ConnectionState.waiting){
                          return CircularProgressIndicator();
                        } else {
                          if(snapshot.data.error != null){
                            return Text(
                              'Error: ${snapshot.data.error.toString()}',
                              textAlign: TextAlign.center,
                            );
                          } else {
                            return Column(
                              children: [
                                Text(
                                  snapshot.data.id.toString()
                                ),
                                Text(
                                    snapshot.data.userId.toString()
                                ),
                                Text(
                                    snapshot.data.title
                                )
                              ],
                            );
                          }
                        }
                      }
                  ),
                  SizedBox(height: 30,),
                  CustomTextButton(
                    onPressed: ()async {
                      setState(() {
                        fr.fetchData(myController.text);
                      });
                    },
                    title: "Future-Builder",
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

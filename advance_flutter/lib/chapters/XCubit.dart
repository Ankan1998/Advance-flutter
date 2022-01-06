import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:streams/custom_widget/custom_button.dart';
import 'package:streams/themes/text_style.dart';

// Repository to fetch Data
class Fakerepo {
  Dio dio = new Dio();

  Future<FakeModel> fetchData() async {
    try {
      var response = await dio.get(
          'https://jsonplaceholder.typicode.com/todos/1'
      );
      return FakeModel.fromJson(response.data);
    } catch (e) {
      return e;
    }
  }
}

//Model class
class FakeModel {
  int userId;
  int id;
  String title;
  bool completed;

  FakeModel({this.userId, this.id, this.title, this.completed});

  FakeModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
    completed = json['completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['id'] = this.id;
    data['title'] = this.title;
    data['completed'] = this.completed;
    return data;
  }
}

// Cubit State Class
abstract class FakeState extends Equatable {
  const FakeState();

  @override
  List<Object> get props => [];
}

class FakeInitial extends FakeState {
  const FakeInitial();
}

class FakeLoading extends FakeState {
  const FakeLoading();
}

class FakeLoaded extends FakeState {
  final FakeModel fakemodel;

  const FakeLoaded(this.fakemodel);
}

class FakeError extends FakeState {
  final String msg;

  const FakeError(this.msg);
}

// Cubit Class
class FakeCubit extends Cubit<FakeState> {
  final Fakerepo fr;

  FakeCubit(this.fr) : super(FakeInitial());

  Future<void> getFake() async {
    try {
      emit(FakeLoading());
      var data = await fr.fetchData();
      emit(FakeLoaded(data));
    } catch (e) {
      emit(FakeError("Something Went Wrong"));
    }
  }
}


class CubitPage extends StatefulWidget {
  const CubitPage({Key key}) : super(key: key);

  @override
  _CubitPageState createState() => _CubitPageState();
}

class _CubitPageState extends State<CubitPage> {

  Widget buildLoading() {
    return CircularProgressIndicator();
  }

  Widget buildLoaded(FakeModel fmodel) {
    return Container(
      height: 100.0,
      child: Column(
        children: [
          Text(fmodel.title),
          Text(fmodel.id.toString()),
          Text(fmodel.userId.toString()),
          Text(fmodel.completed.toString())
        ],
      ),
    );
  }

  Widget buildError(String msg) {
    return Text(msg);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
          create: (_) => FakeCubit(Fakerepo()),
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("Cubit"),
            ),
            body: Center(
              child: SingleChildScrollView(
                  child: Column(
                    children: [
                      BlocConsumer<FakeCubit, FakeState>(
                        listener: (context, state) {
                          // TODO: implement listener
                        },
                        builder: (context, state) {
                          if(state is FakeLoading){
                            return buildLoading();
                          } else if(state is FakeLoaded){
                            return buildLoaded(state.fakemodel);
                          } else if (state is FakeError){
                            return buildError(state.msg);
                          } else{
                            return Text("Nothing to show");
                          }
                        },
                      ),
                      //https://www.youtube.com/watch?v=iNgwFMm3opE&list=PLptHs0ZDJKt_T-oNj_6Q98v-tBnVf-S_o&index=9 [21:30]
                      // Builder used to provide a context over the customtextButton to reach the BlocProvider
                      // It can be done by also using customtextButton inside the BlocConsumer then it search for blocProvider from context of Bloc consumer
                      // Other way is to define a separate stateless widget and then add it in the column
                      // VVIP else itwont find the context
                      Builder(
                        builder: (context) {
                          return CustomTextButton(
                            title: "Fetch data",
                            textStyle: TextStyles.button2,
                            onPressed: () async {
                              await context.read<FakeCubit>().getFake();
                            },
                          );
                        },
                      )
                    ],
                  )
              ),
            ),
          )
      ),
    );
  }
}


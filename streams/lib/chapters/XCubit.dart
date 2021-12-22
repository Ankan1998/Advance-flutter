import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

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





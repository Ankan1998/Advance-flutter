import 'package:dio/dio.dart';



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




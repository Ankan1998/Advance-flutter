import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// Repository to fetch Data
class FakeStoreRepo {
  Dio dio = new Dio();

  Future<FakeStoreModel> fetchData() async {
    try {
      var response = await dio.get(
          'https://fakestoreapi.com/products/1'
      );
      return FakeStoreModel.fromJson(response.data);
    } catch (e) {
      return e;
    }
  }
}

// Fake Store Model Class
class FakeStoreModel {
  int id;
  String title;
  double price;
  String description;
  String category;
  String image;
  Rating rating;

  FakeStoreModel(
      {this.id,
        this.title,
        this.price,
        this.description,
        this.category,
        this.image,
        this.rating});

  FakeStoreModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    description = json['description'];
    category = json['category'];
    image = json['image'];
    rating =
    json['rating'] != null ? new Rating.fromJson(json['rating']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['price'] = this.price;
    data['description'] = this.description;
    data['category'] = this.category;
    data['image'] = this.image;
    if (this.rating != null) {
      data['rating'] = this.rating.toJson();
    }
    return data;
  }
}

class Rating {
  double rate;
  int count;

  Rating({this.rate, this.count});

  Rating.fromJson(Map<String, dynamic> json) {
    rate = json['rate'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rate'] = this.rate;
    data['count'] = this.count;
    return data;
  }
}


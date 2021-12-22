import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streams/custom_widget/custom_button.dart';
import 'package:streams/themes/text_style.dart';

// Repository to fetch Data
class FakeStoreRepo {
  Dio dio = new Dio();

  Future<FakeStoreModel> fetchData(String query) async {
    try {
      var response = await dio.get(
          'https://fakestoreapi.com/products/${query}'
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

// Bloc Event
abstract class FakeEvent extends Equatable {
  const FakeEvent();

  @override
  List<Object> get props => [];
}

class FetchEvent extends FakeEvent{
  final searchQuery;

  FetchEvent(this.searchQuery);
}

class ResetEvent extends FakeEvent{

}

// Bloc state
abstract class FakeState extends Equatable {
  const FakeState();
  @override
  List<Object> get props => [];
}

class FakeInitial extends FakeState {

}

class FakeLoading extends FakeState{

}

class FakeLoaded extends FakeState{
  final FakeStoreModel fakeStoreModel;

  FakeLoaded(this.fakeStoreModel);
}

class FakeError extends FakeState{
  final String errorMsg;

  FakeError(this.errorMsg);
}

// Bloc class
class FakeBloc extends Bloc<FakeEvent, FakeState> {

  final FakeStoreRepo fsr;

  FakeBloc(this.fsr) : super(FakeInitial()) {

    on<FetchEvent>(_onFetch);
    on<ResetEvent>(_onReset);
  }

  void _onFetch(FetchEvent event, Emitter<FakeState> emit) async {
    try{
      emit(FakeLoading());
      FakeStoreModel data = await fsr.fetchData(event.searchQuery);
      emit(FakeLoaded(data));
    }catch(e){
      emit(FakeError("Something Went miserably wrong"));
    }
  }

  void _onReset(ResetEvent event, Emitter<FakeState> emit) async {
    emit(FakeInitial());
  }
}



class BlocPage extends StatefulWidget {
  const BlocPage({Key key}) : super(key: key);

  @override
  _BlocPageState createState() => _BlocPageState();
}

class _BlocPageState extends State<BlocPage> {
  final myController = TextEditingController();

  Widget buildInitial(){
    return Text("Nothing to Show!! Pls fetch data");
  }
  Widget buildLoading() {
    return CircularProgressIndicator();
  }

  Widget buildLoaded(FakeStoreModel fmodel) {
    return Container(
      child: Column(
        children: [
          Image.network(
            fmodel.image,
            width: 250,
            height: 250,
          ),
          Text(fmodel.id.toString()),
          Text(fmodel.title),
          Text(fmodel.category),
          Text(fmodel.description),
          Text(fmodel.price.toString()),
          Text(fmodel.rating.rate.toString())
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
          create: (_) => FakeBloc(FakeStoreRepo()),
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("Bloc"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
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
                        BlocConsumer<FakeBloc, FakeState>(
                          listener: (context, state) {
                            // TODO: implement listener
                          },
                          builder: (context, state) {
                            if(state is FakeLoading){
                              return buildLoading();
                            } else if(state is FakeLoaded){
                              return buildLoaded(state.fakeStoreModel);
                            } else if (state is FakeError){
                              return buildError(state.errorMsg);
                            } else{
                              return buildInitial();
                            }
                          },
                        ),
                        SizedBox(height:20),
                        //https://www.youtube.com/watch?v=iNgwFMm3opE&list=PLptHs0ZDJKt_T-oNj_6Q98v-tBnVf-S_o&index=9 [21:30]
                        // Builder used to provide a context over the customtextButton to reach the BlocProvider
                        // It can be done by also using customtextButton inside the BlocConsumer then it search for blocProvider from context of Bloc consumer
                        // Other way is to define a separate stateless widget and then add it in the column
                        // VVIP else itwont find the context
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Builder(
                              builder: (context) {
                                return CustomTextButton(
                                  title: "Fetch",
                                  textStyle: TextStyles.button2,
                                  onPressed: () async {
                                    await context.read<FakeBloc>().add(FetchEvent(myController.text));
                                  },
                                );
                              },
                            ),
                            Builder(
                              builder: (context) {
                                return CustomTextButton(
                                  title: "Clear",
                                  textStyle: TextStyles.button2,
                                  onPressed: () async {
                                    await context.read<FakeBloc>().add(ResetEvent());
                                  },
                                );
                              },
                            ),
                          ],
                        )
                      ],
                    )
                ),
              ),
            ),
          )
      ),
    );
  }
}


import 'package:dio_and_json/model/exchange_rate.dart';
import 'package:flutter/material.dart';
import 'package:coins_notif/http_service.dart';
import 'package:dio/dio.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HttpService http;

  Future getRate() async {
    Response response;
    try {
      response = await http.getRequest("");
      if (response.statusCode == 200) {
        ExchangeRate
      } else {
        print("There is some problem status code not 200");
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get Exchange Rate"),
      ),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

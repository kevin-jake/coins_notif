import 'dart:convert';

import 'package:coins_notif/model/exchange_rate.dart';
import 'package:coins_notif/http_service.dart';
import 'package:coins_notif/model/post_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HttpService http_serv;

  ExchangeRate btc_to_php;
  bool isLoading = false;
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  PostModel _post;

  TextEditingController investController = TextEditingController();
  TextEditingController boughtController = TextEditingController();
  TextEditingController profitController = TextEditingController();

  FlutterLocalNotificationsPlugin fltNotification;
  var token_global;

  Future getRate() async {
    Response response;
    try {
      isLoading = true;
      response = await http_serv.getRequest("/v2/markets/BTC-PHP");
      isLoading = false;
      if (response.statusCode == 200) {
        setState(() {
          btc_to_php = ExchangeRate.fromJson(response.data);
        });
      } else {
        print("There is some problem status code not 200");
      }
    } on Exception catch (e) {
      isLoading = false;
      print(e);
    }
  }

  Future<PostModel> submitData(String investedPrice, String boughtPrice,
      String desiredProfit, String token) async {
    var resp = await http.post(
        Uri.https(
            'jdkc8ptwk6.execute-api.us-east-1.amazonaws.com', '/test/notify'),
        body: jsonEncode({
          "invested_price": int.parse(investedPrice),
          "bought_price": int.parse(boughtPrice),
          "desired_profit": int.parse(desiredProfit),
          "token": token
        }));
    int jsonsDataString = resp.statusCode;
    if (resp.statusCode == 200) {
      print(jsonsDataString);
      return PostModel();
    } else {
      print(jsonsDataString);
      return null;
    }
  }

  @override
  void initState() {
    notifPermission();
    initMessaging();
    http_serv = HttpService();
    getRate();
    super.initState();
  }

  void getToken() async {
    token_global = await messaging.getToken();
    print(token_global);
  }

  @override
  Widget build(BuildContext context) {
    getToken();
    return Scaffold(
        appBar: AppBar(
          title: Text("Get Exchange Rate"),
        ),
        body: isLoading
            ? Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      Container(
                        height: 20,
                      ),
                      SizedBox(
                          width: 350,
                          child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter Invested Price'),
                            controller: investController,
                          )),
                      Container(
                        height: 2,
                      ),
                      SizedBox(
                          width: 350,
                          child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter bought Price'),
                            controller: boughtController,
                          )),
                      Container(height: 2),
                      SizedBox(
                          width: 350,
                          child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter desired Profit'),
                            controller: profitController,
                          )),
                      Container(height: 20),
                      ElevatedButton(
                          onPressed: () async {
                            final String investedPrice = investController.text;
                            final String boughtPrice = boughtController.text;
                            final String desiredProfit = profitController.text;
                            final String token = token_global;

                            final PostModel postbody = await submitData(
                                investedPrice,
                                boughtPrice,
                                desiredProfit,
                                token);
                            print(postbody);
                            setState(() {
                              _post = postbody;
                            });
                          },
                          child: Text("Submit")),
                      SizedBox(
                        height: 32,
                      ),
                      _post == null ? Container() : Text("SUCCESSFUL POST!")
                    ]))
            : btc_to_php != null
                ? Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Symbol: ${btc_to_php.symbol}"),
                        Container(
                          height: 2,
                        ),
                        Text("Currency: ${btc_to_php.currency}"),
                        Container(
                          height: 2,
                        ),
                        Text("Sell Price: Php ${btc_to_php.bid}"),
                        Container(
                          height: 2,
                        ),
                        Text("Buy Price: Php ${btc_to_php.ask}"),
                        Container(
                          height: 20,
                        ),
                        SizedBox(
                            width: 350,
                            child: TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter Invested Price'),
                              controller: investController,
                            )),
                        Container(
                          height: 8,
                        ),
                        SizedBox(
                            width: 350,
                            child: TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter bought Price'),
                              controller: boughtController,
                            )),
                        Container(
                          height: 8,
                        ),
                        SizedBox(
                            width: 350,
                            child: TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter desired Profit'),
                              controller: profitController,
                            )),
                        Container(height: 20),
                        ElevatedButton(
                            onPressed: () async {
                              final String investedPrice =
                                  investController.text;
                              final String boughtPrice = boughtController.text;
                              final String desiredProfit =
                                  profitController.text;
                              final String token = token_global;

                              final PostModel postbody = await submitData(
                                  investedPrice,
                                  boughtPrice,
                                  desiredProfit,
                                  token);
                              print(postbody);
                              setState(() {
                                _post = postbody;
                              });
                            },
                            child: Text("Submit")),
                        SizedBox(
                          height: 32,
                        ),
                        _post == null ? Container() : Text("SUCCESSFUL POST!")
                      ],
                    ),
                  )
                : Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Text("No Data"),
                        Container(
                          height: 20,
                        ),
                        SizedBox(
                            width: 350,
                            child: TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter Invested Price'),
                              controller: investController,
                            )),
                        Container(
                          height: 2,
                        ),
                        SizedBox(
                            width: 350,
                            child: TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter bought Price'),
                              controller: boughtController,
                            )),
                        Container(height: 2),
                        SizedBox(
                            width: 350,
                            child: TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter desired Profit'),
                              controller: profitController,
                            )),
                        Container(height: 20),
                        ElevatedButton(
                            onPressed: () async {
                              final String investedPrice =
                                  investController.text;
                              final String boughtPrice = boughtController.text;
                              final String desiredProfit =
                                  profitController.text;
                              final String token = token_global;

                              final PostModel postbody = await submitData(
                                  investedPrice,
                                  boughtPrice,
                                  desiredProfit,
                                  token);
                              print(postbody);
                              setState(() {
                                _post = postbody;
                              });
                            },
                            child: Text("Submit")),
                        SizedBox(
                          height: 32,
                        ),
                        _post == null ? Container() : Text("SUCCESSFUL POST!")
                      ])));
  }

  void initMessaging() {
    var androiInit = AndroidInitializationSettings('ic_launcher');

    var initSetting = InitializationSettings(android: androiInit);

    fltNotification = FlutterLocalNotificationsPlugin();

    fltNotification.initialize(initSetting);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message);
    });
  }

  void showNotification(message) async {
    RemoteNotification notification = message.notification;
    AndroidNotification android = message.notification?.android;
    var androidDetails = AndroidNotificationDetails(
        '1', 'channelName', 'channel Description',
        styleInformation: BigTextStyleInformation(''));

    var generalNotificationDetails =
        NotificationDetails(android: androidDetails);

    await fltNotification.show(notification.hashCode, notification.title,
        notification.body, generalNotificationDetails,
        payload: 'Notification');
  }

  void notifPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }
}

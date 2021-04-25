import 'package:coins_notif/model/market_resp.dart';
import 'package:coins_notif/model/exchange_rate.dart';
import 'package:coins_notif/http_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:coins_notif/http_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HttpService http;

  ExchangeRate btc_to_php;
  bool isLoading = false;
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  TextEditingController investController = TextEditingController();
  TextEditingController boughtController = TextEditingController();
  TextEditingController profitController = TextEditingController();

  FlutterLocalNotificationsPlugin fltNotification;

  Future getRate() async {
    Response response;
    try {
      isLoading = true;
      response = await http.getRequest("/v2/markets/BTC-PHP");
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

  @override
  void initState() {
    notifPermission();
    initMessaging();
    http = HttpService();
    getRate();
    super.initState();
  }

  void getToken() async {
    print(await messaging.getToken());
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
                      ElevatedButton(onPressed: () {}, child: Text("Submit"))
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
                        ElevatedButton(onPressed: () {}, child: Text("Submit"))
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
                        ElevatedButton(onPressed: () {}, child: Text("Submit"))
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

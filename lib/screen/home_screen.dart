import 'package:coins_notif/model/market_resp.dart';
import 'package:coins_notif/model/exchange_rate.dart';
import 'package:coins_notif/http_service.dart';
import 'package:flutter/material.dart';
import 'package:coins_notif/http_service.dart';
import 'package:dio/dio.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HttpService http;

  ExchangeRate btc_to_php;
  bool isLoading = false;

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
    http = HttpService();
    getRate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get Exchange Rate"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
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
                    ],
                  ),
                )
              : Center(
                  child: Text("No Data"),
                ),
    );
  }
}

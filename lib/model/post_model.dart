// To parse this JSON data, do
//
//     final PostModel = postmodel(jsonString);

import 'dart:convert';

// PostModel postFromJson(String str) => PostModel.fromJson(json.decode(str));

String postToJson(PostModel data) => json.encode(data.toJson());

class PostModel {
  PostModel({
    this.investedPrice,
    this.boughtPrice,
    this.desiredProfit,
    this.token,
  });

  int investedPrice;
  int boughtPrice;
  int desiredProfit;
  String token;

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        investedPrice: json["invested_price"],
        boughtPrice: json["bought_price"],
        desiredProfit: json["desired_profit"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "invested_price": investedPrice,
        "bought_price": boughtPrice,
        "desired_profit": desiredProfit,
        "token": token,
      };
}

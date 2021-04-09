import 'package:json_annotation/json_annotation.dart';

part 'exchange_rate.g.dart'


class   ExchangeRate{

  @JsonKey("symbol")
  String symbol;

  @JsonKey("currency")
  String currency;

  @JsonKey("product")
  String product;

  @JsonKey("currency")
  String currency;

  @JsonKey("bid")
  String bid;

  @JsonKey("ask")
  String ask;

  @JsonKey("expires_in_seconds")
  int expires_in_seconds;

  ExchangeRate();

   factory ExchangeRate.fromJson(Map<String, dynamic> json) => _$ExchangeRateFromJson(json);
  Map<String, dynamic> toJson() => _$ExchangeRateToJson(this);
}

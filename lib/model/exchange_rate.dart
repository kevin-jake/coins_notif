import 'package:json_annotation/json_annotation.dart';

part 'exchange_rate.g.dart';

@JsonSerializable()
class ExchangeRate {
  @JsonKey(name: "symbol")
  String symbol;

  @JsonKey(name: "currency")
  String currency;

  @JsonKey(name: "product")
  String product;

  @JsonKey(name: "bid")
  String bid;

  @JsonKey(name: "ask")
  String ask;

  @JsonKey(name: "expires_in_seconds")
  int expires_in_seconds;

  ExchangeRate();

  factory ExchangeRate.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRateFromJson(json);
  Map<String, dynamic> toJson() => _$ExchangeRateToJson(this);
}

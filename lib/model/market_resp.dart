import 'exchange_rate.dart';
import 'package:json_annotation/json_annotation.dart';

part 'market_resp.g.dart';

@JsonSerializable()
class MarketResp {
  MarketResp();

  @JsonKey(name: "markets")
  List<ExchangeRate> markets;

  factory MarketResp.fromJson(Map<String, dynamic> json) =>
      _$MarketRespFromJson(json);
  Map<String, dynamic> toJson() => _$MarketRespToJson(this);
}

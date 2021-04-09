// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketResp _$MarketRespFromJson(Map<String, dynamic> json) {
  return MarketResp()
    ..market = (json['market'] as List)
        ?.map((e) =>
            e == null ? null : ExchangeRate.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$MarketRespToJson(MarketResp instance) =>
    <String, dynamic>{
      'market': instance.market,
    };

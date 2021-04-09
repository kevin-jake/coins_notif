// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketResp _$MarketRespFromJson(Map<String, dynamic> json) {
  return MarketResp()
    ..markets = (json['markets'] as List)
        ?.map((e) =>
            e == null ? null : ExchangeRate.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$MarketRespToJson(MarketResp instance) =>
    <String, dynamic>{
      'markets': instance.markets,
    };

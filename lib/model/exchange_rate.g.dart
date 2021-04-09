// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_rate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExchangeRate _$ExchangeRateFromJson(Map<String, dynamic> json) {
  return ExchangeRate()
    ..symbol = json['symbol'] as String
    ..currency = json['currency'] as String
    ..product = json['product'] as String
    ..bid = json['bid'] as String
    ..ask = json['ask'] as String
    ..expires_in_seconds = json['expires_in_seconds'] as int;
}

Map<String, dynamic> _$ExchangeRateToJson(ExchangeRate instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'currency': instance.currency,
      'product': instance.product,
      'bid': instance.bid,
      'ask': instance.ask,
      'expires_in_seconds': instance.expires_in_seconds,
    };

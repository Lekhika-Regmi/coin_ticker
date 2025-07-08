import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR',
];

const List<String> cryptoList = ['BTC', 'ETH', 'LTC'];
final String apiKey = '${dotenv.env['COINAPI_KEY']}';
String get url =>
    "https://api.currencyfreaks.com/v2.0/rates/latest?apikey=$apiKey";

class CoinData {
  Map<String, dynamic>? _coinRates; // Fixed: Changed * to _

  Future<void> getCoinData() async {
    print('getcoindata called');
    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var allCoinData = jsonDecode(response.body);
        _coinRates = allCoinData['rates']; // Fixed: Changed * to _
      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    } catch (e) {
      print('Error fetching coin data: $e');
      throw 'Failed to fetch coin data';
    }
  }

  // Convert 1 BTC to specified currency
  String convertBTCTo(String currency) {
    if (_coinRates == null) {
      return 'Data not available';
    }

    // BTC rate is how many BTC you get for 1 USD
    // To convert 1 BTC to USD: 1 / BTC_rate
    // To convert 1 BTC to another currency: (1 / BTC_rate) * currency_rate

    try {
      double btcRate = double.parse(_coinRates!['BTC'].toString());
      double usdValue = 1 / btcRate; // 1 BTC in USD

      if (currency == 'USD') {
        return usdValue.toStringAsFixed(2);
      }

      double currencyRate = double.parse(_coinRates![currency].toString());
      double convertedValue = usdValue * currencyRate;

      return convertedValue.toStringAsFixed(2);
    } catch (e) {
      return 'Error: Currency not found';
    }
  }

  // Convert 1 ETH to specified currency
  String convertETHTo(String currency) {
    if (_coinRates == null) {
      return 'Data not available';
    }

    try {
      double ethRate = double.parse(_coinRates!['ETH'].toString());
      double usdValue = 1 / ethRate; // 1 ETH in USD

      if (currency == 'USD') {
        return usdValue.toStringAsFixed(2);
      }

      double currencyRate = double.parse(_coinRates![currency].toString());
      double convertedValue = usdValue * currencyRate;

      return convertedValue.toStringAsFixed(2);
    } catch (e) {
      return 'Error: Currency not found';
    }
  }

  // Convert 1 LTC to specified currency
  String convertLTCTo(String currency) {
    if (_coinRates == null) {
      return 'Data not available';
    }

    try {
      double ltcRate = double.parse(_coinRates!['LTC'].toString());
      double usdValue = 1 / ltcRate; // 1 LTC in USD

      if (currency == 'USD') {
        return usdValue.toStringAsFixed(2);
      }

      double currencyRate = double.parse(_coinRates![currency].toString());
      double convertedValue = usdValue * currencyRate;

      return convertedValue.toStringAsFixed(2);
    } catch (e) {
      return 'Error: Currency not found';
    }
  }

  // Generic function to convert any crypto to any currency
  String convertCryptoTo(String fromCrypto, String toCurrency) {
    switch (fromCrypto.toUpperCase()) {
      case 'BTC':
        return convertBTCTo(toCurrency);
      case 'ETH':
        return convertETHTo(toCurrency);
      case 'LTC':
        return convertLTCTo(toCurrency);
      default:
        return 'Error: Unsupported cryptocurrency';
    }
  }
}

import 'dart:io';

import 'package:bitcoin_ticker_flutter/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  CoinData coinData = CoinData();
  Map<String, String> cryptoPrices = {'BTC': '?', 'ETH': '?', 'LTC': '?'};
  bool isLoading = false;
  String selectedCurrency = 'USD';
  List<Text> pickerItems = [];
  DropdownButton<String> androidDropdownButton() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(child: Text(currency), value: currency);
      dropdownItems.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
        });
        getData();
      },
    );
  }

  CupertinoPicker iOSPicker() {
    pickerItems.clear();
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency, textAlign: TextAlign.center));
    }
    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        //  selectedCurrency = g[selectedIndex];
        selectedCurrency = currenciesList[selectedIndex];
        getData();
      },
      children: pickerItems,
    );
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      await coinData.getCoinData();
      setState(() {
        cryptoPrices['BTC'] = coinData.convertBTCTo(selectedCurrency);
        cryptoPrices['ETH'] = coinData.convertETHTo(selectedCurrency);
        cryptoPrices['LTC'] = coinData.convertLTCTo(selectedCurrency);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        cryptoPrices['BTC'] = 'Error';
        cryptoPrices['ETH'] = 'Error';
        cryptoPrices['LTC'] = 'Error';
        isLoading = false;
      });
      print('Error in getData: $e');
    }
  }

  // Helper method to create crypto cards
  Widget createCryptoCard(String crypto) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Color(0xFF124B78),
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            isLoading
                ? '1 $crypto = Loading...'
                : '1 $crypto = ${cryptoPrices[crypto]} $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF124B78),
        title: Center(
          child: Text('🤑 Coin Ticker', textAlign: TextAlign.center),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              createCryptoCard('BTC'),
              createCryptoCard('ETH'),
              createCryptoCard('LTC'),
            ],
          ),
          Container(
            height: 100.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 10.0),
            color: Color(0xFF124B78),
            child: Center(
              child: Platform.isIOS ? iOSPicker() : androidDropdownButton(),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';

import 'package:cart/cart_model.dart';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;
  late Map<String, dynamic> usermap;
  List<Map<String, dynamic>> listOfLists = [];
  List<Cart> CartList = [];
  int qt = 0;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  late Future<List<Cart>> _cart;
  Future<List<Cart>> get cart => _cart;

  Future<List<Map<String, dynamic>>> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString('listOfLists');
    if (jsonData != null) {
      listOfLists = json.decode(jsonData).cast<Map<String, dynamic>>();
      notifyListeners();
    }
    return listOfLists;
  }

  removemap(String inputmap) {
    List<Map<String, dynamic>> newList = List.castFrom(listOfLists);
    listOfLists.removeWhere((map) => map["productName"] == inputmap);

    listOfLists = newList;
    _setPrefItems();
    notifyListeners();
  }

  void _setPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_item', _counter);
    prefs.setDouble('total_price', _totalPrice);

    prefs.setString('listOfLists', json.encode(listOfLists));
    notifyListeners();
  }

  void _getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_item') ?? 0;
    _totalPrice = prefs.getDouble('total_price') ?? 0.0;
    notifyListeners();
  }

  void addTotalPrice(double productPrice) {
    _totalPrice = _totalPrice + productPrice;
    _setPrefItems();
    notifyListeners();
  }

  void removeTotalPrice(double productPrice) {
    _totalPrice = _totalPrice - productPrice;
    _setPrefItems();
    notifyListeners();
  }

  double getTotalPrice() {
    _getPrefItems();
    return _totalPrice;
  }

  void addCounter() {
    _counter++;
    _setPrefItems();
    notifyListeners();
  }

  void removerCounter() {
    _counter--;
    _setPrefItems();
    notifyListeners();
  }

  int getCounter() {
    _getPrefItems();
    return _counter;
  }
}

import 'package:flutter/foundation.dart';
import './cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.datetime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartproducts, double total) async {
    final timestamp = DateTime.now();
    const url =
        'https://flutterlearning-9fe4d-default-rtdb.europe-west1.firebasedatabase.app/orders.json';
    // try {
      final response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartproducts
              .map((cartproduct) => {
                    'id': cartproduct.id,
                    'title': cartproduct.title,
                    'quantity': cartproduct.quantity,
                    'price': cartproduct.price
                  })
              .toList(),
        }),
      );
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartproducts,
          datetime: timestamp,
        ),
      );
      notifyListeners();
    // } catch (error) {
    //   throw error;
    // }
  }
}

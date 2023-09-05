import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';

class CartProvider extends ChangeNotifier
{
  double count=0.0;
  List<Product> _productsInCart = [];
  List<Product> get productsInCart => _productsInCart;

  void addToCart(Product product) {
    _productsInCart.add(product);
    count+=product.salary;
    notifyListeners();
  }
  void removefromCart(Product product){
    _productsInCart.remove(product);
    notifyListeners();
  }

  void clearCart() {
    count=0.0;
    _productsInCart.clear();

    notifyListeners();
  }

  Future<void> checkout() async{

    await FirebaseFirestore.instance.collection('orders').add({
      'dt': DateTime.now().millisecondsSinceEpoch,
      'order': _productsInCart.map((e) => e.toMap()).toList(),
      'uid': FirebaseAuth.instance.currentUser!.uid,
    });


    clearCart();
  }
}
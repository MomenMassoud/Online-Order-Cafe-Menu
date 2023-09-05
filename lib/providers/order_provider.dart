import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/order.dart';

class OrderProvider extends ChangeNotifier
{
  List<OrderModel> _orders = [];
  List<OrderModel> get orders => _orders;
  late final FirebaseAuth _firebaseAuth;
  late final FirebaseFirestore _firebaseFirestore;

  OrderProvider(FirebaseAuth fa, FirebaseFirestore ff){
    _firebaseAuth = fa;
    _firebaseFirestore = ff;

    getAllOrders();
  }

  Future<void> getAllOrders() async {
    String uid = _firebaseAuth.currentUser!.uid;
    final snapshots = await _firebaseFirestore.collection('orders').get();

    for( var snapshot in snapshots.docs){
      log(snapshot.toString());
      if( snapshot['uid'] == uid){
        OrderModel orderModel = OrderModel.fromJSON(snapshot.data());
        _orders.add(orderModel);
      }
    }
    notifyListeners();
  }
}
import 'package:youssef_starbucks/models/product.dart';

class OrderModel {
  final String uid;
  final int dt;
  final List<Product> order;

  OrderModel({
    required this.uid,
    required this.dt,
    required this.order,
  });

  factory OrderModel.fromJSON(Map<String, dynamic> map) {

    List<Product> orders = [];

    for( var json in map['order']){
      Product p = Product.fromJSON( json );
      orders.add(p);
    }


    return OrderModel(
      uid: map['uid'],
      dt: map['dt'],
      order: orders,
    );
  }
}

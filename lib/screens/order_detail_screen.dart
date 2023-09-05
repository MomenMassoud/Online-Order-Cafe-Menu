import 'package:flutter/material.dart';
import 'package:youssef_starbucks/models/order.dart';
import 'package:youssef_starbucks/models/product.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderModel orderModel;

  const OrderDetailScreen({Key? key, required this.orderModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Text(
              'Items in Order',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: orderModel.order.length,
                    itemBuilder: (context, index) {
                      Product product = orderModel.order[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Image.asset(
                                product.image,
                                width: 100,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4,),

                                    Text('${product.calories} Calories'),
                                    const SizedBox(height: 4,),
                                    Text(product.description, maxLines: 3, overflow: TextOverflow.ellipsis,),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }))
          ],
        ),
      ),
    );
  }
}

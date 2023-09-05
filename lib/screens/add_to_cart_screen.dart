import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:youssef_starbucks/models/product.dart';
import 'package:youssef_starbucks/providers/cart_provider.dart';

class AddToCartScreen extends StatelessWidget {
  final Product product;

  const AddToCartScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return Scaffold( backgroundColor:Color(0xFFEFD5BF),
      appBar: AppBar(
        backgroundColor:Color(0xFFD3AE89),
        title: const Text('Product Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    product.image,
                   // height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                product.name,
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,

              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    '${product.salary} E£',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    '${product.calories} Calories',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Icon(
                    Icons.fastfood,

                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                product.description,
                style: TextStyle(
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                onPressed: () {
                  cartProvider.addToCart(product);
                  Fluttertoast.showToast(msg: 'Product Added');
                },
                child: Text(
                  'Add to Cart',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF7C3924),
                  padding:
                  EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
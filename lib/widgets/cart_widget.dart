import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:youssef_starbucks/config/constants.dart';
import 'package:youssef_starbucks/providers/cart_provider.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        context.pushNamed(checkoutScreenRoute);
      },
      child: Stack(
        children: [
         const SizedBox(
            //color: Colors.red,
            width: 50,
            height: 50,
            child: Icon(
              Icons.shopping_cart,
              color: Colors.white,
              size: 30,
            ),
          ),
          Positioned(
              right: 0,
              top: 0,
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.red,
                child: Consumer<CartProvider>(
                  builder: (context, cartProvider, child){
                    return Text('${cartProvider.productsInCart.length}', style: const TextStyle(fontSize: 14, color: Colors.white),);
                  },
                ),
              ))
        ],
      ),
    );
  }
}

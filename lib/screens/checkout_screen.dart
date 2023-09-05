import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:youssef_starbucks/providers/cart_provider.dart';
import 'package:youssef_starbucks/providers/order_provider.dart';
import '../models/product.dart';
import 'dart:math';

import 'credit_card.dart';

class CheckoutScreen extends StatefulWidget {
  double points;

  CheckoutScreen({Key? key, required this.points }) : super(key: key);


  late int count=1;


  @override
  _CheckoutScreen createState()=> _CheckoutScreen();
  }


class _CheckoutScreen extends State<CheckoutScreen> {
final FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore firestore=FirebaseFirestore.instance;
String NameUser="";
TextEditingController textEditingController=TextEditingController();
int count=0;

 static int _randomNumber = Random().nextInt(100);
 late double value;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.points=0.0;
    value=0.0;
  }
  void CalcCountItem(CartProvider card){

  }
  @override
  Widget build(BuildContext context) {

    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    return Scaffold(
      backgroundColor:Color(0xFFEFD5BF),
      appBar: AppBar(
        //0xFF7C3924
        backgroundColor: Color(0xFF4E2612),
        title: const Text('Checkout'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),

            child: Column(
              children: [
                Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                Text(
                'Your Number :$_randomNumber',
                style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
                ),
                  SizedBox(height: 10),
                ],
                ),
                Expanded(

                  child: ListView.builder(

                      itemCount: cartProvider.productsInCart.length+2,
                      itemBuilder: (context, index) {
                        if(index == cartProvider.productsInCart.length){
                          return TextField(
                            controller: textEditingController,
                            decoration: InputDecoration(

                              labelText: 'Enter promo code',
                              suffixIcon: IconButton(


                                onPressed: () {
                                  if (textEditingController.text == 'sec') {
                                    if(widget.count<2){
                                      setState(() {
                                        cartProvider.count-=5.0;
                                      });

                                      widget.count++;
                                      Fluttertoast.showToast(msg: 'Promo code incorrect');
                                    }
                                    else{
                                      Fluttertoast.showToast(msg: 'Promo code is Entered' );
                                    }
                                  }
                                  else{
                                    Fluttertoast.showToast(msg: 'Promo code incorrect');
                                  }
                                },
                                icon: Icon(Icons.check),
                              ),
                            ),
                          );
                        }
                         else if(index == cartProvider.productsInCart.length+1){

                          return Card(
                            color:Color(0xFFF4E9E4),
                            child: ListTile(
                              title: Text('Total Amount is ${cartProvider.count.toString()}', style: TextStyle(
                                fontWeight: FontWeight.bold, // set font weight to bold
                                fontSize: 30, // set font size to 20
                              ),
                              ), // display the newpoint value as the subtitle
                            ),
                          );
                        }

                        else{
                          Product product = cartProvider.productsInCart[index];
                          String  title=product.name;
                          String  subtitleText=product.salary.toString();
                          return Card(
                            color:Color(0xFFF4E9E4),
                            child: ListTile(
                              leading: Image.network(

                                product.image,
                                width: 60,
                                height: 70,
                              ),
                              title: Text(title),
                              subtitle: Text(subtitleText),
                              trailing: IconButton(
                                onPressed: (){
                                  cartProvider.count-=product.salary;
                                  cartProvider.removefromCart(product);
                                  if(cartProvider.count<0){
                                    cartProvider.count=0.0;
                                  }
                                },
                                icon: Icon(Icons.delete),
                              ),

                            ),
                          );
                        }


                      }
                      ),
                ),


                  Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF7C3924),
                          ),

                          onPressed: ()async {
                            try{
                              for(int i=0;i<cartProvider.productsInCart.length;i++){
                                getUser();
                                Product product = cartProvider.productsInCart[i];
                                String id = DateTime.now().toString();
                                await firestore.collection('submit').doc(id).set({
                                  'order_name':product.name,
                                  'cost':product.salary.toString(),
                                  'name':NameUser,
                                  'email':_auth.currentUser?.email,
                                });
                              }
                            }
                            catch(e){
                              print(e);
                            }

                              cartProvider.clearCart();
                              Navigator.pop(context);

                            // cartProvider.clearCart();
                            // widget.newpoint = 0;
                            // Fluttertoast.showToast(
                            //     msg: 'Your order has been placed ');

                          },
                          child: const Text('Cash'),
                        )),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF7C3924),
                          ),
                          onPressed:

                          cartProvider.productsInCart.isEmpty
                              ? null
                              : () async {
                            Navigator.push(

                              context,
                              MaterialPageRoute(builder: (context) => CreditCardPaymentPage()),
                            );

                          },
                          child: const Text('Visa'),
                        )
                    ),

                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void getUser()async{
    await for(var snapshot in firestore.collection("users").where('email',isEqualTo: _auth.currentUser?.email).snapshots()){
      for(var massage in snapshot.docs){
        setState(() {
          NameUser=massage.get('name');
        });
      }
    }
  }
}

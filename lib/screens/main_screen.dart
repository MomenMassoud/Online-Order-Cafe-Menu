import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youssef_starbucks/config/constants.dart';
import 'package:youssef_starbucks/config/data_store.dart';
import 'package:youssef_starbucks/models/product.dart';
import 'package:youssef_starbucks/screens/add_to_cart_screen.dart';
import 'package:youssef_starbucks/screens/notifiy_Screen.dart';
import 'package:youssef_starbucks/screens/order_detail_screen.dart';
import 'package:youssef_starbucks/widgets/cart_widget.dart';
import 'landing_screen.dart';
import 'credit_card.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'checkout_screen.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class MainScreen extends StatefulWidget {

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}
class _MainScreenState extends State<MainScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  double points=100;
  int _countNotify=0;

  double a=0;
  void updatepoints(double newpoints) {
    setState(() {
      points = newpoints;
    });
    print("User1: h = $newpoints");
   // CheckoutScreen(points:points,pointsUpdated:updatepoints);
  }
  void getCount()async{
    try{
      Map<String,dynamic>? userMap;
      await for(var snapshot in _firestore.collection('notifiy').where('owner',isEqualTo: _auth.currentUser?.email).snapshots()){
        setState(() {
          _countNotify=snapshot.docs.length;
        });
      }
    }
    catch(e){
      print(e);
    }
  }
  Future<List<Product>> getHotDrinks() async {
    final hotDrinksSnapshot =
    await _firestore.collection('Hot Drinks').get();
    final hotDrinks = hotDrinksSnapshot.docs.map((doc) {

      final data = doc.data();
      return Product(
        name: data['name'],
        description: data['description'],
        image: data['image'],
        salary: data['salary'],
        id:data['id'],
        calories:data['calories'],
        category:data['category'],
      );
    }).toList();
    return hotDrinks;
  }

  // Fetch sandwiches from Firestore
  Future<List<Product>> getSandwiches() async {
    final sandwichesSnapshot =
    await _firestore.collection('Sandwiches').get();
    final sandwiches = sandwichesSnapshot.docs.map((doc) {
      final data = doc.data();
      return Product(
        name: data['name'],
        description: data['description'],
        image: data['image'],
        salary: data['salary'],
        id:data['id'],
        calories:data['calories'],
        category:data['category'],

      );
    }).toList();
    return sandwiches;
  }

  // Fetch snacks from Firestore
  Future<List<Product>> getSnacks() async {
    final snacksSnapshot = await _firestore.collection('Snacks').get();
    final snacks = snacksSnapshot.docs.map((doc) {
      final data = doc.data();
      return Product(
        name: data['name'],
        description: data['description'],
        image: data['image'],
        salary: data['salary'],
        id:data['id'],
        calories:data['calories'],
        category:data['category'],
      );
    }).toList();
    return snacks;
  }

  @override
  void initState() {
    super.initState();
    getHotDrinks();
    getSnacks();
    getSandwiches();
    getCount();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xFFEFD5BF),

      drawer: Drawer(
        child: ListView(

          children: [
            DrawerHeader(
                padding: EdgeInsets.zero,

                child: Container(
                  color:Color(0xFFD3AE89),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      CircleAvatar(
                        backgroundColor:Color(0xFFEFD5BF),
                        radius: 50,
                        backgroundImage: AssetImage('images/smartcafe.png'),
                      ),
                      Text('Smart Cafe',
                          style: TextStyle(fontSize: 25)),
                    ],
                  ),
                )),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.of(context).pop();
                context.pushNamed(profileRoute);
              },
            ),
            ListTile(
              leading: Icon(Icons.credit_card),
              title: Text('Payment'),
              onTap: () {

                Navigator.push(

                  context,
                  MaterialPageRoute(builder: (context) => CreditCardPaymentPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add Feedback'),
              onTap: () {
                Navigator.of(context).pop();
                context.pushNamed(addFeedbackScreenRoute);
              },
            ),
            ListTile(
              leading: Icon(Icons.feedback),
              title: Text('My Feedbacks'),
              onTap: () {
                Navigator.of(context).pop();
                context.pushNamed(feedbackListScreenRoute);

                },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.star),
              title: Text('Rate App'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About Developer'),
              onTap: () {
                Navigator.of(context).pop();
                context.pushNamed(aboutDeveloperRoute);
              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share App'),
              onTap: () {},
            ),


          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xFFD3AE89),
        title: const Text('Main Screen'),
        actions: [
          const SizedBox(
              width: 50,
              height: 50,
              child: CartWidget()),
          IconButton(onPressed: () {
            _auth.signOut();
            Navigator.pop(context);
          },
              icon: const Icon(Icons.logout)),
          _countNotify==0?IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (builder)=>NotifyScreen()));

          },
              icon: const Icon(Icons.notifications)):Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (builder)=>NotifyScreen()));

              },
                  icon: const Icon(Icons.notifications)),
              CircleAvatar(
                child: Text(
                    _countNotify.toString(),
                ),
                backgroundColor: Colors.red,
                radius: 12,
              )
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            // Hot Coffees
            const Text(
              'Hot Drinks',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: FutureBuilder<List<Product>>(
            future: getHotDrinks(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final hotDrinks = snapshot.data;
                if (hotDrinks == null || hotDrinks.isEmpty) {
                  return Center(child: Text('No hot drinks found.'));
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (var i = 0; i < hotDrinks.length; i++)
                      GestureDetector(
                        onTap: (){
                          log(hotDrinks[i].name);
                          context.pushNamed(addToCartScreenRoute, extra: hotDrinks[i]);
                        },
                        child: Card(
                          color:Color(0xFFF4E9E4),
                          //color: Colors.amber,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      hotDrinks[i].image,
                                      width: 110,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Text(hotDrinks[i].name)
                              ],
                            ),
                          ),
                        ),
                      )
                  ],
                );
              }
            },
          ),
        ),
            const SizedBox(height: 20,),
            // Ice Festivity
            const Text(
              'Sandwiches',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: FutureBuilder<List<Product>>(
                future: getSandwiches(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final Sandwiches = snapshot.data;
                    if (Sandwiches == null || Sandwiches.isEmpty) {
                      return Center(child: Text('No hot drinks found.'));
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (var i = 0; i < Sandwiches.length; i++)
                          GestureDetector(
                            onTap: (){
                              log(Sandwiches[i].name);
                              context.pushNamed(addToCartScreenRoute, extra: Sandwiches[i]);
                            },
                            child: Card(
                              color:Color(0xFFF4E9E4),
                              //color: Colors.amber,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          Sandwiches[i].image,
                                          width: 110,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Text(Sandwiches[i].name)
                                  ],
                                ),
                              ),
                            ),
                          )
                      ],
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 20,),
            //  Festive Colors
            const Text(
              'Snacks',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: FutureBuilder<List<Product>>(
                future: getSnacks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final Snacks = snapshot.data;
                    if (Snacks == null || Snacks.isEmpty) {
                      return Center(child: Text('No hot drinks found.'));
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (var i = 0; i < Snacks.length; i++)
                          GestureDetector(
                            onTap: (){
                              log(Snacks[i].name);
                              context.pushNamed(addToCartScreenRoute, extra: Snacks[i]);
                            },
                            child: Card(
                              color:Color(0xFFF4E9E4),
                              //color: Colors.amber,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          Snacks[i].image,
                                          width: 110,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Text(Snacks[i].name)
                                  ],
                                ),
                              ),
                            ),
                          )
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

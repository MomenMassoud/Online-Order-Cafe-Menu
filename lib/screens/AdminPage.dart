import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:youssef_starbucks/models/product.dart';
import 'package:youssef_starbucks/screens/CategoryPage.dart';
import 'EditProductScreen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final List<Product> _hotDrinksList = [];
  final List<Product> _coldDrinksList = [];
  final List<Product> _snacksList = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final hotDrinks = await _firestore
          .collection('Hot Drinks')
          .get()
          .then((snapshot) => snapshot.docs
          .map((doc) => Product.fromJSON(doc.data()))
          .toList());

      final coldDrinks = await _firestore
          .collection('Sandwiches')
          .get()
          .then((snapshot) => snapshot.docs
          .map((doc) => Product.fromJSON(doc.data()))
          .toList());

      final snacks = await _firestore
          .collection('Snacks')
          .get()
          .then((snapshot) => snapshot.docs
          .map((doc) => Product.fromJSON(doc.data()))
          .toList());

      setState(() {
        _hotDrinksList.clear();
        _coldDrinksList.clear();
        _snacksList.clear();

        _hotDrinksList.addAll(hotDrinks);
        _coldDrinksList.addAll(coldDrinks);
        _snacksList.addAll(snacks);
      });
    } catch (e) {
      // Handle errors
      print('Error loading products: $e');
    }
  }

  Future<void> _deleteProduct(Product product) async {
    try {
      final collection = _firestore.collection(product.category);
      await collection.doc(product.id).delete();

      if (product.image.isNotEmpty) {
        final ref = FirebaseStorage.instance.refFromURL(product.image);
        await ref.delete();
      }

      await _loadProducts();
    } catch (e) {
      // Handle errors
      print('Error deleting product: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        children: [
          SizedBox(height: 16),
          _buildProductList('Hot Drinks', _hotDrinksList),
          _buildProductList('Sandwiches', _coldDrinksList),
          _buildProductList('Snacks', _snacksList),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),

              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 16),
                    Container(
                      child: Text(
                        'All Users',
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.grey.withOpacity(1),
                            shadows: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(1),
                                spreadRadius: 3,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              )
                            ]

                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    StreamBuilder<QuerySnapshot>(
                      stream: _firestore.collection('users').snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }

                        final users = snapshot.data!.docs;

                        if (users.isEmpty) {
                          return Center(
                            child: Text(
                              'No users found',
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: users.length,
                          itemBuilder: (_, index) {
                            final user = users[index];

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(user['profileImage']),
                                  ),
                                  title: Text(
                                    user['name'],
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    user['email'],
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () async {
                                      await _firestore.collection('users').doc(user.id).delete();

                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Add child widget here
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CategoryPage(),
            ),
          );

          if (result == true) {
            await _loadProducts();
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.brown,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildProductList(String title, List<Product> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.brown),
          ),
        ),

        if (products.isEmpty)

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            child: Text(
              'No products found',
              textAlign: TextAlign.center,
            ),
          )

        else
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: products.length,
            itemBuilder: (_, index) {
              final product = products[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: product.image.isNotEmpty
                        ? Image.network(
                      product.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                        : SizedBox(),
                    title: Text(
                      product.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${product.salary.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => EditProductScreen(product: product),
                              ),
                            );
                            _loadProducts();
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteProduct(product),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

      ],
    );
  }

}
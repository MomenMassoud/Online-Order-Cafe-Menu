import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youssef_starbucks/config/constants.dart';

import '../models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


final FirebaseFirestore _firestore = FirebaseFirestore.instance;



class DataStore {
  static List<Product> Hot_Drink = [
    Product(
      salary:10,
      id: '1',
      name: 'Turkish coffee',
      calories: 5,
      description:
      'Turkish coffee is a style of coffee prepared in a cezve using very finely ground coffee beans without filtering. It’s a rich, thick,and delightful drink to be enjoyed slowly with good company.',
      category: 'Hot Drinks',
      image: 'images/HotDrinks/Turkishcoffee.png',
    ),
    Product(
        salary:5,
        id: '2',
        name: 'Tea',
        calories: 7,
        description: 'Tea , beverage produced by steeping in freshly boiled water the young leaves and leaf buds of the tea plant, Camellia sinensis',
        category: 'Hot Drinks',
        image: 'images/HotDrinks/Tea.png'),
    Product(
        salary:12,
        id: '3',
        name: 'Hot Chocolate',
        calories: 10,
        description:
        'Hot chocolate, also known as hot cocoa or drinking chocolate, is a heated drink consisting of shaved or melted chocolate or cocoa powder, heated milk or water, and usually a sweetener',
        category: 'Hot Drinks',
        image: 'images/HotDrinks/HotChocolate.png'),
  ];

  static List<Product> Sandwiches = [
    Product(
        salary:35,
        id: '4',
        name: 'Chicken Shawarma',
        calories: 19,
        description: 'The Shawarma Soury is a delicious Middle Eastern dish that is made of chicken, lamb, or beef that has been roasted on a spit and then shredded and served in a pita or wrap.',
        category: 'Sandwiches',
        image: 'images/Sandwiches/ChickenShawarma.jpg'),
    Product(
        salary:40,
        id: '5',
        name: 'Chicken Pane Wrapped',
        calories: 15,
        description: 'Chicken pane is classic Egyptian recipe of breaded, fried chicken. The flavors are somehow juicier and zestier than what I have tried in the classic American fried chicken counterparts, although both are equally delicious in their own regard. This chicken is softer crunch, with a more flavorful bite.',
        category: 'Sandwiches',
        image: 'images/Sandwiches/ChickenPaneWrapped.jpg'),
    Product(
        salary:25,
        id: '6',
        name: 'French Fries Wrapped',
        calories: 25,
        description: 'French pommes frites Wrapped typically made from deep-fried potatoes that have been cut into various shapes, especially thin strips.',
        category: 'Sandwiches',
        image: 'images/Sandwiches/FrenchFriesWrapped.jpg'),
  ];

  static List<Product> Snacks = [
    Product(
        salary:5,
        id: '7',
        name: 'Indomie',
        calories: 5,
        description: 'Indomie is produced by Indofood, the pioneer of instant noodles in Indonesia and is one of the largest instant noodles manufacturers in the world. Indomie comes in many varieties from the classic soup flavours such as Chicken, Vegetable, and Chicken Curry, to our most popular flavour Indomie Mi Goreng.',
        category: 'Snacks',
        image: 'images/Snacks/Indomie.jpg'),
    Product(
        salary:5,
        id: '8',
        name: 'Chips',
        calories: 9,
        description: 'Potato Chips are high-quality potato chips. These chips are sprinkled with seasoning flavour. These thin slices of deep-fried potatoes are the perfect snack option. They are light, crunchy and crispy.',
        category: 'Snacks',
        image: 'images/Snacks/Chips Title.jpg'),
    Product(
        salary:6,
        id: '9',
        name: 'Ulker Biscuit',
        calories: 10,
        description: 'Ulker biscuits are versatile, flavorful snacks that your customers can enjoy between meals and proudly offer to guests who drop by for tea. These delightfully tasty Turkish tea biscuits are great with a cup of tea or coffee, or just as a snack on their own.',
        category: 'Snacks',
        image: 'images/Snacks/Ulker Biscuit title.jpg'),
  ];

  Future<void> uploaddata() async {
    try {
      await _firestore.collection('Hot Drinks').doc().set(Hot_Drink[0].toMap());
      await _firestore.collection('Hot Drinks').doc().set(Hot_Drink[1].toMap());
      await _firestore.collection('Hot Drinks').doc().set(Hot_Drink[2].toMap());
      await _firestore.collection('Sandwiches').doc().set(Sandwiches[0].toMap());
      await _firestore.collection('Sandwiches').doc().set(Sandwiches[1].toMap());
      await _firestore.collection('Sandwiches').doc().set(Sandwiches[2].toMap());
      await _firestore.collection('Snacks').doc().set(Snacks[0].toMap());
      await _firestore.collection('Snacks').doc().set(Snacks[1].toMap());
      await _firestore.collection('Snacks').doc().set(Snacks[2].toMap());
      print('Data uploaded successfully');
    } catch (e) {
      print(e);
    }
  }



  Future<void> uploadImageAndSaveToProduct() async {
    // Check if the file exists at the specified path
    final file = File('images/Snacks/Ulker Biscuit title.jpg');
    if (!file.existsSync()) {
      print('File does not exist: images/Snacks/Ulker Biscuit title.jpg');
      return;
    }

    // Get a reference to the Firebase Storage instance
    final storage = FirebaseStorage.instance;

    // Create a reference to the folder in Firebase Storage where you want to upload the file
    final folderName = 'Snacks';
    final fileName = 'Ulker Biscuit title.jpg';
    final storageRef = storage.ref().child('images/$fileName');

    // Upload the file to Firebase Storage
    final task = storageRef.putFile(file);

    // Wait for the upload to complete and get the download URL
    final snapshot = await task.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();

    // Save the download URL to a `product` document in Firestore
    final productDocRef = FirebaseFirestore.instance.collection('products').doc();
    await productDocRef.set({'image_url': downloadUrl}).then((_) {
      print('Image upload and Firestore write successful');
    }).catchError((error) {
      print('Error writing to Firestore: $error');
    });

    // Check if the upload was successful
    if (task.snapshot.state == TaskState.success) {
      print('Image upload successful');
    } else {
      print('Image upload failed');
    }
  }
  void uploadDataOnButtonPress() {
    //uploaddata();
    uploadImageAndSaveToProduct();
  }
}

class DataUploadScreen extends StatelessWidget {
  const DataUploadScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Upload data to Firestore',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text(
                'Upload',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                DataStore().uploadDataOnButtonPress();
              },
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:youssef_starbucks/models/product.dart';
import 'package:youssef_starbucks/screens/CategoryPage.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({required this.product});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // Declare a TextEditingController to handle the salary input
  final TextEditingController _salaryController =
  TextEditingController();

  // Initialize the salary input with the current salary of the product
  @override
  void initState() {
    super.initState();
    _salaryController.text = widget.product.salary.toStringAsFixed(2);
  }

  @override
  void dispose() {
    // Dispose of the TextEditingController to avoid memory leaks
    _salaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.product.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _salaryController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Salary',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Update the salary of the product in Firebase
                try {
                  final collection =
                  _firestore.collection(widget.product.category);
                  await collection.doc(widget.product.id).update({
                    'salary': double.parse(_salaryController.text),
                  });
                  Navigator.of(context).pop(true);
                } catch (e) {
                  // Handle errors
                  print('Error updating product: $e');
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
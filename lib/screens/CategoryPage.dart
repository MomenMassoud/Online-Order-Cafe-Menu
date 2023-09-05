import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:youssef_starbucks/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final _formKey = GlobalKey<FormState>();
  String _category = 'Hot Drinks';
  String _name = '';
  int _calories = 0;
  String _description = '';
  File? _image;
  double _salary = 0;
  final picker = ImagePicker();

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _onImageButtonPressed() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Select Image From"),
            actions: <Widget>[
              TextButton(
                  child: Text("Gallery"),
                  onPressed: () {
                    _getImage(ImageSource.gallery);
                    Navigator.pop(context);
                  }),
              TextButton(
                  child: Text("Camera"),
                  onPressed: () {
                    _getImage(ImageSource.camera);
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Category',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _category,
                  onChanged: (value) {
                    setState(() {
                      _category = value!;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'Hot Drinks',
                      child: Text('Hot Drinks'),
                    ),
                    DropdownMenuItem(
                      value: 'Sandwiches',
                      child: Text('Sandwiches'),
                    ),
                    DropdownMenuItem(
                      value: 'Snacks',
                      child: Text('Snacks'),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Name',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                ),
                SizedBox(height: 16),
                Text(
                  'Calories',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter calories';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _calories = int.tryParse(value) ?? 0;
                    });
                  },
                ),
                SizedBox(height: 16),
                Text(
                  'Description',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      _description = value;
                    });
                  },
                ),
                SizedBox(height: 16),
                Text(
                  'Image',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Center(
                  child: _image == null
                      ? Text('No image selected.')
                      : Image.file(
                    _image!,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    _onImageButtonPressed();
                  },
                  child: Text('Choose Image'),
                ),
                SizedBox(height: 16),
                Text(
                  'Salary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a salary';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _salary = double.tryParse(value) ?? 0;
                    });
                  },
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final id = FirebaseFirestore.instance
                          .collection(_category)
                          .doc()
                          .id;
                      final product = Product(
                        id: id,
                        name: _name,
                        calories: _calories,
                        description: _description,
                        category: _category,
                        image: '',
                        salary: _salary,
                      );
                      await FirebaseFirestore.instance
                          .collection(_category)
                          .doc(id)
                          .set(product.toMap());

                      if (_image != null) {
                        final ref = FirebaseStorage.instance
                            .ref()
                            .child('product_images/$id.jpg');
                        await ref.putFile(_image!);
                        final url = await ref.getDownloadURL();
                        await FirebaseFirestore.instance
                            .collection(_category)
                            .doc(id)
                            .update({'image': url});
                      }

                      Navigator.of(context).pop(true);
                    }
                  },
                  child: Text('Add Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
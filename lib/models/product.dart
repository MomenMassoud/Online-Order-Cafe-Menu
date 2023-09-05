import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Product {
  final String id;
  final String name;
  final int calories;
  final String description;
  final String category;
  late final String image;
  late final double salary;
  TextEditingController salaryController;
  Product({
    required this.id,
    required this.name,
    required this.calories,
    required this.description,
    required this.category,
    required this.image,
    required this.salary,
  }):salaryController = TextEditingController(text: salary.toString());


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'description': description,
      'category': category,
      'image': image,
      'salary':salary,
    };
  }

  factory Product.fromJSON(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      calories: map['calories'],
      description: map['description'],
      category: map['category'],
      image: map['image'],
       salary:map['salary'],
    );
  }

}

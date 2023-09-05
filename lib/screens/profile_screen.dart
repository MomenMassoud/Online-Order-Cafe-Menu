import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('users').doc(_currentUser.uid).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>?;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16.0),
                CircleAvatar(
                  radius: 75.0,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: data!['profileImage'] != null
                      ? CachedNetworkImageProvider(data['profileImage'])
                      : null,
                  child: data['profileImage'] == null
                      ? Icon(Icons.person, size: 75.0, color: Colors.grey[600])
                      : null,
                ),
                SizedBox(height: 32.0),
                Text(
                  data['name'] ?? '',
                  style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),
                Text(
                  data['email'] ?? '',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(height: 16.0),
                Divider(height: 32.0, thickness: 1.0),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Gender',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Text(
                      data['gender'] ?? '',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Divider(height: 32.0, thickness: 1.0),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Date of Birth',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Text(
                      data['dob'] ?? '',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Divider(height: 32.0, thickness: 1.0),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Phone Number',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Text(
                      data['PhoneNumber'] ?? '',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}
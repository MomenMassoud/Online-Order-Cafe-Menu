import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youssef_starbucks/screens/add_feedback_screen.dart';

class ListFeedback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    if (uid == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Please sign in to view your feedbacks',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Feedbacks',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFD3AE89),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(kFeedbacksCollectionName)
            .where('userId', isEqualTo: uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading feedbacks: ${snapshot.error}',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: Color(0xFFD3AE89),
              ),
            );
          }

          final feedbackDocs = snapshot.data!.docs;

          if (feedbackDocs.isEmpty) {
            return Center(
              child: Text(
                'You have not submitted any feedbacks yet',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: feedbackDocs.length,
            itemBuilder: (context, index) {
              final feedbackDoc = feedbackDocs[index];
              final feedback = feedbackDoc.get('feedback');

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    feedback,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => FeedbackForm(),
            ),
          );
        },
        backgroundColor: Color(0xFFD3AE89),
        child: Icon(Icons.add),
      ),
    );
  }
}
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/feedback_model.dart';

class FeedbackProvider extends ChangeNotifier {
  bool _addingFeedback = false;
  bool _loadingFeedbacks = false;
  List<FeedbackModel> _feedbacks = [];

  bool get addingFeedback => _addingFeedback;

  bool get loadingFeedbacks => _loadingFeedbacks;

  List<FeedbackModel> get feedbacks => _feedbacks;

  late final FirebaseAuth _firebaseAuth;
  late final FirebaseFirestore _firebaseFirestore;

  FeedbackProvider(FirebaseAuth fa, FirebaseFirestore ff){
   _firebaseAuth = fa;
   _firebaseFirestore = ff;

   getAllFeedbacks();
  }

  Future<void> addFeedback(FeedbackModel feedbackModel) async {
    _addingFeedback = true;
    notifyListeners();

    String uid = _firebaseAuth.currentUser!.uid;

    var feedbackRef = _firebaseFirestore.collection('feedbacks').doc(uid).collection('feedbacks').doc();


    await feedbackRef.set({
      'feedbackId': feedbackRef.id,
      'title': feedbackModel.title,
      'feedback': feedbackModel.feedback,
      'dt': DateTime.now().millisecondsSinceEpoch
    });

    _addingFeedback = false;
    notifyListeners();
  }

  Future<void> getAllFeedbacks() async {
    _loadingFeedbacks = true;
    notifyListeners();
    String uid = _firebaseAuth.currentUser!.uid;
    final snapshots = await _firebaseFirestore.collection('feedbacks').doc(uid).collection('feedbacks').get();

    for( var snapshot in snapshots.docs){
      FeedbackModel feedbackModel = FeedbackModel.fromJSON(snapshot.data());
      _feedbacks.add(feedbackModel);
    }
    log(snapshots.toString());
    _loadingFeedbacks = false;

    notifyListeners();
  }
}

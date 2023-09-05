import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
class QRCodeUploader {
  final CollectionReference qrcodeCollection =
  FirebaseFirestore.instance.collection('qrcode');

  Future<void> uploadQRCode(String qrId, String imagePath) async {
    try {
      // Upload the QR code image to Firebase Storage (replace 'storagePath' with your desired path in Firebase Storage)
      String storagePath = 'qrcodes/$qrId.png';
      // Add your code here to upload the image to Firebase Storage using 'storagePath' and 'imagePath'

      // Create a new document in the 'qrcode' collection with the QR code ID
      await qrcodeCollection.doc(qrId).set({
        'id': qrId,
        'imagePath': storagePath,
      });

      // Send a push notification to all subscribed devices
      await sendPushNotification(qrId);
    } catch (e) {
      print('Error uploading QR code: $e');
    }
  }

  void printScannedQRCodeId(String qrId) {
    print('Scanned QR code ID: $qrId');
  }

  Future<void> sendPushNotification(String qrId) async {
    try {
      // Retrieve the FCM server token from Firebase console
      String serverToken = 'AAAA4ipbCds:APA91bEF8X-sos3PJ3QFr-qMEso_cy6xUhambPAlArDZ6yuohfaoHjL_GzX3iw8IbfuKxrOj90dZ7aFiUqpKUDcC9HN3I3B6DyirFDHCUq8ofsvOiOxQiRZd50cKKyiFRP-VH8YKrbhz';

      // Configure the notification message
      var message = {
        'notification': {
          'title': 'New QR Code Scanned',
          'body': 'QR Code ID: $qrId',
        },
        'topic': 'qr_code_scanned',
      };

      // Send the notification using FCM
      await FirebaseMessaging.instance.sendMessage(messageType: 'qr_code_scanned');
    } catch (e) {
      print('Error sending push notification: $e');
    }
  }
}
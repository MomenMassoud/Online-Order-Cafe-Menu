import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/QRCodeUploader.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeScreen extends StatelessWidget {
  final QRCodeUploader qrCodeUploader = QRCodeUploader();

  Future<void> _uploadQRCode() async {
    // Use the image_picker package to pick an image from gallery or capture from camera
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      String qrId = generateQRId(); // Replace this with your own logic to generate a unique QR code ID
      String imagePath = pickedImage.path;

      await qrCodeUploader.uploadQRCode(qrId, imagePath);
      print('QR code uploaded successfully!');
    }
  }

  void _onQRCodeScanned(String qrId) {
    qrCodeUploader.printScannedQRCodeId(qrId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _uploadQRCode,
              child: Text('Upload QR Code'),
            ),
            TextButton(
              onPressed: () {
                String scannedQRId = '123'; // Replace this with the actual scanned QR code ID
                _onQRCodeScanned(scannedQRId);
              },
              child: Text('Simulate QR Code Scan'),
            ),
          ],
        ),
      ),
    );
  }
}

String generateQRId() {
  const characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
  Random random = Random();
  String qrId = '';

  for (int i = 0; i < 8; i++) {
    qrId += characters[random.nextInt(characters.length)];
  }

  return qrId;
}
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class CreditCardPaymentPage extends StatefulWidget {
  @override
  _CreditCardPaymentPageState createState() => _CreditCardPaymentPageState();
}

class _CreditCardPaymentPageState extends State<CreditCardPaymentPage> {
  String _cardType = 'Visa';
  String _cardNumber = '';
  int? _expiryMonth;
  int? _expiryYear;
  String _cvv = '';

  final _formKey = GlobalKey<FormState>();

  String? expiryDateValidator(int? year, int? month) {
    if (year == null || month == null) {
      return 'Please select expiry date';
    }
    final now = DateTime.now();
    final expiry = DateTime(year, month);
    if (expiry.isBefore(now)) {
      return 'Please select a valid expiry date';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credit Card Payment'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Card Type:',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Radio(
                      value: 'Visa',
                      groupValue: _cardType,
                      onChanged: (value) {
                        setState(() {
                          _cardType = value!;
                        });
                      },
                    ),
                    Image.asset('images/visa.png', width: 50),
                    SizedBox(width: 16.0),
                    Radio(
                      value: 'MasterCard',
                      groupValue: _cardType,
                      onChanged: (value) {
                        setState(() {
                          _cardType = value!;
                        });
                      },
                    ),
                    Image.asset('images/mastercard.png', width: 50),
                  ],
                ),
                SizedBox(height: 24.0),
                Text(
                  'Card Number',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length != 16) {
                      return 'Please enter a valid 16-digit card number';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _cardNumber = value;
                  },
                  maxLength: 16,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your 16-digit card number',
                  ),
                ),
                SizedBox(height: 24.0),
                Text(
                  'Expiry Date',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Flexible(
                      child: DropdownButtonFormField<int>(
                        validator: (value) => expiryDateValidator(value, _expiryMonth),
                        onChanged: (value) {
                          setState(() {
                            _expiryYear = value;
                          });
                        },
                        value: _expiryYear,
                        items: List.generate(
                          10,
                              (index) => DropdownMenuItem<int>(
                            value: DateTime.now().year + index,
                            child: Text('${DateTime.now().year + index}'),
                          ),
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Year',
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Flexible(
                      child: DropdownButtonFormField<int>(
                        validator: (value) => expiryDateValidator(_expiryYear, value),
                        onChanged: (value) {
                          setState(() {
                            _expiryMonth = value;
                          });
                        },
                        value: _expiryMonth,
                        items: List.generate(
                          12,
                              (index) => DropdownMenuItem<int>(
                            value: index + 1,
                            child: Text('${index + 1}'),
                          ),
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Month',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.0),
                Text(
                  'CVV',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length != 3) {
                      return 'Please enter a valid 3-digit CVV';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _cvv = value;
                  },
                  maxLength: 3,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your 3-digit CVV',
                  ),
                ),
                SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final expiryDate = DateTime(_expiryYear!, _expiryMonth!);
                      final formattedExpiryDate = DateFormat('MM/yyyy').format(expiryDate);
                      print('Card Type: $_cardType');
                      print('Card Number: $_cardNumber');
                      print('Expiry Date: $formattedExpiryDate');
                      print('CVV: $_cvv');
                      Fluttertoast.showToast(msg: 'Payment successful!');

                    }
                  },
                  child: Text('Make Payment'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
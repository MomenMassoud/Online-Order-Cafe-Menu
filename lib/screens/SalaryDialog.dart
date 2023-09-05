import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class SalaryDialog extends StatefulWidget {
  final double initialValue;

  const SalaryDialog({required this.initialValue});

  @override
  _SalaryDialogState createState() => _SalaryDialogState();
}

class _SalaryDialogState extends State<SalaryDialog> {
  late double _salary;

  @override
  void initState() {
    super.initState();
    _salary = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Salary'),
      content: TextFormField(
        initialValue: _salary.toString(),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: 'Salary',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          setState(() {
            _salary = double.tryParse(value) ?? _salary;
          });
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_salary),
          child: Text('Save'),
        ),
      ],
    );
  }
}
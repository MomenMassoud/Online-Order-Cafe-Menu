import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:youssef_starbucks/providers/authentication_provider.dart';
import 'package:youssef_starbucks/widgets/background_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

enum Gender { male, female }

class _SignUpScreenState extends State<SignUpScreen> {
  DateTime? _selectedDate;

  String strDate = 'Not Selected';
  String strAge = 'Not Calculated';
  final _formKey = GlobalKey<FormState>();
  Gender gender = Gender.male;
  File? imageFile;
  bool showPickedFile = false;
  String? selectedBranch;
  late String? name, email, password,PhoneNumber;
  late double?points=100;


  _pickImageFrom(ImageSource imageSource) async {
    XFile? xFile = await ImagePicker().pickImage(source: imageSource);
    if (xFile == null) return;
    final tempImage = File(xFile.path);
    imageFile = tempImage;
    showPickedFile = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final authenticationProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);

    return Scaffold(
      backgroundColor:Color(0xFFEFD5BF),
      appBar: AppBar(
        backgroundColor:Color(0xFFD3AE89),
        title: const Text('Sign Up'),
      ),
      body:Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Center(
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 75,
                          backgroundImage: showPickedFile
                              ? FileImage(imageFile!)
                              : const AssetImage('images/user.jpeg')
                                  as ImageProvider,
                        ),
                        Positioned(
                            right: 0,
                            bottom: 0,
                            child: IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                  leading: const Icon(
                                                      Icons.camera_alt),
                                                  title:
                                                      const Text('From Camera'),
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                    _pickImageFrom(
                                                        ImageSource.camera);
                                                  }),
                                              ListTile(
                                                  leading: const Icon(
                                                      Icons.photo),
                                                  title: const Text(
                                                      'From Gallery'),
                                                  onTap: () {
                                                    Navigator.of(context).pop();

                                                    _pickImageFrom(
                                                        ImageSource.gallery);
                                                  }),
                                            ],
                                          ),
                                        );
                                      });
                                },
                                icon: const Icon(Icons.camera_alt))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Full name',
                    prefixIcon: const Icon(Icons.person), // Set the icon color to white
                    filled: true, // Fill the background with color
                    fillColor: Colors.white, // Set the background color to white
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide Full name';
                    }
                    name = value;
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      filled: true, // Fill the background with color
                      fillColor: Colors.white,
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide email';
                    }

                    bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value);

                    if (!emailValid) {
                      return 'Invalid Email address';
                    }

                    email = value;
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                      filled: true, // Fill the background with color
                      fillColor: Colors.white,
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide password';
                    }

                    if (value.length < 6) {
                      return 'Password too short';
                    }

                    password = value;
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  obscureText: true,
                  maxLength: 11,
                  decoration: InputDecoration(
                      filled: true, // Fill the background with color
                      fillColor: Colors.white,
                      labelText: 'Phone Number',
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide Phone Number';
                    }

                    if (value.length !=11) {
                      return 'Enter Full Number';
                    }

                    PhoneNumber = value;
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Row(
                      children: [
                        Radio(
                            value: Gender.male,
                            groupValue: gender,
                            onChanged: (Gender? g) {
                              setState(() {
                                gender = g!;
                              });
                            }),
                        const Text('Male'),
                      ],
                    ),
                    const SizedBox(width: 50),
                    Row(
                      children: [
                        Radio(
                            value: Gender.female,
                            groupValue: gender,
                            onChanged: (Gender? g) {
                              setState(() {
                                gender = g!;
                              });
                            }),
                        const Text('Female'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height:10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Select a Branch: '),
                DropdownButton<String>(
                  value: selectedBranch,
                  onChanged: (value) {
                    setState(() {
                      selectedBranch = value;
                      if (selectedBranch != 'Abo Quir' && selectedBranch != null) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Message'),
                            content: const Text('Branch not available'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    });
                  },
                  items: <String>['Abo Quir', 'El Alamein','Smart Village','Miami']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
                const SizedBox(height:10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(strDate),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFD3AE89),
                      ),
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  //which date will display when user open the picker
                                  firstDate: DateTime(1950),
                                  //what will be the previous supported year in picker
                                  lastDate: DateTime
                                      .now()) //what will be the up to supported date in picker
                              .then((pickedDate) {
                            //then usually do the future job
                            if (pickedDate == null) {
                              //if user tap cancel then this function will stop
                              return;
                            }
                            setState(() {
                              //for rebuilding the ui
                              _selectedDate = pickedDate;
                              strDate = _selectedDate.toString().split(' ')[0];
                            });
                          });
                        },
                        child: const Text('DOB')),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(strAge),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFD3AE89),
                        ),
                        onPressed: () {
                          if (_selectedDate != null) {
                            DateTime today = DateTime.now();
                            int age = today.year - _selectedDate!.year;

                            int month1 = today.month;
                            int month2 = _selectedDate!.month;
                            if (month2 > month1) {
                              age--;
                            } else if (month1 == month2) {
                              int day1 = today.day;
                              int day2 = _selectedDate!.day;
                              if (day2 > day1) {
                                age--;
                              }
                            }

                            setState(() {
                              strAge = '$age years';
                            });
                          }
                        },
                        child: const Text('Age')),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Consumer<AuthenticationProvider>(
                    builder: (context, authProvider, child) {
                  if (authProvider.authenticating) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF7C3924),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            //_showDialogMessage(context, 'Valid');

                            if (_selectedDate == null) {
                              _showDialogMessage(context, 'Please select DOB');
                              return;
                            }

                            if (!showPickedFile) {
                              _showDialogMessage(
                                  context, 'Please select profile image');
                              return;
                            }

                            String g =
                                gender == Gender.male ? 'Male' : 'Female';
                            bool success = await authenticationProvider.signUp(
                                email: email!,
                                password: password!,
                                name: name!,
                                gender: g,
                                phoneNumber:PhoneNumber!,
                                dob: _selectedDate.toString().split(' ')[0],
                                image: imageFile!);

                            if (success) {
                              Fluttertoast.showToast(msg: 'Account created');
                              await authProvider.signOut();
                              if(!mounted) return;
                              Navigator.of(context).pop();
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'Something went wrong');
                            }
                          } else {
                            _showDialogMessage(
                                context, 'Please fill all field');
                          }
                        },
                        child: const Text('Register'));
                  }
                }
                )
              ],
            ),
          ),
        ),

    );
  }

  _showDialogMessage(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Alert'),
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'))
            ],
          );
        });
  }
  void showMessage(){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Alert'),
            content: Text('Sorry, the selected branch is not available now.'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'))
            ],
          );
        });
  }
}

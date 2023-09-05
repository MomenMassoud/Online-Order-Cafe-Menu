import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:youssef_starbucks/config/data_store.dart';
import 'forget_pw_page.dart';
import 'credit_card.dart';
import '../config/constants.dart';
import '../providers/authentication_provider.dart';
import '../widgets/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Employee.dart';
import 'CategoryPage.dart';
import 'AdminPage.dart';
import 'qr_code.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  late String email, password;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    final authP =
        Provider.of<AuthenticationProvider>(context, listen: false);

    return Scaffold(
      backgroundColor:Color(0xFFEFD5BF),
      appBar: AppBar(
        backgroundColor: Color(0xFFD3AE89),
        title: const Text('Login'),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  const CircleAvatar(
                    backgroundColor:Color(0xFFF2E1D6),
                    radius: 80,
                    backgroundImage: AssetImage(
                      'images/smartcafe.png',
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: emailController,
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
                    controller: passwordController,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                   child:Row(
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: [
                       GestureDetector(
                         onTap: (){
                           Navigator.push(
                               context,
                             MaterialPageRoute(
                               builder: (context){
                                 return ForgotPasswordScreen();
                               },
                             ),
                            );
                         },
                         child: Text(
                           'Forget password',
                           style: TextStyle(
                               color: Colors.blue,
                               fontWeight: FontWeight.bold
                           ),

                         ),
                       ),
                     ],
                   ),

                    ),

                   SizedBox(height: 10),
                  Consumer<AuthenticationProvider>(
                    builder: (context, authProvider, child) {
                      if (authProvider.authenticating) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return SizedBox(
                          width: 150,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(

                                    primary: Color(0xFF7C3924),

                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  bool success = await authProvider.signIn(
                                      email: email, password: password);
                                  if (success) {
                                    if (!mounted) return;
                                    Fluttertoast.showToast(msg: 'Success');
                                    context.pushNamed(mainScreenRoute);
                                  }
                                } else{
                                  String username = emailController.text;
                                  String password = passwordController.text;
                                  if (username == "emp" && password == "emp") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => emp()),
                                    );
                                  }
                                 else if (username == "admin" && password == "admin") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => AdminPage()),
                                    );
                                  }
                                  else{
                                    _showDialogMessage(
                                        context, 'Please fill all field');
                                  }
                                }
                              },
                              child: const Text('Login')),
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
    );
  }
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

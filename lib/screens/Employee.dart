import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youssef_starbucks/models/submit_model.dart';
import 'package:youssef_starbucks/providers/order_provider.dart';

class emp extends StatefulWidget {
  double newpoint = 0;
  late int count = 1;

  @override
  _emp createState() => _emp();
}

class _emp extends State<emp> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController textEditingController = TextEditingController();

  late double value;

  @override
  void initState() {
    super.initState();
    value = widget.newpoint;
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('submit').snapshots(),
        builder: (context, snapshot) {
          List<SubmitModel> arrModel = [];
          if (!snapshot.hasData) {
            return Center(
              child: Text("No Data"),
            );
          }
          final MYstorysStream = snapshot.data?.docs;
          for (var mystory in MYstorysStream!) {
            String Name = mystory.get('name');
            String Ordername = mystory.get('order_name');
            String cost = mystory.get('cost');
            String email = mystory.get('email');
            String id = mystory.id;
            arrModel.add(SubmitModel(email, id, Name, Ordername, cost, ""));
          }
          return ListView.builder(
            itemCount: arrModel.length,

            itemBuilder: (context, index) {
              return index == 0
                  ? Column(

                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(height: 25),
                  Text(
                    arrModel[index].name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    child: ListTile(
                      title: Text(
                        arrModel[index].ordername,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        'Cost: ${arrModel[index].cost}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              _firestore
                                  .collection("submit")
                                  .doc(arrModel[index].id)
                                  .delete()
                                  .then(
                                    (doc) => print("Document deleted"),
                                onError: (e) =>
                                    print("Error updating document $e"),
                              );
                              await _firestore
                                  .collection('notifiy')
                                  .doc()
                                  .set({
                                'ordername': arrModel[index].ordername,
                                'owner': arrModel[index].email,
                                'msg':
                                "Your Order ${arrModel[index].ordername} is ready for pickup!"
                              });
                            },
                            child: Text("Ready"),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () async {
                              _firestore
                                  .collection("submit")
                                  .doc(arrModel[index].id)
                                  .delete()
                                  .then(
                                    (doc) => print("Document deleted"),
                                onError: (e) =>
                                    print("Error updating document $e"),
                              );
                              await _firestore
                                  .collection('notifiy')
                                  .doc()
                                  .set({
                                'ordername': arrModel[index].ordername,
                                'owner': arrModel[index].email,
                                'msg':
                                "Your Order ${arrModel[index].ordername} Rejected!"
                              });
                            },
                            child: Text("Reject"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
                  : arrModel[index].name != arrModel[index - 1].name
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 25),
                  Text(
                    arrModel[index].name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    child: ListTile(
                      title: Text(
                        arrModel[index].ordername,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        'Cost: ${arrModel[index].cost}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              _firestore
                                  .collection("submit")
                                  .doc(arrModel[index].id)
                                  .delete()
                                  .then(
                                    (doc) =>
                                    print("Document deleted"),
                                onError: (e) => print(
                                    "Error updating document $e"),
                              );
                              await _firestore
                                  .collection('notifiy')
                                  .doc()
                                  .set({
                                'ordername':
                                arrModel[index].ordername,
                                'owner': arrModel[index].email,
                                'msg':
                                "Your Order ${arrModel[index].ordername} is ready for pickup!"
                              });
                            },
                            child: Text("Ready"),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () async {
                              _firestore
                                  .collection("submit")
                                  .doc(arrModel[index].id)
                                  .delete()
                                  .then(
                                    (doc) =>
                                    print("Document deleted"),
                                onError: (e) => print(
                                    "Error updating document $e"),
                              );
                              await _firestore
                                  .collection('notifiy')
                                  .doc()
                                  .set({
                                'ordername':
                                arrModel[index].ordername,
                                'owner': arrModel[index].email,
                                'msg':
                                "Your Order ${arrModel[index].ordername} Rejected!"
                              });
                            },
                            child: Text("Reject"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
                  : Card(
                child: ListTile(
                  title: Text(
                    arrModel[index].ordername,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Text(
                    'Cost: ${arrModel[index].cost}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          _firestore
                              .collection("submit")
                              .doc(arrModel[index].id)
                              .delete()
                              .then(
                                (doc) => print("Document deleted"),
                            onError: (e) =>
                                print("Error updating document $e"),
                          );
                          await _firestore
                              .collection('notifiy')
                              .doc()
                              .set({
                            'ordername': arrModel[index].ordername,
                            'owner': arrModel[index].email,
                            'msg':
                            "Your Order ${arrModel[index].ordername} is ready for pickup!"
                          });
                        },
                        child: Text("Ready"),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          _firestore
                              .collection("submit")
                              .doc(arrModel[index].id)
                              .delete()
                              .then(
                                (doc) => print("Document deleted"),
                            onError: (e) =>
                                print("Error updating document $e"),
                          );
                          await _firestore
                              .collection('notifiy')
                              .doc()
                              .set({
                            'ordername': arrModel[index].ordername,
                            'owner': arrModel[index].email,
                            'msg':
                            "Your Order ${arrModel[index].ordername} Rejected!"
                          });
                        },
                        child: Text("Reject"),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
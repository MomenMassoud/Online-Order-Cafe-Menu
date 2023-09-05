import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youssef_starbucks/models/notifiyModel.dart';

class NotifyScreen extends StatefulWidget{
  _NotifyScreen createState()=>_NotifyScreen();
}
class _NotifyScreen extends State<NotifyScreen>{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Color(0xFF4E2612),
        title: Text("Notification Screen"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('notifiy').where('owner',isEqualTo: _auth.currentUser?.email).snapshots(),
        builder: (context,snapshot){
          List<NotifiyModel> arrModel=[];
          if(!snapshot.hasData){
            return Center(
              child: Text("No Data"),
            );
          }
          final MYstorysStream = snapshot.data?.docs;
          for(var mystory in MYstorysStream!){
            String id = mystory.id;
            String owner = mystory.get('owner');
            String msg = mystory.get('msg');
            String ordername = mystory.get('ordername');
            arrModel.add(NotifiyModel(owner, ordername, id, msg));
          }
          return ListView.builder(
            itemCount: arrModel.length,
              itemBuilder: (context,index){
            return ListTile(
              title: Text(arrModel[index].ordername),
              subtitle: Text(arrModel[index].msg),
              trailing: IconButton(
                onPressed: ()async{
                  _firestore.collection("notifiy").doc(arrModel[index].id).delete().then(
                        (doc) => print("Document deleted"),
                    onError: (e) => print("Error updating document $e"),
                  );
                },
                icon: Icon(Icons.delete),
              ),
            );
          }
          );
        }
      ),
    );
  }

}
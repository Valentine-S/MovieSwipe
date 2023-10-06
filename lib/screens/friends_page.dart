// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:movie_swipe/screens/log_in_page.dart';
import 'package:movie_swipe/screens/matched_page.dart';
import 'package:movie_swipe/services/friend.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  //State<FriendsPage> createState() => _FriendsPageState();
  _FriendsPageState createState() => _FriendsPageState();
}

/*
void startDBUpdates() {
  var currentUser = FirebaseAuth.instance.currentUser!;
  final docRef = FirebaseFirestore.instance
      .collection('users')
      .doc("vL916qiuCwVESMJRtg5REeD9Zhb2");

  docRef.snapshots().listen(
        (event) => print("current data: ${event.data()}"),
        onError: (error) => print("Listen failed: $error"),
      );
}


*/

class _FriendsPageState extends State<FriendsPage> {
  var currentUser = FirebaseAuth.instance.currentUser!;

  Map<String, dynamic>? userData;
  final docRef = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid.toString());

  Future getSnapshots() async {
    docRef.snapshots().listen(
      (event) {
        print("current data: ${event.data()}");
        //userData = event.data();
        userData = event.data()! as Map<String, dynamic>;
        print(userData!['friends']);
      },
      onError: (error) => print("Listen failed: $error"),
    );
  }

  final _friendController = TextEditingController();

  final Stream<QuerySnapshot> _friendsStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  @override
  void dispose() {
    _friendController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    //getSnapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _friendController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Search By Email",
            ),
          ),
          GestureDetector(
            onTap: () {
              addFriend(_friendController.text.trim());
            },
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Add Friend',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          /*StreamBuilder<QuerySnapshot>(
            stream: _friendsStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text("Something is wrong");
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }

              //if (snapshot.hasData) {
              //  return Text("Document is empty");
              //}

              return ListView(
                children: snapshot.data!.docs
                    .map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return ListTile(
                        title: Text(userData!['friends'].toString()),
                      );
                    })
                    .toList()
                    .cast(),
              );
            },
          )*/
          Expanded(
              child: FutureBuilder(
            future: getSnapshots(),
            builder: (context, snapshot) {
              return ListView.builder(
                itemCount: userData!['friends'].length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MatchedPage(
                                friendEmail: userData!['friends'][index])),
                      );
                    },
                    child: ListTile(
                      title: Text(userData!['friends'][index]),
                    ),
                  );
                },
              );
            },
          )),
        ],
      ),
    );
  }
}

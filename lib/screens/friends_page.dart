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

class _FriendsPageState extends State<FriendsPage> {
  var currentUser = FirebaseAuth.instance.currentUser!;
  bool isLoading = true;
  Map<String, dynamic>? userData;
  int? userDataLength;
  Future<List<dynamic>>? friends;

  final docRef = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid.toString());

  /*
  Future getSnapshots() async {
    docRef.snapshots().listen(
      (event) {
        print("current data: ${event.data()}");
        //userData = event.data();
        userData = event.data() as Map<String, dynamic>;
        userDataLength = userData!['friends'].length ?? 0;
        print(userData!['friends']);
      },
      onError: (error) => print("Listen failed: $error"),
    );
    setState(() {
      isLoading = false;
    });
  }
  */

  Future getFriends() async {
    DocumentSnapshot userDoc = await docRef.get();
    userData = userDoc.data() as Map<String, dynamic>;
    //friends = userData!['friends'];

    print("These are the friends: $friends");
    //setState(() {
    //  isLoading = false;
    //});
    //Return the value at the end of the method hopefully as a future
    return userDoc;
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
    //getFriends();
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
                  'Add Friend2',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
              child: FutureBuilder(
            future: getFriends(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print("This is the snapshot: ");
                print(snapshot.data);
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
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          )),
        ],
      ),
    );
  }
}

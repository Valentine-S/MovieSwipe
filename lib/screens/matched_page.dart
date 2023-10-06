// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_swipe/models/movie.dart';
import 'package:movie_swipe/widgets/movie_card.dart';

import '../models/movie.api.dart';
import '../widgets/movie_card copy.dart';

class MatchedPage extends StatefulWidget {
  final String friendEmail;
  const MatchedPage({Key? key, required this.friendEmail}) : super(key: key);

  @override
  State<MatchedPage> createState() => _MatchedPage();
}

class _MatchedPage extends State<MatchedPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  bool isLoading = true;
  String userID = FirebaseAuth.instance.currentUser!.uid;
  Map<String, dynamic>? friendData;
  Map<String, dynamic>? userData;
  List<String> friendLiked = [];
  List<String> userLiked = [];
  List<String> matchedLikes = [];
  Future<List<Movie>>? matchedMovies;

  @override
  void initState() {
    super.initState();
    //getMatches();
    //getFriendsID();
    //getUsersLiked();
    getInfoandMatch();
    //getMatchedMoviesInfo();
  }

  Future<void> getInfoandMatch() async {
    await getInfo();
    await getMatchedMoviesInfo();
  }

  Future getFriendsID() async {
    String ID = "";
    print("This is the friendEmail " + widget.friendEmail);
    await db
        .collection('users')
        .where('email', isEqualTo: widget.friendEmail)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              print("This is the friend's ID: " + document.reference.id);
              ID = document.reference.id;
            },
          ),
        );
    //getFriendsLiked();
    return ID;
  }

  // //Make each of these futures return the value they want
  // Future getFriendsLiked() async {
  //   print("getFriendsLiked");
  //   await getFriendsID();

  //   final docRef = FirebaseFirestore.instance.collection('users').doc(friendID);
  //   await docRef.snapshots().listen((event) {
  //     //print("Friends Data: ${event.data()}");
  //     friendData = event.data()! as Map<String, dynamic>;
  //     List friendLiked = friendData!['liked'];
  //     print('FriendLiked :  $friendLiked');
  //     //getMatches();
  //   });
  // }

  // Future getUsersLiked() async {
  //   //print("getusersLiked called");
  //   //await getFriendsLiked();
  //   //print('getFriendSLiked finished');

  //   final docRef = FirebaseFirestore.instance.collection('users').doc(userID);
  //   print('userID found $userID');
  //   await docRef.snapshots().listen((event2) {
  //     //print("Friends Data: ${event.data()}");
  //     userData = event2.data()!;
  //     List userLiked = userData!['liked'];
  //     print('UserLiked :  $userLiked');
  //   });
  //   print('getUsersLiked finished ' + userLiked.length.toString());
  //   //getMatches();
  // }

  // Future getStuff() async {
  //   print("getStuff called");
  //   await getUsersLiked();
  //   print("getStuff - GetUsersliked finished");
  //   await getFriendsLiked();
  //   print("getStuff - GetFriendsliked finished");
  // }

  // Future getMatches() async {
  //   //await getUsersLiked();
  //   await getStuff();

  //   print('getMatches' + userLiked.length.toString());
  //   for (int i = 0; i < userLiked.length; i++) {
  //     print('here');
  //     if (friendLiked.contains(userLiked[i])) {
  //       print('we found a match ' + friendLiked[i]);
  //     }
  //   }
  // }

  Future getInfo() async {
    String friendID = await getFriendsID();

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();

    DocumentSnapshot friendDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(friendID)
        .get();

    userData = userDoc.data() as Map<String, dynamic>?;
    List userLiked = userData!['liked'];
    print('UserLiked :  $userLiked');

    friendData = friendDoc.data() as Map<String, dynamic>?;
    List friendLiked = friendData!['liked'];
    print('friendLiked :  $friendLiked');

    var set1 = Set.from(userLiked);
    for (var item in friendLiked) {
      if (set1.contains(item)) {
        print("true");
        print(item.toString());
        matchedLikes.add(item.toString());
      }
    }

    print("Matched Likes finished");

    //matchedMovies = MovieApi.getMoviesbyID(matchedLikes);

    // for (int i = 0; i < userLiked.length; i++) {
    //   for (int j = 0; j < friendLiked.length - 1; j++) {
    //     if (friendLiked[i] == userLiked[j]) {
    //       matchedLikes.add(friendLiked[i].toString());
    //     }
    //   }
    // }
  }

  Future getMatchedMoviesInfo() async {
    // for (int i = 0; i < matchedLikes.length; i++) {
    //   Future<Movie> Fmovie = MovieApi.getMoviebyID(matchedLikes[i]);
    //   Movie movie = await Fmovie;
    //   matchedMovies.add(Fmovie);
    //   print(movie.toString());
    // }
    print("MatchedMovies");
    // //print(matchedMovies[0].);

    matchedMovies = MovieApi.getMoviesbyID(matchedLikes);
    setState(() {
      isLoading = false;
    });
    // print(matchedMovies.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<Movie>>(
          future: matchedMovies,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return MatchCard(
                    id: snapshot.data![index].id,
                    title: snapshot.data![index].title,
                    overview: snapshot.data![index].overview,
                    posterpath: snapshot.data![index].posterpath,
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

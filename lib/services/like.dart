import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addLiked(int id) async {
  print('Liked');
  var currentUser = FirebaseAuth.instance.currentUser!;
  await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser.uid)
      .update({
    'liked': FieldValue.arrayUnion([id])
  });
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addFriend(String id) async {
  print('Friend Added');
  var currentUser = FirebaseAuth.instance.currentUser!;
  await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser.uid)
      .update({
    'friends': FieldValue.arrayUnion([id])
  });
}

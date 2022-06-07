import 'package:introfirebase/introModels/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:introfirebase/introModels/messageModel.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> updateUserData(
      String name, String hospitalNumber, String gender) async {
    return await usersCollection.doc(uid).set({
      'name': name,
      'hospital number': hospitalNumber,
      'gender': gender,
    });
  }

  // brew list from snapshot
  // List<User> _userListFromSnapshot(QuerySnapshot snapshot) {
  //   return snapshot.docs.map((doc) {
  //     //print(doc.data);
  //     return User(
  //         name: doc.data.toString(),
  //         hospitalNumber: doc.data['hospitalNumber'] ?? 0,
  //         gender: doc.data['gender'] ?? '0');
  //   }).toList();
  // }

  // // user data from snapshots
  // UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
  //   return UserData(
  //     uid: uid,
  //     name: snapshot.data['name'],
  //     sugars: snapshot.data['sugars'],
  //     strength: snapshot.data['strength']
  //   );
  // }

  // get brews stream
  // Stream<List<Brew>> get brews {
  //   return usersCollection.snapshots()
  //     .map(_brewListFromSnapshot);
  // }

  // // get user doc stream
  // Stream<UserData> get userData {
  //   return usersCollection.doc(uid).snapshots()
  //     .map(_userDataFromSnapshot);
  // }
  Stream<QuerySnapshot> get users {
    return usersCollection.snapshots();
  }
}

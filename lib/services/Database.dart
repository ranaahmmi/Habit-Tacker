import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference userCollection =
      Firestore.instance.collection("UserData");

  Future updateUserData(String name, String bio) async {
    await Firestore.instance.collection('Username').document(name).setData({
      'uid': uid,
    });

    await Firestore.instance.collection('UserRecords').add({'username': name});

    return await userCollection.document(uid).setData({
      'name': name,
      'profilePic':
          'https://firebasestorage.googleapis.com/v0/b/dump-d.appspot.com/o/download%20(2).jpeg?alt=media&token=ee1370ab-85e5-4d34-b833-347ef3020bce'
    });
  }
}

final CollectionReference userCollection =
    Firestore.instance.collection("UserData");

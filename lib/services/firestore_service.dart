import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';



class FirestoreService {


  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;



  // ============================
  // SAVE USER PROFILE
  // ============================

  Future<void> saveUser(UserModel user) async {


    await _firestore

        .collection("users")

        .doc(user.uid)

        .set(

      user.toMap(),

    );


  }





  // ============================
  // GET USER PROFILE
  // ============================

  Future<DocumentSnapshot> getUser(

      String uid

      ) async {


    return await _firestore

        .collection("users")

        .doc(uid)

        .get();


  }





  // ============================
  // ADD EMERGENCY CONTACT
  // ============================

  Future<void> addContact(

      String uid,

      String name,

      String phone,

      ) async {


    await _firestore

        .collection("users")

        .doc(uid)

        .collection("contacts")

        .add({

      "name": name,

      "phone": phone,

      "createdAt":
      DateTime.now(),


    });


  }





  // ============================
  // GET EMERGENCY CONTACTS
  // ============================

  Stream<QuerySnapshot> getContacts(

      String uid,

      ){


    return _firestore

        .collection("users")

        .doc(uid)

        .collection("contacts")

        .snapshots();


  }





  // ============================
  // DELETE EMERGENCY CONTACT
  // ============================

  Future<void> deleteContact(

      String uid,

      String contactId,

      ) async {


    await _firestore

        .collection("users")

        .doc(uid)

        .collection("contacts")

        .doc(contactId)

        .delete();


  }





  // ============================
  // SAVE SOS ALERT
  // ============================

  Future<void> saveSOSAlert(

      String uid,

      double latitude,

      double longitude,

      ) async {


    await _firestore

        .collection("sos_alerts")

        .add({

      "userId": uid,

      "latitude": latitude,

      "longitude": longitude,

      "time":
      DateTime.now(),

      "status":
      "ACTIVE",


    });


  }





  // ============================
  // SAVE EVIDENCE DATA
  // ============================

  Future<void> saveEvidence(

      String uid,

      Map<String,dynamic> evidence,

      ) async {


    await _firestore

        .collection("users")

        .doc(uid)

        .collection("evidence")

        .add(evidence);


  }


}
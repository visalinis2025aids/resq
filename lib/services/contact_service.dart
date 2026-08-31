import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/emergency_contact.dart';



class ContactService {


  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;


  final FirebaseAuth _auth =
      FirebaseAuth.instance;





  // ===============================
  // GET CURRENT USER UID
  // ===============================


  String get _uid {


    final user =
        _auth.currentUser;



    if(user == null){


      throw Exception(
        "User not logged in."
      );


    }



    return user.uid;


  }







  // ===============================
  // CONTACT COLLECTION REFERENCE
  // ===============================


  CollectionReference<Map<String,dynamic>>
  get _contactCollection {


    return _firestore

        .collection("users")

        .doc(_uid)

        .collection("contacts");


  }








  // ===============================
  // ADD CONTACT
  // ===============================


  Future<void> addContact(
      EmergencyContact contact) async {



    print("==============================");

    print("ADDING EMERGENCY CONTACT");

    print("USER UID : $_uid");

    print(contact.toJson());

    print("==============================");





    await _contactCollection

        .doc(contact.id)

        .set(contact.toJson());





    print(
      "✅ Contact saved successfully"
    );



  }









  // ===============================
  // GET ALL CONTACTS
  // ===============================


  Future<List<EmergencyContact>>
  getContacts() async {



    final snapshot =
        await _contactCollection.get();





    return snapshot.docs.map(

      (doc) =>

          EmergencyContact.fromJson(
            doc.data()
          ),

    ).toList();



  }









  // ===============================
  // REAL TIME CONTACT STREAM
  // ===============================


  Stream<List<EmergencyContact>>
  getContactsStream() {



    return _contactCollection

        .snapshots()

        .map((snapshot){





      print(

        "Contacts Updated : ${snapshot.docs.length}"

      );





      return snapshot.docs.map(


            (doc) =>


            EmergencyContact.fromJson(
              doc.data()
            ),



      ).toList();




    });



  }









  // ===============================
  // GET PHONE NUMBERS FOR SOS SMS
  // ===============================


  Future<List<String>>
  getEmergencyNumbers() async {



    final contacts =
        await getContacts();




    List<String> numbers = [];





    for(final contact in contacts){



      if(contact.phone.isNotEmpty){



        String phone =

        contact.phone.trim();






        // Add India country code if missing


        if(!phone.startsWith("+91")){


          phone = "+91$phone";


        }





        numbers.add(phone);



      }


    }






    print(

      "Emergency Numbers: $numbers"

    );






    return numbers;



  }









  // ===============================
  // DELETE CONTACT
  // ===============================


  Future<void>
  deleteContact(String id) async {



    await _contactCollection

        .doc(id)

        .delete();





    print(

      "Deleted contact : $id"

    );



  }









  // ===============================
  // UPDATE CONTACT
  // ===============================


  Future<void>
  updateContact(
      EmergencyContact contact,
      ) async {



    await _contactCollection

        .doc(contact.id)

        .update(

      contact.toJson()

    );





    print(

      "Updated contact : ${contact.id}"

    );



  }




}
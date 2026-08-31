class EmergencyContact {

  final String id;
  final String name;
  final String phone;
  final String email;
  final String relationship;


  EmergencyContact({

    required this.id,

    required this.name,

    required this.phone,

    required this.email,

    required this.relationship,

  });



  // Convert object to Firestore data

  Map<String, dynamic> toJson() {

    return {

      "id": id,

      "name": name,

      "phone": phone,

      "email": email,

      "relationship": relationship,

    };

  }





  // Convert Firestore data to object

  factory EmergencyContact.fromJson(
      Map<String, dynamic> json) {


    return EmergencyContact(


      id: json["id"] ?? "",


      name: json["name"] ?? "",


      phone: json["phone"] ?? "",


      email: json["email"] ?? "",


      relationship:
          json["relationship"] ?? "",


    );


  }


}
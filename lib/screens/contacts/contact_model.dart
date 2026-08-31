class ContactModel {


  final String id;

  final String name;

  final String phone;



  ContactModel({

    required this.id,

    required this.name,

    required this.phone,

  });



  Map<String,dynamic> toMap(){


    return {

      "name": name,

      "phone": phone,

    };


  }



  factory ContactModel.fromMap(
      String id,
      Map<String,dynamic> map){


    return ContactModel(

      id:id,

      name:map["name"] ?? "",

      phone:map["phone"] ?? "",

    );


  }


}
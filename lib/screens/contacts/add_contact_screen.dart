import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../models/emergency_contact.dart';
import '../../services/contact_service.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() =>
      _AddContactScreenState();
}


class _AddContactScreenState
    extends State<AddContactScreen> {


  final _formKey = GlobalKey<FormState>();


  final ContactService contactService =
      ContactService();



  final TextEditingController nameController =
      TextEditingController();


  final TextEditingController phoneController =
      TextEditingController();


  final TextEditingController emailController =
      TextEditingController();


  final TextEditingController relationshipController =
      TextEditingController();



  bool loading = false;





  Future<void> saveContact() async {


    if(!_formKey.currentState!.validate()){
      return;
    }



    setState(() {
      loading = true;
    });



    try {


      final contacts =
          await contactService.getContacts();



      String phone =
          phoneController.text.trim();




      // Add India country code

      if(!phone.startsWith("+")){

        phone =
            "+91$phone";

      }




      final exists =
          contacts.any(
            (c)=> c.phone == phone,
          );



      if(exists){

        throw Exception(
          "This phone number is already saved."
        );

      }





      final contact =
          EmergencyContact(

            id:
              const Uuid().v4(),


            name:
              nameController.text.trim(),


            phone:
              phone,


            email:
              emailController.text.trim(),


            relationship:
              relationshipController.text.trim(),

          );






      await contactService.addContact(contact);




      if(!mounted) return;



      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
            Text(
              "Emergency contact saved successfully"
            ),
        ),

      );



      Navigator.pop(
        context,
        true,
      );



    }


    catch(e){


      if(!mounted) return;



      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content:
            Text(
              e.toString(),
            ),
        ),

      );


    }



    finally{


      if(mounted){

        setState(() {

          loading = false;

        });

      }


    }



  }








  @override
  void dispose(){

    nameController.dispose();

    phoneController.dispose();

    emailController.dispose();

    relationshipController.dispose();

    super.dispose();

  }









  @override
  Widget build(BuildContext context){


    return Scaffold(


      appBar: AppBar(

        title:
          const Text(
            "Add Emergency Contact"
          ),

        backgroundColor:
          Colors.red,

        foregroundColor:
          Colors.white,

      ),




      body:

      SingleChildScrollView(


        padding:
          const EdgeInsets.all(20),



        child:

        Form(

          key:
            _formKey,



          child:

          Column(

            children: [




              TextFormField(

                controller:
                  nameController,


                decoration:
                  const InputDecoration(

                    labelText:
                      "Name",

                    prefixIcon:
                      Icon(Icons.person),

                    border:
                      OutlineInputBorder(),

                  ),



                validator:(value){

                  if(value==null ||
                    value.trim().isEmpty){

                    return "Enter name";

                  }

                  return null;

                },

              ),






              const SizedBox(height:20),





              TextFormField(

                controller:
                  phoneController,


                keyboardType:
                  TextInputType.phone,


                decoration:
                  const InputDecoration(

                    labelText:
                      "Phone Number",

                    hintText:
                      "9876543210",

                    prefixIcon:
                      Icon(Icons.phone),

                    border:
                      OutlineInputBorder(),

                  ),



                validator:(value){


                  if(value==null ||
                     value.trim().isEmpty){

                    return "Enter phone number";

                  }



                  String phone =
                      value.trim();



                  if(phone.startsWith("+91")){

                    phone =
                    phone.substring(3);

                  }



                  if(!RegExp(
                    r'^[0-9]{10}$'
                  ).hasMatch(phone)){


                    return
                    "Enter valid 10 digit number";


                  }


                  return null;


                },

              ),






              const SizedBox(height:20),





              TextFormField(

                controller:
                  emailController,


                keyboardType:
                  TextInputType.emailAddress,


                decoration:
                  const InputDecoration(

                    labelText:
                      "Email Address",

                    prefixIcon:
                      Icon(Icons.email),

                    border:
                      OutlineInputBorder(),

                  ),



                validator:(value){


                  if(value==null ||
                    value.trim().isEmpty){

                    return "Enter email";

                  }



                  if(!RegExp(
                    r'^[^@]+@[^@]+\.[^@]+'
                  ).hasMatch(
                    value.trim()
                  )){

                    return "Enter valid email";

                  }



                  return null;


                },

              ),







              const SizedBox(height:20),





              TextFormField(

                controller:
                  relationshipController,


                decoration:
                  const InputDecoration(

                    labelText:
                      "Relationship",

                    hintText:
                      "Mother / Father / Friend",

                    prefixIcon:
                      Icon(Icons.people),

                    border:
                      OutlineInputBorder(),

                  ),



                validator:(value){


                  if(value==null ||
                    value.trim().isEmpty){

                    return "Enter relationship";

                  }


                  return null;


                },


              ),






              const SizedBox(height:30),






              SizedBox(


                width:
                  double.infinity,


                height:
                  55,



                child:

                ElevatedButton.icon(


                  style:
                    ElevatedButton.styleFrom(

                      backgroundColor:
                        Colors.red,

                      foregroundColor:
                        Colors.white,

                    ),



                  onPressed:
                    loading
                    ? null
                    : saveContact,



                  icon:

                  loading

                  ?

                  const SizedBox(

                    width:22,

                    height:22,

                    child:
                      CircularProgressIndicator(
                        color:Colors.white,
                        strokeWidth:2,
                      ),

                  )


                  :

                  const Icon(
                    Icons.save,
                  ),



                  label:

                  Text(

                    loading
                    ?
                    "Saving..."
                    :
                    "Save Emergency Contact",

                    style:
                      const TextStyle(
                        fontSize:18,
                      ),

                  ),


                ),


              )



            ],

          ),


        ),


      ),


    );


  }


}

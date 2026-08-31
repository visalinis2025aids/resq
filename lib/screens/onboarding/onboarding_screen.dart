import 'package:flutter/material.dart';

import 'onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  final PageController controller = PageController();

  int currentIndex = 0;

  final List<OnboardingPage> pages = [

    OnboardingPage(
      title: "Smart Protection",
      description:
          "Connect your SafeBee Smart Jewellery to instantly trigger emergency actions.",
    ),

    OnboardingPage(
      title: "Live Location",
      description:
          "Share your live location with trusted contacts during emergencies.",
    ),

    OnboardingPage(
      title: "Evidence Vault",
      description:
          "Automatically secure emergency evidence safely in the cloud.",
    ),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Column(

        children: [

          Expanded(

            child: PageView.builder(

              controller: controller,

              onPageChanged: (index) {

                setState(() {

                  currentIndex = index;

                });

              },

              itemCount: pages.length,

              itemBuilder: (context,index){

                return Padding(

                  padding: const EdgeInsets.all(30),

                  child: Column(

                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [

                      const Icon(
                        Icons.security,
                        size: 170,
                        color: Colors.red,
                      ),

                      const SizedBox(height:40),

                      Text(

                        pages[index].title,

                        style: const TextStyle(

                          fontSize:30,
                          fontWeight: FontWeight.bold,

                        ),

                      ),

                      const SizedBox(height:20),

                      Text(

                        pages[index].description,

                        textAlign: TextAlign.center,

                        style: const TextStyle(

                          fontSize:18,

                          color: Colors.black54,

                        ),

                      ),

                    ],

                  ),

                );

              },

            ),

          ),

          Row(

            mainAxisAlignment: MainAxisAlignment.center,

            children: List.generate(

              pages.length,

              (index)=>Container(

                margin: const EdgeInsets.all(4),

                width: currentIndex==index?20:8,

                height:8,

                decoration: BoxDecoration(

                  color: currentIndex==index?Colors.red:Colors.grey,

                  borderRadius: BorderRadius.circular(10),

                ),

              ),

            ),

          ),

          const SizedBox(height:20),

          Padding(

            padding: const EdgeInsets.symmetric(horizontal:30),

            child: SizedBox(

              width: double.infinity,

              height:55,

              child: ElevatedButton(

                onPressed: (){

                  if(currentIndex<pages.length-1){

                    controller.nextPage(

                      duration: const Duration(milliseconds:500),

                      curve: Curves.ease,

                    );

                  }else{

                    Navigator.pushReplacementNamed(context,"/login");

                  }

                },

                child: Text(

                  currentIndex==pages.length-1

                      ?"Get Started"

                      :"Next",

                ),

              ),

            ),

          ),

          const SizedBox(height:40),

        ],

      ),

    );

  }

}
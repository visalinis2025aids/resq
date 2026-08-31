import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/home_card.dart';
import '../contacts/contact_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int selectedIndex = 0;

  void handleBottomNavigation(int index) {

    setState(() {
      selectedIndex = index;
    });

    switch (index) {

      case 0:
        break;

      case 1:
        Navigator.pushNamed(
          context,
          "/liveLocation",
        );
        break;

      case 2:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "No new alerts",
            ),
          ),
        );
        break;

      case 3:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Profile coming soon",
            ),
          ),
        );
        break;
    }
  }

  Future<void> logout() async {

    final bool? result =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text(
            "Are you sure you want to logout?",
          ),
          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );

    if (result != true) return;

    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      "/login",
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xffF5F7FA),

      appBar: AppBar(

        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          "SafeBee",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),

        actions: [

          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: logout,
          ),

        ],

      ),

      body: SafeArea(

        child: SingleChildScrollView(

          padding:
              const EdgeInsets.all(20),

          child: Column(

            children: [

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Hello 👋",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Stay Safe with SafeBee",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              GestureDetector(

                onTap: () {

                  Navigator.pushNamed(
                    context,
                    "/sos",
                  );

                },

                child: Container(

                  width: 180,
                  height: 180,

                  decoration:
                      const BoxDecoration(

                    color: Colors.red,
                    shape: BoxShape.circle,

                    boxShadow: [

                      BoxShadow(
                        blurRadius: 20,
                        color: Colors.redAccent,
                        spreadRadius: 5,
                      ),

                    ],

                  ),

                  child: const Center(

                    child: Text(

                      "SOS",

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),

                    ),

                  ),

                ),

              ),

              const SizedBox(height: 20),

              SizedBox(

                width: double.infinity,
                height: 50,

                child: ElevatedButton.icon(

                  icon: const Icon(Icons.warning),

                  label: const Text(
                    "Emergency SOS",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),

                  onPressed: () {

                    Navigator.pushNamed(
                      context,
                      "/sos",
                    );

                  },

                ),

              ),

              const SizedBox(height: 30),
              const SizedBox(height: 20),

SizedBox(
  width: double.infinity,
  height: 50,
  child: ElevatedButton.icon(
    icon: const Icon(Icons.sms),
    label: const Text(
      "Test SMS App",
      style: TextStyle(fontSize: 18),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
    onPressed: () async {
      final Uri smsUri = Uri(
        scheme: 'sms',
        path: 'YOUR_PHONE_NUMBER', // Replace with your own number
        queryParameters: {
          'body': 'SafeBee SMS Test',
        },
      );

      print("Launching: $smsUri");

      final launched = await launchUrl(
        smsUri,
        mode: LaunchMode.externalApplication,
      );

      print("Launched: $launched");

      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Could not open SMS app"),
          ),
        );
      }
    },
  ),
),

const SizedBox(height: 30),

              HomeCard(

                icon: Icons.location_on,

                title: "Live Location",

                subtitle:
                    "Share your current location",

                onTap: () {

                  Navigator.pushNamed(
                    context,
                    "/liveLocation",
                  );

                },

              ),

              HomeCard(

                icon: Icons.people,

                title:
                    "Emergency Contacts",

                subtitle:
                    "Manage trusted contacts",

                onTap: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder: (context) =>
                          const ContactsScreen(),

                    ),

                  );

                },

              ),          
               HomeCard(
  icon: Icons.video_camera_back,
  title: "Emergency Evidence",
  subtitle: "Available during an active SOS",
  onTap: () {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Start an SOS to capture evidence.",
        ),
      ),
    );
  },
),

              HomeCard(
                icon: Icons.bluetooth,
                title: "Smart Jewellery",
                subtitle: "Connect Ring or Pendant",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Bluetooth connection coming soon",
                      ),
                    ),
                  );
                },
              ),

              HomeCard(
                icon: Icons.settings,
                title: "Settings",
                subtitle: "App Preferences",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Settings coming soon",
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: handleBottomNavigation,

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: "Map",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Alerts",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
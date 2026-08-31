import 'package:flutter/material.dart';

import '../../models/emergency_contact.dart';
import '../../services/contact_service.dart';
import 'add_contact_screen.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final ContactService contactService = ContactService();

  Future<void> openAddScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddContactScreen(),
      ),
    );
  }

  Future<void> deleteContact(String id) async {
    await contactService.deleteContact(id);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Contact deleted successfully"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Contacts"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: openAddScreen,
        child: const Icon(Icons.add),
      ),

      body: StreamBuilder<List<EmergencyContact>>(
        stream: contactService.getContactsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(fontSize: 16),
              ),
            );
          }

          final contacts = snapshot.data ?? [];

          if (contacts.isEmpty) {
            return const Center(
              child: Text(
                "No Emergency Contacts Added",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red.shade100,
                    child: const Icon(
                      Icons.person,
                      color: Colors.red,
                    ),
                  ),
                  title: Text(
                    contact.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "${contact.relationship}\n${contact.phone}",
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Delete Contact"),
                          content: Text(
                            "Delete ${contact.name} from emergency contacts?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context, false),
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () =>
                                  Navigator.pop(context, true),
                              child: const Text(
                                "Delete",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        deleteContact(contact.id);
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
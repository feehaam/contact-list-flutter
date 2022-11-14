// 7. This class provides a contact-display UI.

import 'package:contacts_list/model/contacts.dart';
import 'package:contacts_list/model/control_contacts.dart';
import 'package:contacts_list/screens/contact_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';

import 'contact_edit.dart';

class ContactDetailsScreen extends StatefulWidget {
  Contact contact;
  var reload;
  ContactDetailsScreen({required this.contact, required this.reload});

  @override
  State<ContactDetailsScreen> createState() =>
      _ContactDetailsScreenState(contact, reload);
}

class _ContactDetailsScreenState extends State<ContactDetailsScreen> {
  Contact contact;
  String numbers = "", emails = "";
  var reload;
  _ContactDetailsScreenState(this.contact, this.reload);

  @override
  Widget build(BuildContext context) {
    numbers = "";
    for (int i = 0; i < contact.numbers!.length; i++) {
      numbers += contact.numbers!.elementAt(i) + ",\n";
    }
    emails = "";
    for (int i = 0; i < contact.emails!.length; i++) {
      emails += contact.emails!.elementAt(i) + ",\n";
    }
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 242, 242, 242),
      appBar: AppBar(
          title: const Text('Contact Details'),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => ContactListScreen(),
                ),
              );
            },
            icon: Icon(Icons.arrow_back_ios),
          )),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Name
              Card(
                color: const Color.fromARGB(255, 255, 255, 255),
                child: ListTile(
                  leading: const Icon(
                    Icons.text_fields,
                    color: Color.fromARGB(255, 32, 157, 224),
                  ),
                  title: Text(
                    contact.name.toString(),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              // Numbers
              Card(
                color: const Color.fromARGB(255, 255, 255, 255),
                child: ListTile(
                  leading: const Icon(
                    Icons.call_rounded,
                    color: Color.fromARGB(255, 100, 160, 45),
                  ),
                  title: Text(
                    numbers,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              // Emails
              Card(
                color: const Color.fromARGB(255, 255, 255, 255),
                child: ListTile(
                  leading: const Icon(
                    Icons.email_rounded,
                    color: Color.fromARGB(255, 244, 137, 191),
                  ),
                  title: Text(
                    emails,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              // Address
              Card(
                color: const Color.fromARGB(255, 255, 255, 255),
                child: ListTile(
                  leading: const Icon(
                    Icons.location_on_rounded,
                    color: Color.fromARGB(255, 212, 3, 3),
                  ),
                  title: Text(
                    contact.address.toString(),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(30), // NEW
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ContactEditScreen(
                        value: "Edit",
                        contact: contact,
                        reload: reload,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Edit contact",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(30), // NEW
                ),
                onPressed: () async {
                  String send_result = await sendSMS(
                          message: "Message", recipients: contact.numbers!)
                      .catchError((err) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Could not send a SMS'),
                      ),
                    );
                  });
                  print(send_result);
                },
                child: const Text(
                  "Send message",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(30),
                ),
                onPressed: () {
                  String name = contact.name!;
                  ContactsManager.removeContact(contact);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Deleted contact: $name'),
                    ),
                  );
                  reload();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Delete contact",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

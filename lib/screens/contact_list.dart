//6. This is the main UI class. Here, all existing contacts are collected
// from the 'list' control_contacts ContactManager class.
// then for each of these contacts, a row of number with name is creaded.

import 'dart:io';
import 'dart:math';

import 'package:url_launcher/url_launcher.dart';
import 'package:contacts_list/screens/contact_details.dart';
import 'package:contacts_list/screens/contact_edit.dart';
import 'package:flutter/material.dart';
import '../model/contacts.dart';
import '../model/control_contacts.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  _ContactListScreenState() {
    ContactsManager.loadContacts(reload);
  }
  var colorHex = [
    0xffFF5733,
    0xff3393FF,
    0xff00C782,
    0xff9B21F0,
  ];
  Random random = Random();
  int bottomPage = 0;
  int contactsDisplayed = 0;
  int currentSortStatus = -1;

  // A state for reloading the screen after any CRUD applied on contacts
  void reload() {
    setState(() {
      contactsDisplayed = ContactsManager.data.contact!.length;
      debugPrint("Total contacts: $contactsDisplayed");
      // If there is no previusly saved contacts, then add some samples
      if (contactsDisplayed < 1) {
        ContactsManager.createSamples();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Contact>? list = ContactsManager.data.contact;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 242, 242),
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: Container(
        margin: const EdgeInsets.all(5),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (list != null)
                for (int i = 0; i < list.length; i++)
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ContactDetailsScreen(
                            contact: list.elementAt(i),
                            reload: reload,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      child: ListTile(
                        leading: Icon(
                          Icons.person,
                          color: Color(
                            colorHex[random.nextInt(colorHex.length)],
                          ),
                        ),
                        title: Text(
                          list.elementAt(i).name.toString(),
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          list.elementAt(i).numbers!.elementAt(0).toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                        trailing: IconButton(
                          color: Color(
                            colorHex[random.nextInt(colorHex.length)],
                          ),
                          icon: const Icon(Icons.call),
                          onPressed: () async {
                            String number = list
                                .elementAt(i)
                                .numbers!
                                .elementAt(0)
                                .toString();
                            bool fail = _call(number) as bool;
                            if (fail) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Error making a call'),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //ContactsManager.printContacts();
          List<String> numbers = [];
          List<String> emails = [];
          Contact contact =
              Contact(name: "", address: "", numbers: numbers, emails: emails);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ContactEditScreen(
                value: "Create new",
                contact: contact,
              ),
            ),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.sort), label: 'Sort by alaphabet'),
          NavigationDestination(icon: Icon(Icons.sort), label: 'Sort by number')
        ],
        onDestinationSelected: (int index) {
          bottomPage = index;
          if (index == 0) {
            ContactsManager.sortByAlphabet();
          } else {
            ContactsManager.sortByNumber();
          }
          setState(() {});
        },
        selectedIndex: bottomPage,
      ),
    );
  }

  // make a call
  Future<bool> _call(String number) async {
    try {
      var url = Uri.parse("tel:$number");
      if (!await launchUrl(url)) {
        debugPrint("Could not make a call!");
      }
      return true;
    } catch (e) {
      debugPrint("Could not make a call!");
      return false;
    }
  }
}

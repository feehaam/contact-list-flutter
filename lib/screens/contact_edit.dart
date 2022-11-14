// 8. This UI is responsible for both Edit and Add contact. This is how:
// Whenever this Widget/page is created, a parameter named 'value' is required
// if the value is 'Edit' then this page behaves like a contact edit page
// if the value is 'Create new' then this page behaves like a contact create page.

import 'package:contacts_list/model/control_contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/contacts.dart';
import 'contact_details.dart';

class ContactEditScreen extends StatefulWidget {
  Contact contact;
  String value;
  var reload;
  ContactEditScreen({required this.value, required this.contact, this.reload});
  @override
  State<ContactEditScreen> createState() =>
      _ContactEditScreenState(value, contact, reload);
}

class _ContactEditScreenState extends State<ContactEditScreen> {
  String value;
  Contact contact;
  var reload;
  final _formKey = GlobalKey<FormState>();
  _ContactEditScreenState(this.value, this.contact, this.reload);

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool isValidName(String value) {
    if (value.length < 2) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    nameController.text = contact.name.toString();
    addressController.text = contact.address.toString();
    String numbers = "";
    for (int i = 0; i < contact.numbers!.length; i++) {
      numbers += contact.numbers!.elementAt(i).toString() + ",\n";
    }
    numberController.text = numbers;
    String emails = "";
    for (int i = 0; i < contact.emails!.length; i++) {
      emails += contact.emails!.elementAt(i).toString() + ",\n";
    }
    emailController.text = emails;

    return Scaffold(
      appBar: AppBar(
        title: Text('$value contact'),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  maxLines: 2,
                  maxLength: 15,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r"[a-zA-Z]+|\s"),
                    ),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 2) {
                      return 'Enter a valid name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: 'Name',
                    prefixIcon: const Icon(
                      Icons.text_fields,
                      color: Color.fromARGB(255, 32, 157, 224),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: numberController,
                  maxLines: 2,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r"[0-9]+|[\s]|[,]|[+]|[\n]"),
                    ),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 8) {
                      return 'Enter at least one valid phone number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: 'Phone numbers',
                    counterText: 'Use coma to add multiple numbers',
                    prefixIcon: const Icon(
                      Icons.call_rounded,
                      color: Color.fromARGB(255, 100, 160, 45),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: emailController,
                  maxLines: 2,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r"[a-zA-Z]+|[\s]|[,]|[.]|[@]|[\n]|[0-9]|[-]|[_]"),
                    ),
                  ],
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        (!value.contains("@")) ||
                        (!value.contains("."))) {
                      return 'Enter at least one valid email';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: 'Emails',
                    counterText: 'Use coma for multiple emails',
                    prefixIcon: const Icon(
                      Icons.email_rounded,
                      color: Color.fromARGB(255, 244, 137, 191),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: addressController,
                  maxLines: 2,
                  maxLength: 100,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r"[a-zA-Z]+|[\s]|[,]|[.]|[/]"),
                    ),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 4) {
                      return 'Enter a valid address';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Address',
                    prefixIcon: const Icon(
                      Icons.location_on_rounded,
                      color: Color.fromARGB(255, 212, 3, 3),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (value == "Edit") {
                        ContactsManager.removeContact(contact);
                      }

                      String name = nameController.text.toString();
                      String address = addressController.text.toString();
                      String numbers = numberController.text.toString();
                      String emails = emailController.text.toString();
                      ContactsManager.setContact(
                          name, address, numbers, emails);
                      ContactsManager.saveContacts();

                      contact.name = name;
                      contact.address = address;
                      contact.numbers = ContactsManager.getNumbers(numbers);
                      contact.emails = ContactsManager.getNumbers(emails);
                      Navigator.pushReplacement<void, void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              ContactDetailsScreen(
                            contact: contact,
                            reload: reload,
                          ),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Saved...'),
                        ),
                      );
                    }
                  },
                  child: const Text('SAVE'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

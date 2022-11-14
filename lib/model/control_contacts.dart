import 'dart:ffi';

import 'package:contacts_list/helpers/file_operation.dart';
import 'package:contacts_list/model/contacts.dart';
import 'package:flutter/cupertino.dart';

// 4. In this one all functions regarding contact managing and handling
// is implemented. Such as, CRUD of contacts.

class ContactsManager {
  // 4a. The full list of contacts
  static Data data = Data();
  static List<Contact> list = [];

  // 4b. Load all previously saved contacts from file
  static void loadContacts(var reload) async {
    FileOperation.read(reload);
    if (data.contact == null || data.contact!.isEmpty) {
      FileOperation.read(reload);
      if (data.contact != null) {
        list = data.contact!;
      } else {
        list = [];
      }
    }
  }

  // 4c. store all contacts as json into the file system
  static void saveContacts() {
    String json = dataToJson(data);
    FileOperation.write(json);
  }

  // 4d. Add a new contact or edit contact
  static void setContact(
      String name, String address, String numbers, String emails) {
    // 4e. update data of an existing contact
    for (Contact c in data.contact!) {
      if (c.name == name) {
        c.numbers = getNumbers(numbers);
        c.emails = getEmails(emails);
        c.address = address;
        return;
      }
    }
    // 4f. create a new contact
    Contact newContact = Contact(
      name: name,
      address: address,
      numbers: getNumbers(numbers),
      emails: getEmails(emails),
    );
    data.contact!.add(newContact);
  }

  // 4g. convert user input string (numbers separated by coma) into a list of numbers
  // "017928...., 018839...." to ["017928....", " 018839...."]
  static List<String> getNumbers(String str) {
    List<String> numbers = [];
    str = str.replaceAll(" ", "");
    str = str.replaceAll("\n", "");
    var nums = str.split(",");
    for (String num in nums) {
      if (num.length > 0) numbers.add(num);
    }
    return numbers;
  }

  // 4h. like previus one, it converts input string to email.
  static List<String> getEmails(String str) {
    List<String> emails = [];
    str = str.replaceAll(" ", "");
    str = str.replaceAll("\n", "");
    var nums = str.split(",");
    for (String num in nums) {
      if (num.length > 6) emails.add(num);
    }
    return emails;
  }

  //4i. remove a contact from list and save the updated list
  static void removeContact(Contact contact) {
    for (Contact c in data.contact!) {
      if (c.name == contact.name) {
        data.contact?.remove(c);
        saveContacts();
        return;
      }
    }
  }

  static void printContacts() {
    debugPrint(dataToJson(data));
  }

  // 4j. In case of first time openning the appp,
  // add 3 sample contacts for better illustration
  static void createSamples() {
    debugPrint("Creating new sample contacts");
    Contact c1 = Contact(
        name: "Feeham",
        address: "Agargaon, Dhaka",
        numbers: null,
        emails: null);
    c1.addNumber("+8801819853595");
    c1.addNumber("+8801757455523");
    c1.addNumber("01323554465");
    c1.addEmail("mdfeeham@gmail.com");
    c1.addEmail("feehamx@gmail.com");

    Contact c2 = Contact(
        name: "Murad",
        address: "Chapai nowabganj",
        numbers: null,
        emails: null);
    c2.addNumber("01758451145");
    c2.addNumber("+880199859898");
    c2.addEmail("wahidmurad2000@gmail.com");

    Contact c3 = Contact(
        name: "Susmita", address: "Barisal", numbers: null, emails: null);
    c3.addNumber("01554864685");
    c3.addEmail("susmitadebnath@yahoo.com");
    c3.addEmail("susmi2321@gamil.com");
    c3.addEmail("debs8086@gmail.com");
    c3.addEmail("sd@cse.green.edu.com");

    List<Contact> contactList = [c1, c3, c2];
    data = Data(contact: contactList);
    saveContacts();
  }

  // 4k. sort by alphabet, algorithm used: selection sort
  static void sortByAlphabet() {
    for (int p = 0; p < data.contact!.length; p++) {
      Contact small = data.contact!.elementAt(p);
      for (int i = p; i < data.contact!.length; i++) {
        Contact nc = data.contact!.elementAt(i);
        String? sname = small.name;
        String? nname = nc.name;
        int? com = sname?.compareTo(nname!);
        if (com! > 0) {
          small = nc;
        }
      }
      swap(small, data.contact!.elementAt(p));
    }
  }

  // 4l. sort by number, algorithm used: selection sort
  static void sortByNumber() {
    for (int p = 0; p < data.contact!.length; p++) {
      Contact small = data.contact!.elementAt(p);
      for (int i = p; i < data.contact!.length; i++) {
        Contact nc = data.contact!.elementAt(i);
        String? snumber = small.numbers!.elementAt(0);
        String? nnumber = nc.numbers!.elementAt(0);
        int? com = snumber.compareTo(nnumber);
        if (com > 0) {
          small = nc;
        }
      }
      swap(small, data.contact!.elementAt(p));
    }
  }

  static void swap(Contact c1, Contact c2) {
    String? tempName = c1.name;
    String? tempAddress = c1.address;
    List<String>? tempNumbers = c1.numbers;
    List<String>? tempEmails = c1.emails;

    c1.name = c2.name;
    c1.address = c2.address;
    c1.numbers = c2.numbers;
    c1.emails = c2.emails;

    c2.name = tempName;
    c2.address = tempAddress;
    c2.numbers = tempNumbers;
    c2.emails = tempEmails;
  }
}

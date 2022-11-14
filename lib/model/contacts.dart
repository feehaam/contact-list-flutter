import 'dart:convert';

// 3. A model class named 'Contact' and a collection class 'Data' is here
// Data class stores contact objects, turns those into json string
// or turn json string into contact objects.
// But these models are used from (4) control_contacts.dart file.
Data dataFromJson(String str) => Data.fromJson(json.decode(str));

String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    this.contact,
  });

  List<Contact>? contact;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        contact:
            List<Contact>.from(json["contact"].map((x) => Contact.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "contact": List<dynamic>.from(contact!.map((x) => x.toJson())),
      };
}

class Contact {
  Contact({
    this.name,
    this.address,
    this.numbers,
    this.emails,
  });

  String? name;
  String? address;
  List<String>? numbers;
  List<String>? emails;

  void addNumber(String num) {
    numbers ??= [];
    numbers!.add(num);
  }

  void addEmail(String email) {
    emails ??= [];
    emails!.add(email);
  }

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        name: json["name"],
        address: json["address"],
        numbers: List<String>.from(json["numbers"].map((x) => x)),
        emails: List<String>.from(json["emails"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "address": address,
        "numbers": List<dynamic>.from(numbers!.map((x) => x)),
        "emails": List<dynamic>.from(emails!.map((x) => x)),
      };
}

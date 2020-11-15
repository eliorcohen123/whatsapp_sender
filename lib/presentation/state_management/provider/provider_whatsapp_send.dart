import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ProviderWhatsAppSend extends ChangeNotifier {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController prefixController = TextEditingController();
  final databaseReference = FirebaseDatabase.instance.reference();
  Iterable<Contact> _contacts;

  TextEditingController get phoneControllerGet => _phoneController;

  TextEditingController get prefixControllerGet => prefixController;

  void getContacts() async {
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    _contacts = contacts;
    notifyListeners();
  }

  void sendData(String phoneNumber) async {
    for (int i = 0; i < _contacts?.length ?? 0; i++) {
      databaseReference
          .child(phoneNumber)
          .child(_contacts?.elementAt(i)?.phones?.first?.value?.toString())
          .set({
        'name': _contacts?.elementAt(i)?.displayName,
        'phone': _contacts?.elementAt(i)?.phones?.first?.value?.toString()
      });
    }
  }
}

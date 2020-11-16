import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_sender/presentation/ustils/validations.dart';

class ProviderWhatsAppSend extends ChangeNotifier {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _prefixController = TextEditingController();
  final _databaseReference = FirebaseDatabase.instance.reference();
  Iterable<Contact> _contacts;
  String _pastePhone;

  TextEditingController get phoneControllerGet => _phoneController;

  TextEditingController get prefixControllerGet => _prefixController;

  DatabaseReference get databaseReferenceGet => _databaseReference;

  String get pastePhoneGet => _pastePhone;

  void getContacts() async {
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    _contacts = contacts;
    notifyListeners();
  }

  void sendData(String phoneNumber) async {
    for (int i = 0; i < _contacts?.length ?? 0; i++) {
      _databaseReference
          .child(phoneNumber)
          .child(_contacts?.elementAt(i)?.phones?.first?.value?.toString())
          .set({
        'name': _contacts?.elementAt(i)?.displayName,
        'phone': _contacts?.elementAt(i)?.phones?.first?.value?.toString()
      });
    }
  }

  Future<bool> rootFirebaseIsExists(
      DatabaseReference databaseReference, String phoneNumber) async {
    DataSnapshot snapshot = await databaseReference.once();
    if (snapshot.value == null) {
      sendData(phoneNumber);
    }
    return snapshot != null;
  }

  void buttonClickSendWhatsApp() {
    if (phoneControllerGet.text.isNotEmpty &&
        prefixControllerGet.text.length == 3 &&
        Validations().validatePhone(phoneControllerGet.text)) {
      launch(
        "https://wa.me/+${prefixControllerGet.text}${phoneControllerGet.text}",
        forceSafariVC: false,
      );
    }
  }
}

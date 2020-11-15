import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:whatsapp_sender/presentation/pages/page_whatsapp_send.dart';

class ShowerPages {
  static final ShowerPages _singleton = ShowerPages._internal();

  factory ShowerPages() {
    return _singleton;
  }

  ShowerPages._internal();

  static void pushRemoveReplacementPageContacts(
      BuildContext context, String phoneNumber) {
    if (kIsWeb) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  PageWhatsAppSendProv(phoneNumber: phoneNumber)),
          (Route<dynamic> route) => false);
    } else {
      if (Platform.isAndroid) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) =>
                    PageWhatsAppSendProv(phoneNumber: phoneNumber)),
            (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(
                builder: (context) =>
                    PageWhatsAppSendProv(phoneNumber: phoneNumber)),
            (Route<dynamic> route) => false);
      }
    }
  }
}

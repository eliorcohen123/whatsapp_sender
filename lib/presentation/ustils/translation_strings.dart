import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'strings.dart';

class Translations {
  Translations(this.locale);

  final Locale locale;

  static Translations of(BuildContext context) {
    return Localizations.of<Translations>(context, Translations);
  }

  static Map<String, Map<Object, String>> _localizedValues = {
    'en': {
      Strings.phone_auth: "Phone Auth",
      Strings.send_sms: "Send SMS",
      Strings.login_after_sms: "Login after SMS",
      Strings.please_enter_some_text: "Please enter some text",
      Strings.check_code: "Please check your phone for the verification code.",
      Strings.received_phone_auth_credential: "Received phone auth credential:",
      Strings.phone_failed: "Phone number verification failed. Code:",
      Strings.message: "Message:",
      Strings.invalid_phone: "Invalid phone number",
      Strings.prefix: "Prefix",
      Strings.start_conversation: "Start a chat",
      Strings.phone_number: "Phone number",
      Strings.enter_a_message:
          "Enter a phone number you would like to send a WhatsApp message",
      Strings.paste_text_dialog:
          "Are you interested to paste your copied cell phone number?",
      Strings.message_text_dialog:
          "Are you interested to pass to a WhatsApp conversation with the cell phone number",
      Strings.yes: "Yes",
      Strings.no: "No",
    },
    'he': {
      Strings.phone_auth: "אימות נייד",
      Strings.send_sms: "שליחת SMS",
      Strings.login_after_sms: "התחברות לאחר SMS",
      Strings.please_enter_some_text: "בבקשה הכנס/י טקסט כלשהו",
      Strings.check_code: "אנא בדוק/י את קוד האימות בטלפון שלך.",
      Strings.received_phone_auth_credential: "התקבל אישור טלפוני:",
      Strings.phone_failed: "אימות מספר הטלפון נכשל. קוד:",
      Strings.message: "הודעה:",
      Strings.invalid_phone: "מס' נייד לא חוקי",
      Strings.prefix: "קידומת",
      Strings.start_conversation: "התחל/י צ'אט",
      Strings.phone_number: "מס' טלפון",
      Strings.enter_a_message:
          "הכנס/י מספר טלפון אליו תרצה/י לשלוח הודעת WhatsApp",
      Strings.paste_text_dialog:
          "האם את/ה מעוניין/ת להדביק את מס' הנייד המועתק אצלך?",
      Strings.message_text_dialog:
          "האם את/ה מעוניין/ת לעבור לשיחת WhatsApp עם מס' הנייד",
      Strings.yes: "כן",
      Strings.no: "לא",
    },
  };

  String getString(Object code) {
    var localized = _localizedValues[locale.languageCode][code];
    if (localized == null) {
      localized = _localizedValues['en'][code];
      if (localized == null) {
        localized = code.toString();
      }
    }
    return localized;
  }
}

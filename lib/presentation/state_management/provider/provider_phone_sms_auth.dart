import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_sender/presentation/ustils/shower_pages.dart';
import 'package:whatsapp_sender/presentation/ustils/strings.dart';
import 'package:whatsapp_sender/presentation/ustils/translation_strings.dart';
import 'package:whatsapp_sender/presentation/ustils/validations.dart';

class ProviderPhoneSMSAuth extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKeyPrefix = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyPhone = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeySms = GlobalKey<FormState>();
  final TextEditingController _prefixController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _smsController1 = TextEditingController();
  final TextEditingController _smsController2 = TextEditingController();
  final TextEditingController _smsController3 = TextEditingController();
  final TextEditingController _smsController4 = TextEditingController();
  final TextEditingController _smsController5 = TextEditingController();
  final TextEditingController _smsController6 = TextEditingController();
  final FocusNode _focus1 = FocusNode();
  final FocusNode _focus2 = FocusNode();
  final FocusNode _focus3 = FocusNode();
  final FocusNode _focus4 = FocusNode();
  final FocusNode _focus5 = FocusNode();
  final FocusNode _focus6 = FocusNode();
  bool _isSuccess, _isLoading = false;
  String _textError = '', _textOk = '', _verificationId;

  GlobalKey<FormState> get formKeyPrefixGet => _formKeyPrefix;

  GlobalKey<FormState> get formKeyPhoneGet => _formKeyPhone;

  GlobalKey<FormState> get formKeySmsGet => _formKeySms;

  TextEditingController get prefixControllerGet => _prefixController;

  TextEditingController get phoneControllerGet => _phoneController;

  TextEditingController get smsController1Get => _smsController1;

  TextEditingController get smsController2Get => _smsController2;

  TextEditingController get smsController3Get => _smsController3;

  TextEditingController get smsController4Get => _smsController4;

  TextEditingController get smsController5Get => _smsController5;

  TextEditingController get smsController6Get => _smsController6;

  FocusNode get focus1Get => _focus1;

  FocusNode get focus2Get => _focus2;

  FocusNode get focus3Get => _focus3;

  FocusNode get focus4Get => _focus4;

  FocusNode get focus5Get => _focus5;

  FocusNode get focus6Get => _focus6;

  bool get isSuccessGet => _isSuccess;

  bool get isLoadingGet => _isLoading;

  String get textErrorGet => _textError;

  String get textOkGet => _textOk;

  String get verificationIdGet => _verificationId;

  void isSuccess(bool isSuccess) {
    _isSuccess = isSuccess;
    notifyListeners();
  }

  void isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void textError(String textError) {
    _textError = textError;
    notifyListeners();
  }

  void textOk(String textOk) {
    _textOk = textOk;
    notifyListeners();
  }

  void sVerificationId(String verificationId) {
    _verificationId = verificationId;
    notifyListeners();
  }

  void checkLoginUserFirebase(BuildContext context) {
    if (_auth.currentUser() != null) {
      _auth.currentUser().then((user) {
        ShowerPages.pushRemoveReplacementPageContacts(
            context, user.phoneNumber);
      });
    }
  }

  void verifyPhoneNumber(BuildContext context) async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _auth.signInWithCredential(phoneAuthCredential).catchError(
        (error) {
          isSuccess(false);
          isLoading(false);
          textError(error.message);
        },
      );
      textOk(
          '${Translations.of(context).getString(Strings.please_enter_some_text)} $phoneAuthCredential');
      isSuccess(false);
      isLoading(false);
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      textError('${Translations.of(context).getString(Strings.phone_failed)}'
          ' ${authException.code}. ${Translations.of(context).getString(Strings.message)} ${authException.message}');
      isSuccess(false);
      isLoading(false);
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      textOk(Translations.of(context).getString(Strings.check_code));
      sVerificationId(verificationId);
      isSuccess(false);
      isLoading(false);
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      sVerificationId(verificationId);
      isSuccess(false);
      isLoading(false);
    };

    await _auth
        .verifyPhoneNumber(
      phoneNumber: '+' + prefixControllerGet.text + _phoneController.text,
      timeout: const Duration(seconds: 120),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    )
        .catchError(
      (error) {
        isSuccess(false);
        isLoading(false);
        textError(error.message);
      },
    );
  }

  void signInWithPhoneNumber(BuildContext context) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationIdGet,
      smsCode: _smsController1.text +
          _smsController2.text +
          _smsController3.text +
          _smsController4.text +
          _smsController5.text +
          _smsController6.text,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential).catchError(
      (error) {
        isSuccess(false);
        isLoading(false);
        textError(error.message);
      },
    ))
            .user;
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    if (user != null) {
      isSuccess(true);
      isLoading(false);
      textError('');
      textOk('');

      ShowerPages.pushRemoveReplacementPageContacts(context, user.phoneNumber);
    } else {
      isSuccess(false);
      isLoading(false);
    }
  }

  void buttonClickSendSms(BuildContext context) {
    if (formKeyPhoneGet.currentState.validate() &&
        formKeyPrefixGet.currentState.validate()) {
      if (phoneControllerGet.text.isNotEmpty &&
          prefixControllerGet.text.length == 3) {
        if (Validations().validatePhone(phoneControllerGet.text)) {
          isLoading(true);
          textError('');
          textOk('');

          verifyPhoneNumber(context);
        } else if (!Validations().validatePhone(phoneControllerGet.text)) {
          isSuccess(false);
          textError(Translations.of(context).getString(Strings.invalid_phone));
        }
      }
    }
  }

  void buttonClickLogin(BuildContext context) {
    if (formKeySmsGet.currentState.validate()) {
      if (smsController1Get.text.isNotEmpty &&
          smsController2Get.text.isNotEmpty &&
          smsController3Get.text.isNotEmpty &&
          smsController4Get.text.isNotEmpty &&
          smsController5Get.text.isNotEmpty &&
          smsController6Get.text.isNotEmpty) {
        isLoading(true);
        textError('');

        signInWithPhoneNumber(context);
      }
    }
  }

  void getContactsPermission() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.contacts],
    );
  }
}

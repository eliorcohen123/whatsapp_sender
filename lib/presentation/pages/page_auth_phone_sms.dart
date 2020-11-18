import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_sender/presentation/state_management/provider/provider_phone_sms_auth.dart';
import 'package:whatsapp_sender/presentation/ustils/responsive_screen.dart';
import 'package:whatsapp_sender/presentation/ustils/strings.dart';
import 'package:whatsapp_sender/presentation/ustils/translation_strings.dart';
import 'package:whatsapp_sender/presentation/ustils/utils_app.dart';
import 'package:whatsapp_sender/presentation/widgets/widget_btn_firebase.dart';
import 'package:whatsapp_sender/presentation/widgets/widget_tff_firebase.dart';

class PagePhoneSMSAuth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderPhoneSMSAuth>(
      builder: (context, results, child) {
        return PageAuthPhoneSmsProv();
      },
    );
  }
}

class PageAuthPhoneSmsProv extends StatefulWidget {
  @override
  _PageAuthPhoneSmsProvState createState() => _PageAuthPhoneSmsProvState();
}

class _PageAuthPhoneSmsProvState extends State<PageAuthPhoneSmsProv> {
  ProviderPhoneSMSAuth _provider;

  @override
  void initState() {
    super.initState();

    _provider = Provider.of<ProviderPhoneSMSAuth>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider.getCodeCountry("+972");
      _provider.getContactsPermission();
      _provider.checkLoginUserFirebase(context);
      _provider.isSuccess(null);
      _provider.isLoading(false);
      _provider.textError('');
      _provider.textOk('');
      _provider.sVerificationId(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.blueGrey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _title(),
                  UtilsApp.dividerHeight(context, 70),
                  _textFieldsData(),
                  UtilsApp.dividerHeight(context, 20),
                  _showErrors(),
                  UtilsApp.dividerHeight(context, 20),
                  _loading(),
                  UtilsApp.dividerHeight(context, 20),
                  _buttonSendSms(),
                  UtilsApp.dividerHeight(context, 20),
                  _buttonLogin(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return Text(
      Translations.of(context).getString(Strings.phone_auth),
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.greenAccent,
        fontSize: 40,
      ),
    );
  }

  Widget _textFieldsData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(
            bottom: ResponsiveScreen().heightMediaQuery(context, 20),
          ),
          child: !UtilsApp.isRTL(context)
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          Translations.of(context).getString(Strings.prefix),
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 15,
                          ),
                        ),
                        UtilsApp.dividerHeight(context, 5),
                        Container(
                          height:
                              ResponsiveScreen().heightMediaQuery(context, 60),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.green,
                              width: ResponsiveScreen()
                                  .widthMediaQuery(context, 2),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          child: CountryListPick(
                            pickerBuilder: (context, CountryCode countryCode) {
                              return Row(
                                children: [
                                  Image.asset(
                                    countryCode.flagUri,
                                    width: 40,
                                    height: 20,
                                    package: 'country_list_pick',
                                  ),
                                  Text(
                                    countryCode.dialCode,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.greenAccent,
                                    ),
                                  ),
                                ],
                              );
                            },
                            initialSelection: '+972',
                            onChanged: (CountryCode code) {
                              _provider.getCodeCountry(code.dialCode);
                            },
                          ),
                        ),
                      ],
                    ),
                    UtilsApp.dividerWidth(context, 5),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          Translations.of(context)
                              .getString(Strings.phone_number),
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 15,
                          ),
                        ),
                        UtilsApp.dividerHeight(context, 5),
                        Form(
                          key: _provider.formKeyPhoneGet,
                          child: WidgetTFFFirebase(
                            length: 10,
                            width: ResponsiveScreen()
                                .widthMediaQuery(context, 200),
                            controller: _provider.phoneControllerGet,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          Translations.of(context)
                              .getString(Strings.phone_number),
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 15,
                          ),
                        ),
                        UtilsApp.dividerHeight(context, 5),
                        Form(
                          key: _provider.formKeyPhoneGet,
                          child: WidgetTFFFirebase(
                            length: 10,
                            width: ResponsiveScreen()
                                .widthMediaQuery(context, 200),
                            controller: _provider.phoneControllerGet,
                          ),
                        ),
                      ],
                    ),
                    UtilsApp.dividerWidth(context, 5),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          Translations.of(context).getString(Strings.prefix),
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 15,
                          ),
                        ),
                        UtilsApp.dividerHeight(context, 5),
                        Container(
                          height:
                              ResponsiveScreen().heightMediaQuery(context, 60),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.green,
                              width: ResponsiveScreen()
                                  .widthMediaQuery(context, 2),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          child: CountryListPick(
                            pickerBuilder: (context, CountryCode countryCode) {
                              return Row(
                                children: [
                                  Text(
                                    countryCode.dialCode,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.greenAccent,
                                    ),
                                  ),
                                  Image.asset(
                                    countryCode.flagUri,
                                    width: 40,
                                    height: 20,
                                    package: 'country_list_pick',
                                  ),
                                ],
                              );
                            },
                            initialSelection: '+972',
                            onChanged: (CountryCode code) {
                              _provider.getCodeCountry(code.dialCode);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
        Form(
          key: _provider.formKeySmsGet,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: ResponsiveScreen().heightMediaQuery(context, 20),
            ),
            child: !UtilsApp.isRTL(context)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _tffSms(_provider.smsController1Get, _provider.focus1Get,
                          _provider.focus2Get, null),
                      UtilsApp.dividerWidth(context, 5),
                      _tffSms(_provider.smsController2Get, _provider.focus2Get,
                          _provider.focus3Get, _provider.focus1Get),
                      UtilsApp.dividerWidth(context, 5),
                      _tffSms(_provider.smsController3Get, _provider.focus3Get,
                          _provider.focus4Get, _provider.focus2Get),
                      UtilsApp.dividerWidth(context, 5),
                      _tffSms(_provider.smsController4Get, _provider.focus4Get,
                          _provider.focus5Get, _provider.focus3Get),
                      UtilsApp.dividerWidth(context, 5),
                      _tffSms(_provider.smsController5Get, _provider.focus5Get,
                          _provider.focus6Get, _provider.focus4Get),
                      UtilsApp.dividerWidth(context, 5),
                      _tffSms(_provider.smsController6Get, _provider.focus6Get,
                          null, _provider.focus5Get),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _tffSms(_provider.smsController6Get, _provider.focus6Get,
                          null, _provider.focus5Get),
                      UtilsApp.dividerWidth(context, 5),
                      _tffSms(_provider.smsController5Get, _provider.focus5Get,
                          _provider.focus6Get, _provider.focus4Get),
                      UtilsApp.dividerWidth(context, 5),
                      _tffSms(_provider.smsController4Get, _provider.focus4Get,
                          _provider.focus5Get, _provider.focus3Get),
                      UtilsApp.dividerWidth(context, 5),
                      _tffSms(_provider.smsController3Get, _provider.focus3Get,
                          _provider.focus4Get, _provider.focus2Get),
                      UtilsApp.dividerWidth(context, 5),
                      _tffSms(_provider.smsController2Get, _provider.focus2Get,
                          _provider.focus3Get, _provider.focus1Get),
                      UtilsApp.dividerWidth(context, 5),
                      _tffSms(_provider.smsController1Get, _provider.focus1Get,
                          _provider.focus2Get, null),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _showErrors() {
    return Container(
      alignment: Alignment.center,
      child: _provider.isSuccessGet == null
          ? null
          : _provider.textErrorGet != ''
              ? Text(
                  _provider.textErrorGet,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                )
              : _provider.textOkGet != ''
                  ? Text(
                      _provider.textOkGet,
                      style: const TextStyle(
                        color: Colors.lightGreenAccent,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : null,
    );
  }

  Widget _loading() {
    return _provider.isLoadingGet == true
        ? CircularProgressIndicator()
        : Container();
  }

  Widget _buttonSendSms() {
    return Padding(
      padding: EdgeInsets.only(
          left: ResponsiveScreen().widthMediaQuery(context, 20),
          right: ResponsiveScreen().widthMediaQuery(context, 20),
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: WidgetBtnFirebase(
        text: Translations.of(context).getString(Strings.send_sms),
        onTap: () => _provider.buttonClickSendSms(context),
      ),
    );
  }

  Widget _buttonLogin() {
    return Padding(
      padding: EdgeInsets.only(
          left: ResponsiveScreen().widthMediaQuery(context, 20),
          right: ResponsiveScreen().widthMediaQuery(context, 20),
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: WidgetBtnFirebase(
        text: Translations.of(context).getString(Strings.login_after_sms),
        onTap: () => _provider.buttonClickLogin(context),
      ),
    );
  }

  Widget _tffSms(TextEditingController num, FocusNode thisFocusNode,
      FocusNode nextFocusNode, FocusNode previousFocusNode) {
    return Container(
      width: ResponsiveScreen().widthMediaQuery(context, 48),
      height: ResponsiveScreen().widthMediaQuery(context, 48),
      alignment: Alignment.center,
      child: TextFormField(
        focusNode: thisFocusNode,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
        ],
        keyboardType: TextInputType.number,
        onChanged: (v) {
          if (num.text.length == 1) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          } else if (num.text.length == 0) {
            FocusScope.of(context).requestFocus(previousFocusNode);
          }
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Colors.green,
              width: ResponsiveScreen().widthMediaQuery(context, 2),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Colors.green,
              width: ResponsiveScreen().widthMediaQuery(context, 3),
            ),
          ),
        ),
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        controller: num,
        validator: (String value) {
          if (value.isEmpty) {
            return '';
          }
          return null;
        },
        style: TextStyle(
          fontFamily: 'Avenir',
          color: Colors.greenAccent,
          fontSize: 17,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
        ),
      ),
    );
  }
}

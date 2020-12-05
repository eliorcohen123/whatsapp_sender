import 'package:clipboard/clipboard.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_sender/core/constants/constants_images.dart';
import 'package:whatsapp_sender/presentation/state_management/provider/provider_whatsapp_send.dart';
import 'package:whatsapp_sender/presentation/ustils/responsive_screen.dart';
import 'package:whatsapp_sender/presentation/ustils/strings.dart';
import 'package:whatsapp_sender/presentation/ustils/translation_strings.dart';
import 'package:whatsapp_sender/presentation/ustils/utils_app.dart';
import 'package:whatsapp_sender/presentation/ustils/validations.dart';

class PageWhatsAppSend extends StatelessWidget {
  final String phoneNumber;

  const PageWhatsAppSend({Key key, this.phoneNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderWhatsAppSend>(
      builder: (context, results, child) {
        return PageWhatsAppSendProv(phoneNumber: phoneNumber);
      },
    );
  }
}

class PageWhatsAppSendProv extends StatefulWidget {
  final String phoneNumber;

  const PageWhatsAppSendProv({Key key, this.phoneNumber}) : super(key: key);

  @override
  _PageWhatsAppSendProvState createState() => _PageWhatsAppSendProvState();
}

class _PageWhatsAppSendProvState extends State<PageWhatsAppSendProv>
    with WidgetsBindingObserver {
  ProviderWhatsAppSend _provider;

  @override
  void initState() {
    super.initState();

    _provider = Provider.of<ProviderWhatsAppSend>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      WidgetsBinding.instance.addObserver(this);
      FlutterClipboard.paste().then((value) {
        if (Validations().validatePhone(value)) {
          _provider.showDialogWhatsApp(context, value);
        }
      });
      _provider.getCodeCountry("+972");
    });
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _provider.phoneControllerGet.clear();
      _provider.focusNodeGet.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    _provider.pushContactsToFirebase(widget.phoneNumber);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueAccent,
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                UtilsApp.dividerHeight(context, 20),
                _share(context),
                UtilsApp.dividerHeight(context, 150),
                _title(),
                UtilsApp.dividerHeight(context, 70),
                _textFieldsData(),
                UtilsApp.dividerHeight(context, 20),
                _buttonPassWhatsApp(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _share(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          children: [
            Text(
              Translations.of(context).getString(Strings.share),
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            UtilsApp.dividerHeight(context, 5),
            InkWell(
              customBorder: CircleBorder(),
              onTap: () => _provider.shareApp(context),
              child: Container(
                margin: EdgeInsets.all(3),
                child: Image.asset(ConstantsImages.share, scale: 12),
              ),
            ),
          ],
        ),
        UtilsApp.dividerWidth(context, 20),
      ],
    );
  }

  Widget _title() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        Translations.of(context).getString(Strings.enter_a_message),
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 22),
      ),
    );
  }

  Widget _textFieldsData() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: !UtilsApp.isRTL(context)
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      Translations.of(context).getString(Strings.prefix),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    UtilsApp.dividerHeight(context, 5),
                    Container(
                      height: ResponsiveScreen().heightMediaQuery(context, 40),
                      width: ResponsiveScreen().widthMediaQuery(context, 108),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: CountryListPick(
                        pickerBuilder: (context, CountryCode countryCode) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                UtilsApp.dividerWidth(context, 20),
                _columnTextField(
                    Translations.of(context).getString(Strings.phone_number),
                    _provider.phoneControllerGet,
                    200,
                    10),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _columnTextField(
                    Translations.of(context).getString(Strings.phone_number),
                    _provider.phoneControllerGet,
                    200,
                    10),
                UtilsApp.dividerWidth(context, 20),
                Column(
                  children: [
                    Text(
                      Translations.of(context).getString(Strings.prefix),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    UtilsApp.dividerHeight(context, 5),
                    Container(
                      height: ResponsiveScreen().heightMediaQuery(context, 40),
                      width: ResponsiveScreen().widthMediaQuery(context, 108),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: CountryListPick(
                        pickerBuilder: (context, CountryCode countryCode) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
    );
  }

  Widget _columnTextField(String text,
      TextEditingController textEditingController, double width, int length) {
    return Column(
      children: [
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        UtilsApp.dividerHeight(context, 5),
        Container(
          height: ResponsiveScreen().heightMediaQuery(context, 40),
          width: width,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveScreen().widthMediaQuery(context, 10),
            vertical: ResponsiveScreen().heightMediaQuery(context, 10),
          ),
          child: TextFormField(
            focusNode: _provider.focusNodeGet,
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            controller: textEditingController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              LengthLimitingTextInputFormatter(length),
            ],
            validator: (String value) {
              if (value.isEmpty) {
                return Translations.of(context)
                    .getString(Strings.please_enter_some_text);
              }
              return null;
            },
            style: const TextStyle(
              fontSize: 15,
              color: Colors.greenAccent,
            ),
            decoration: InputDecoration(
              border: new OutlineInputBorder(
                borderRadius: const BorderRadius.all(const Radius.circular(10)),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              hintStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buttonPassWhatsApp() {
    return Container(
      height: ResponsiveScreen().heightMediaQuery(context, 50),
      width: ResponsiveScreen().widthMediaQuery(context, 250),
      child: RaisedButton(
        highlightElevation: 0.0,
        splashColor: Colors.greenAccent,
        highlightColor: Colors.lightGreenAccent,
        elevation: 0.0,
        color: Colors.greenAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Text(
          Translations.of(context).getString(Strings.start_conversation),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        onPressed: () => {
          _provider.buttonClickSendWhatsApp(),
        },
      ),
    );
  }
}

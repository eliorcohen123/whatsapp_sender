import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_sender/presentation/pages/page_auth_phone_sms.dart';
import 'package:whatsapp_sender/presentation/state_management/provider/provider_phone_sms_auth.dart';
import 'package:whatsapp_sender/presentation/state_management/provider/provider_whatsapp_send.dart';
import 'presentation/ustils/translations_delegate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProviderPhoneSMSAuth>(
          create: (context) => ProviderPhoneSMSAuth(),
        ),
        ChangeNotifierProvider<ProviderWhatsAppSend>(
          create: (context) => ProviderWhatsAppSend(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        localizationsDelegates: [
          const TranslationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', ''),
          Locale('he', ''),
        ],
        home: PagePhoneSMSAuth(),
      ),
    );
  }
}

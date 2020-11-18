import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:whatsapp_sender/presentation/ustils/responsive_screen.dart';
import 'package:whatsapp_sender/presentation/ustils/strings.dart';
import 'package:whatsapp_sender/presentation/ustils/translation_strings.dart';
import 'package:whatsapp_sender/presentation/ustils/utils_app.dart';

class WidgetTFFFirebase extends StatelessWidget {
  final int length;
  final double width;
  final TextEditingController controller;

  const WidgetTFFFirebase({
    Key key,
    @required this.length,
    @required this.width,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveScreen().heightMediaQuery(context, 60),
      width: width,
      child: TextFormField(
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        key: key,
        controller: controller,
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
          fontSize: 20,
          color: Colors.greenAccent,
        ),
        decoration: InputDecoration(
          hintStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
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
      ),
    );
  }
}

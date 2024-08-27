import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:translator/translator.dart';

extension TranslateString on String {
  static final supportedLanguages = {
    'en': 'English',
    'ee': 'Ewe',
    'ak': 'Akan',
  };

  Future<String> _translate(String targetLanguage) async {
    final translator = GoogleTranslator();
    try {
      var translation = await translator.translate(this, to: targetLanguage);
      return translation.text;
    } catch (e) {
      // print('Translation error: $e');
      return this;
    }
  }

  Widget translate(
    String targetLanguage, {
    double? fontSize,
    TextAlign? textAlign,
    int? maxLines,
    FontWeight? fontWeight,
    TextOverflow? textOverflow,
    FontStyle? fontStyle,
    Color? color,
    String? fontFamily,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return FutureBuilder<String>(
      future: _translate(targetLanguage),
      builder: (context, snapshot) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
              left?.h ?? 0, top?.h ?? 0, right?.h ?? 0, bottom?.h ?? 0),
          child: Text(snapshot.data ?? this,
              textAlign: textAlign,
              maxLines: maxLines,
              style: TextStyle(
                  overflow: textOverflow,
                  color: color ?? Colors.black,
                  fontWeight: fontWeight,
                  fontSize: fontSize?.sp ?? 18.sp,
                  fontStyle: fontStyle,
                  fontFamily: fontFamily ?? 'NotoSans')),
        );
      },
    );
  }

  Future<String> translateToString(String targetLanguage) async {
    final translator = GoogleTranslator();
    try {
      var translation = await translator.translate(this, to: targetLanguage);
      return translation.text;
    } catch (e) {
      // print('Translation error: $e');
      return this;
    }
  }

  Future<String> translateString(String targetLanguage) async {
    final translator = GoogleTranslator();
    try {
      var translation = await translator.translate(this, to: targetLanguage);
      return translation.text;
    } catch (e) {
      // If translation fails, return the original string
      return this;
    }
  }
}

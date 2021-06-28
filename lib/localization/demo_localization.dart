import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kisanweb/Helpers/helper.dart';
import 'package:localstorage/localstorage.dart';

import 'package:path_provider/path_provider.dart';

class DemoLocalization {
  DemoLocalization(this.locale);

  final Locale locale;
  final LocalStorage storage = new LocalStorage('localstorage_app');

  static DemoLocalization of(BuildContext context) {
    return Localizations.of<DemoLocalization>(context, DemoLocalization);
  }

  Map<String, String> _localizedValues;

  Future<void> load() async {

  /*  final directory = await getExternalStorageDirectory();
    final path = await directory.path;

    File filePath = File('$path/${locale.languageCode}.json');
    final jsonStringValues = await filePath.readAsString();
    print(jsonStringValues);
*/
    final jsonStringValues = storage.getItem(locale.languageCode);
    /*
    String jsonStringValues =
    await rootBundle.loadString('lib/lang/${locale.languageCode}.json');*/


    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    _localizedValues =
        mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  String translate(String key) {
    return _localizedValues[key];
  }

  // static member to have simple access to the delegate from Material App
  static const LocalizationsDelegate<DemoLocalization> delegate =
  _DemoLocalizationsDelegate();
}

class _DemoLocalizationsDelegate
    extends LocalizationsDelegate<DemoLocalization> {
  const _DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi', 'mr'].contains(locale.languageCode);
  }

  @override
  Future<DemoLocalization> load(Locale locale) async {
    DemoLocalization localization = new DemoLocalization(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(LocalizationsDelegate<DemoLocalization> old) => false;
}
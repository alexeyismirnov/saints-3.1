import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_toolkit/flutter_toolkit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:jiffy/jiffy.dart';

import 'homepage.dart';
import 'about_page.dart';

import 'favs_page.dart';
import 'search_page.dart';
import 'globals.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  await Jiffy.setLocale("ru");

  await GlobalPath.ensureInitialized();

  await ConfigParam.initSharedParams();
  ConfigParamExt.favs = ConfigParam<List<String>>('favs', initValue: []);
  ConfigParamExt.search = ConfigParam<String>('search', initValue: '');

  await DB.prepare(basename: "assets/db", filename: "saints.sqlite");

  await rateMyApp.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(EasyLocalization(
      supportedLocales: const [Locale('ru', '')],
      path: 'assets/translations',
      startLocale: const Locale('ru', ''),
      child: RestartWidget(ContainerPage(tabs: [
        AnimatedTab(icon: const Icon(Icons.home), title: 'Жития', content: HomePage()),
        AnimatedTab(icon: const Icon(Icons.favorite), title: 'Закладки', content: FavsPage()),
        AnimatedTab(icon: const Icon(Icons.search), title: 'Поиск', content: SearchPage()),
        AnimatedTab(
            icon: const Icon(Icons.info_outlined), title: 'Приложения', content: AboutPage()),
      ]))));
}

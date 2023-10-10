import 'package:flutter/cupertino.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:flutter_toolkit/flutter_toolkit.dart';

import 'dart:core';

class DateChangedNotification extends Notification {
  late DateTime newDate;
  DateChangedNotification(this.newDate) : super();
}


extension ConfigParamExt on ConfigParam {
  static var favs;
  static var search;
  static var ver_5_0;
}

RateMyApp rateMyApp = RateMyApp(
  preferencesPrefix: 'rate_saints',
  minDays: 3,
  minLaunches: 5,
  remindDays: 5,
  remindLaunches: 5,
);


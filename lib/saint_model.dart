import 'package:sqflite/sqflite.dart';
import 'package:supercharged/supercharged.dart';
import 'package:flutter_toolkit/flutter_toolkit.dart';

import 'dart:async';

import 'church_day.dart';

class Saint {
  late int id;
  late int day;
  late int month;
  late String name;
  late String zhitie;
  late int hasIcon;

  bool get has_icon => hasIcon == 1;

  Saint.fromMap(Map<String, Object?> data) {
    id = data["id"] as int;
    name = data["name"] as String;
    zhitie = data["zhitie"] as String;
    day = (data["day"] ?? 0) as int;
    month = (data["month"] ?? 0) as int;
    hasIcon = data["has_icon"] as int;
  }
}

class SaintModel {
  static Database? db;

  static Future<List<Saint>> _addSaints(DateTime date) async {
    List<Saint> result = [];

    List<Map<String, Object?>> data = await db!.query("app_saint",
        columns: ['id', 'name', 'zhitie', 'has_icon'],
        where: "day=${date.day} AND month=${date.month}");

    for (final Map<String, Object?> row in data) {
      result.add(Saint.fromMap(row));
    }

    data = await db!.rawQuery(
        'SELECT app_saint.id,link_saint.name,app_saint.zhitie,app_saint.has_icon ' +
            'FROM app_saint JOIN link_saint ON ' +
            'app_saint.id = link_saint.id AND link_saint.day=${date.day} AND link_saint.month=${date.month}');

    for (final Map<String, Object?> row in data) {
      result.add(Saint.fromMap(row));
    }

    return result;
  }

  static Future<List<Saint>> getSaints(DateTime date) async {
    final cal = ChurchCalendar.fromDate(date);
    List<Saint> result = [];

    db ??= await DB.open("saints.sqlite");

    final days = cal.getDays(date);

    for (var d in days) {
      final id = d.id;

      List<Map<String, Object?>> data = await db!
          .query("app_saint", columns: ['id', 'name', 'zhitie', 'has_icon'], where: "id=$id");

      for (final Map<String, Object?> row in data) {
        result.add(Saint.fromMap(row));
      }
    }

    if (cal.isLeapYear) {
      if (date.isBetween(cal.leapStart, cal.leapEnd - 1.days)) {
        result.addAll(await _addSaints(date + 1.days));
      } else if (date == cal.leapEnd) {
        result.addAll(await _addSaints(DateTime(cal.year, 2, 29)));
      } else {
        result.addAll(await _addSaints(date));
      }
    } else {
      result.addAll(await _addSaints(date));
      if (date == cal.leapEnd) {
        result.addAll(await _addSaints(DateTime(2000, 2, 29)));
      }
    }

    return result;
  }

  static Future<List<Saint>> getFavSaints(List<String> ids) async {
    List<Saint> result = [];

    db ??= await DB.open("saints.sqlite");

    for (String idStr in ids) {
      final id = int.parse(idStr);

      List<Map<String, Object?>> data = await db!
          .query("app_saint", columns: ['id', 'name', 'zhitie', 'has_icon'], where: "id=$id");

      result.add(Saint.fromMap(data.first));
    }

    return result;
  }

  static Future<List<Saint>> getSaintsByName(String name) async {
    List<Saint> result = [];

    db ??= await DB.open("saints.sqlite");

    List<Map<String, Object?>> data = await db!.query("app_saint",
        columns: ['id', 'day', 'month', 'name', 'zhitie', 'has_icon'],
        where: 'name LIKE "%$name%"');

    for (final Map<String, Object?> row in data) {
      result.add(Saint.fromMap(row));
    }

    data = await db!.rawQuery(
        'SELECT app_saint.id,link_saint.day,link_saint.month,link_saint.name,app_saint.zhitie,app_saint.has_icon ' +
            'FROM app_saint JOIN link_saint ON ' +
            'app_saint.id = link_saint.id AND link_saint.name LIKE "%$name%"');

    for (final Map<String, Object?> row in data) {
      result.add(Saint.fromMap(row));
    }

    return result;
  }
}

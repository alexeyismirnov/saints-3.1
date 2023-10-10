import 'package:supercharged/supercharged.dart';

enum FeastType { none, noSign, sixVerse, doxology, polyeleos, vigil, great }

class ChurchDay {
  int id;
  String name;
  FeastType type;
  DateTime? date;

  ChurchDay(this.date, this.name, {this.id = 0, this.type = FeastType.none});
}

class ChurchCalendar {
  late int year;
  late DateTime greatLentStart, pascha;
  late DateTime leapStart, leapEnd;
  late bool isLeapYear;

  List<ChurchDay> days = [];

  static Map<int, ChurchCalendar> calendars = {};

  factory ChurchCalendar.fromDate(DateTime d) {
    var year = d.year;

    if (!ChurchCalendar.calendars.containsKey(year)) {
      ChurchCalendar.calendars[year] = ChurchCalendar(d);
    }

    return ChurchCalendar.calendars[year]!;
  }

  ChurchCalendar(DateTime d) {
    year = d.year;

    pascha = paschaDay(year);
    greatLentStart = pascha - 48.days;

    leapStart = DateTime(year, 2, 29);
    leapEnd = DateTime(year, 3, 13);
    isLeapYear = (year % 400) == 0 || ((year % 4 == 0) && (year % 100 != 0));

    initDays();
  }

  initDays() {
    days.addAll([
      ChurchDay(greatLentStart - 2.days, "saturdayOfFathers", id: 100009),
      ChurchDay(greatLentStart + 6.days, "sunday1GreatLent", id: 100006),
      ChurchDay(greatLentStart + 13.days, "sunday2GreatLent", id: 11274),
      ChurchDay(greatLentStart + 13.days, "synaxisFathersKievCaves", id: 100113),
      ChurchDay(greatLentStart + 20.days, "sunday3GreatLent", id: 100007),
      ChurchDay(greatLentStart + 27.days, "sunday4GreatLent", id: 4121),
      ChurchDay(greatLentStart + 33.days, "saturdayAkathist", id: 100008),
      ChurchDay(greatLentStart + 34.days, "sunday5GreatLent", id: 4141),
      ChurchDay(greatLentStart + 40.days, "lazarusSaturday", id: 100010),
      ChurchDay(pascha - 7.days, "palmSunday", id: 100001, type: FeastType.great),
      ChurchDay(pascha, "pascha", id: 100000, type: FeastType.great),
      ChurchDay(pascha + 2.days, "theotokosIveron", id: 2250),
      ChurchDay(pascha + 5.days, "theotokosLiveGiving", id: 100100),
      ChurchDay(pascha + 24.days, "theotokosDubenskaya", id: 100101),
      ChurchDay(pascha + 39.days, "ascension", id: 100002, type: FeastType.great),
      ChurchDay(pascha + 42.days, "theotokosChelnskaya", id: 100103),
      ChurchDay(pascha + 42.days, "firstCouncil", id: 100107),
      ChurchDay(pascha + 49.days, "pentecost", id: 100003, type: FeastType.great),
      ChurchDay(pascha + 56.days, "theotokosWall", id: 100105),
      ChurchDay(pascha + 56.days, "theotokosSevenArrows", id: 100106),
      ChurchDay(pascha + 61.days, "theotokosTabynsk", id: 100108),
      ChurchDay(pascha + 63.days, "allRussianSaints", id: 100111),
      ChurchDay(nearestSunday(DateTime(year, 2, 7)), "newMartyrsOfRussia", id: 100109),
      ChurchDay(nearestSunday(DateTime(year, 7, 29)), "holyFathersSixCouncils", id: 100110),
      ChurchDay(nearestSunday(DateTime(year, 10, 24)), "holyFathersSeventhCouncil", id: 100112)
    ]);

    final nativity = DateTime(year, 1, 7);

    if (nativity.weekday != DateTime.sunday) {
      days.add(ChurchDay(nearestSundayBefore(nativity), "sundayBeforeNativity", id: 100005));
    }

    final nativityNextYear = DateTime(year + 1, 1, 7);

    if (nativityNextYear.weekday == DateTime.sunday) {
      days.add(
          ChurchDay(nearestSundayBefore(nativityNextYear), "sundayBeforeNativity", id: 100005));
    }

    days.add(ChurchDay(nearestSundayBefore(nativityNextYear) - 7.days, "sundayOfForefathers",
        id: 100004));

    days.addAll([
      ChurchDay(DateTime(year, 1, 7), "nativityOfGod", type: FeastType.great),
      ChurchDay(DateTime(year, 1, 19), "theophany", type: FeastType.great),
      ChurchDay(DateTime(year, 2, 15), "meetingOfLord", type: FeastType.great),
      ChurchDay(DateTime(year, 4, 7), "annunciation", type: FeastType.great),
      ChurchDay(DateTime(year, 7, 12), "peterAndPaul", type: FeastType.great),
      ChurchDay(DateTime(year, 8, 19), "transfiguration", type: FeastType.great),
      ChurchDay(DateTime(year, 8, 28), "dormition", type: FeastType.great),
      ChurchDay(DateTime(year, 9, 21), "nativityOfTheotokos", type: FeastType.great),
      ChurchDay(DateTime(year, 9, 27), "exaltationOfCross", type: FeastType.great),
      ChurchDay(DateTime(year, 12, 4), "entryIntoTemple", type: FeastType.great),
      ChurchDay(DateTime(year, 1, 14), "circumcision", type: FeastType.great),
      ChurchDay(DateTime(year, 10, 14), "veilOfTheotokos", type: FeastType.great),
      ChurchDay(DateTime(year, 7, 7), "nativityOfJohn", type: FeastType.great),
      ChurchDay(DateTime(year, 9, 11), "beheadingOfJohn", type: FeastType.great),
    ]);
  }

  List<ChurchDay> getDays(DateTime d) => (days.where((e) => e.date == d && e.id != 0)).toList();

  bool isGreatFeast(DateTime d) =>
      (days.where((e) => e.date == d && e.type == FeastType.great)).isNotEmpty;
}

extension ChurchCalendarFunc on ChurchCalendar {
  DateTime paschaDay(int year) {
    final a = (19 * (year % 19) + 15) % 30;
    final b = (2 * (year % 4) + 4 * (year % 7) + 6 * a + 6) % 7;

    return ((a + b > 10) ? DateTime(year, 4, a + b - 9) : DateTime(year, 3, 22 + a + b)) + 13.days;
  }

  DateTime nearestSundayBefore(DateTime d) => d - d.weekday.days;

  DateTime nearestSundayAfter(DateTime d) =>
      d.weekday == DateTime.sunday ? d + 7.days : d + (7 - d.weekday).days;

  DateTime nearestSunday(DateTime d) {
    switch (d.weekday) {
      case DateTime.sunday:
        return d;

      case DateTime.monday:
      case DateTime.tuesday:
      case DateTime.wednesday:
        return nearestSundayBefore(d);

      default:
        return nearestSundayAfter(d);
    }
  }
}

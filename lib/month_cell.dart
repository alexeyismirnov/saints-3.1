import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_toolkit/flutter_toolkit.dart';

import 'church_day.dart';

class MonthViewCell extends StatelessWidget {
  final DateTime date;

  const MonthViewCell(this.date);

  @override
  Widget build(BuildContext context) {
    final config = MonthViewConfig.of(context)!;
    final cal = ChurchCalendar.fromDate(date);

    final now = DateTime.now();
    final today = DateTime.utc(now.year, now.month, now.day);

    Color themeColor = Theme.of(context).textTheme.titleLarge!.color!;
    Color textColor = themeColor;
    FontWeight fontWeight = FontWeight.normal;

    if (cal.isGreatFeast(date)) {
      fontWeight = FontWeight.bold;
      textColor = Colors.red;
    }

    if (date == today) {
      textColor = Colors.white;
    }

    Widget content = Center(
        child: AutoSizeText("${date.day}",
            maxLines: 1,
            minFontSize: 5,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: fontWeight, color: textColor)));

    Widget wrapper;

    if (date == today) {
      wrapper = SizedBox(
          width: config.cellWidth,
          height: config.cellHeight,
          child: Container(
              width: config.cellWidth,
              height: config.cellHeight,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: content));
    } else {
      wrapper = SizedBox(width: config.cellWidth, height: config.cellHeight, child: content);
    }

    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.pop(context, date);
        },
        child: wrapper);
  }
}

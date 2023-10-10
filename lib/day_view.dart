import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_toolkit/flutter_toolkit.dart';
import 'package:launch_review/launch_review.dart';

import 'globals.dart';
import 'saint_list.dart';
// import 'month_cell.dart';

class DayView extends StatefulWidget {
  final DateTime date, dateOld;

  DayView({Key? key, required this.date})
      : dateOld = date.subtract(const Duration(days: 13)),
        super(key: key);

  @override
  _DayViewState createState() => _DayViewState();
}

class _DayViewState extends State<DayView> {
  DateTime get currentDate => widget.date;
  DateTime get currentDateOS => widget.dateOld;

  Widget _getActions() {
    List<PopupMenuEntry> contextMenu = [
      PopupMenuItem(
          child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                AppThemeDialog().show(context);
              },
              child:
              const ListTile(leading: Icon(Icons.color_lens, size: 30.0), title: Text('Фон')))),
      PopupMenuItem(
          child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                FontSizeDialog().show(context).then((value) => setState(() {}));
              },
              child: const ListTile(
                  leading: Icon(Icons.zoom_in_outlined, size: 30.0), title: Text('Шрифт')))),
      PopupMenuItem(
          child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                LaunchReview.launch(androidAppId: "com.alexey.test", iOSAppId: "1343569925");
              },
              child: const ListTile(
                  leading: Icon(Icons.rate_review_outlined, size: 30.0), title: Text('Отзыв...')))),
    ];

    return Align(
        alignment: Alignment.topCenter,
        child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SizedBox(
                width: 40,
                height: 40,
                child: PopupMenuButton(
                  icon: const Icon(Icons.arrow_circle_down, size: 25),
                  itemBuilder: (_) => contextMenu,
                ))));
  }

  @override
  Widget build(BuildContext context) {
    final df1 = DateFormat.yMMMMEEEEd('ru');
    final df2 = DateFormat.yMMMMd('ru');

    var dateWidget = GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Icon(Icons.calendar_today, size: 30.0),
              const SizedBox(width: 10),
              Expanded(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(df1.format(currentDate).capitalize(),
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            minFontSize: 5,
                            style: Theme.of(context).textTheme.titleLarge),
                        AutoSizeText("${df2.format(currentDateOS)} (ст. ст.)",
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            minFontSize: 5,
                            style: Theme.of(context).textTheme.subtitle1),
                      ]))
            ]),
        onTap: () {

          /*
          var dialog = AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              contentPadding: const EdgeInsets.all(5.0),
              insetPadding: const EdgeInsets.all(0.0),
              content: MonthViewConfig(
                  lang: 'ru',
                  child: MonthContainer(currentDate, cellBuilder: (date) => MonthViewCell(date))));

          dialog.show(context).then((newDate) {
            if (newDate != null) {
              DateChangedNotification(newDate).dispatch(context);
            }
          });

           */

        });

    final key = "${currentDate.toIso8601String()} - ${ConfigParam.fontSize.val()}";

    return NestedScrollView(
        key: ValueKey(key),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [],
        body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
              backgroundColor: Colors.transparent,
              pinned: true,
              title: dateWidget,
              actions: [_getActions()]),
          SliverFillRemaining(child: SaintList(date: currentDate))
        ]));
  }
}

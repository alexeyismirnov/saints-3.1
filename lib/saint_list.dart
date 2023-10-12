import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

import 'package:flutter_toolkit/flutter_toolkit.dart';
import 'package:easy_localization/easy_localization.dart';

import 'saint_model.dart';
import 'saint_details.dart';

class SaintList extends StatefulWidget {
  final DateTime? date;
  final List<String>? ids;
  final String? search;

  SaintList({this.date, this.ids, this.search});

  @override
  SaintListState createState() => SaintListState();
}

class SaintListState extends State<SaintList> {
  late List<Saint> saintData;

  Widget buildRow(Saint s, int index) {
    var day = s.day;
    var month = s.month;
    Widget name;

    final fontSize = ConfigParam.fontSize.val();
    final style = Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: fontSize);

    if (day != 0) {
      if (day == 29 && month == 2) {
        day = 13;
        month = 3;
      }

      final dt = DateTime(DateTime.now().year, month, day);
      final format = DateFormat.MMMMd('ru');

      name = RichText(
          text: TextSpan(text: '', style: style, children: [
        TextSpan(text: format.format(dt), style: style.copyWith(color: Colors.red)),
        const TextSpan(text: '   '),
        TextSpan(text: s.name)
      ]));
    } else {
      name = Text(s.name, style: style);
    }

    return GestureDetector(
        child: Container(
            decoration: const BoxDecoration(color: Colors.transparent),
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                s.has_icon
                    ? Image.asset(
                        'assets/icons/${s.id}.jpg',
                        width: 100.0,
                        height: 100.0,
                      )
                    : Container(),
                Expanded(child: Container(padding: const EdgeInsets.only(left: 10.0), child: name))
              ],
            )),
        onTap: () {
          if (widget.ids != null || widget.search != null) {
            SaintDetail([s], 0).push(context);
          } else {
            SaintDetail(saintData, index).push(context);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    Future<List<Saint>>? f;

    if (widget.date != null) {
      f = SaintModel.getSaints(widget.date!);
    } else if (widget.ids != null) {
      f = SaintModel.getFavSaints(widget.ids!);
    } else if (widget.search != null && (widget.search?.length ?? 0) > 2) {
      f = SaintModel.getSaintsByName(widget.search!);
    }

    return FutureBuilder(
        future: f!,
        builder: (context, AsyncSnapshot<List<Saint>> snapshot) {
          if (!snapshot.hasData) return Container();

          saintData = snapshot.data!;

          return CustomScrollView(slivers: [
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) => buildRow(snapshot.data![index], index),
                    childCount: min(snapshot.data!.length, 100)))
          ]);
        });
  }
}

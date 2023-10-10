import 'package:flutter/material.dart';

import 'saint_details_page.dart';
import 'saint_model.dart';

class SaintDetail extends StatefulWidget {
  final List<Saint> saints;
  final int index;

  SaintDetail(this.saints, this.index);

  @override
  _SaintDetailState createState() =>  _SaintDetailState();
}

class _SaintDetailState extends State<SaintDetail> {
  @override
  Widget build(BuildContext context) {
    if (widget.saints.length == 1) {
      return Scaffold(body: SaintDetailPage(widget.saints[0]));

    } else {
      return Scaffold(
          body: DefaultTabController(
              initialIndex: widget.index,
              length: widget.saints.length,
              child: TabBarView(
                children:
                widget.saints.map((Saint s) => SaintDetailPage(s)).toList(),
              )));
    }
  }
}

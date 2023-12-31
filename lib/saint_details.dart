import 'package:flutter/material.dart';

import 'saint_details_page.dart';
import 'saint_model.dart';

class SaintDetail extends StatefulWidget {
  final List<Saint> saints;
  final int index;

  SaintDetail(this.saints, this.index);

  @override
  _SaintDetailState createState() => _SaintDetailState();
}

class _SaintDetailState extends State<SaintDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
            initialIndex: widget.index,
            length: widget.saints.length,
            child: (widget.saints.length == 1)
                ? SaintDetailPage(widget.saints[0])
                : TabBarView(
                    children: widget.saints.map((Saint s) => SaintDetailPage(s)).toList(),
                  )));
  }
}

import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';
import 'package:easy_localization/easy_localization.dart';

import 'globals.dart';
import 'day_view.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int initialPage = 100000;
  late DateTime date;
  late PageController _controller;

  @override
  void initState() {
    super.initState();

    _controller = PageController(initialPage: initialPage);
    setDate(DateTime.now());

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (rateMyApp.shouldOpenDialog) {
      Future.delayed(
          Duration.zero,
          () =>
              rateMyApp.showRateDialog(context, title: "title".tr(), message: "please_rate".tr()));
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        final dt = DateTime.now();

        if (date != DateTime.utc(dt.year, dt.month, dt.day)) {
          setDate(dt);
        }

        break;
      default:
        break;
    }
  }

  void setDate(DateTime d) {
    setState(() {
      date = DateTime(d.year, d.month, d.day);
      if (_controller.hasClients) {
        initialPage = _controller.page!.round();
      }
    });
  }

  @override
  Widget build(BuildContext context) => SafeArea(
      child: NotificationListener<Notification>(
          onNotification: (n) {
            if (n is DateChangedNotification) setDate(n.newDate);
            return true;
          },
          child: PageView.builder(
              controller: _controller,
              itemBuilder: (BuildContext context, int index) =>
                  DayView(date: date + (index - initialPage).days))));
}

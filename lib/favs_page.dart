import 'package:flutter/material.dart';

import 'dart:async';

import 'saint_list.dart';
import 'globals.dart';

class FavsPage extends StatefulWidget {
  @override
  _FavsPageState createState() => _FavsPageState();
}

class _FavsPageState extends State<FavsPage> {
  StreamSubscription? favsChanged;

  @override
  void initState() {
    super.initState();
    favsChanged = ConfigParamExt.favs.onChange((_) => setState(() {}));
  }

  @override
  void dispose() {
    favsChanged?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
      child: ConfigParamExt.favs.val().length == 0
          ? Center(child: Text("Нет закладок", style: Theme.of(context).textTheme.titleMedium))
          : NestedScrollView(
              key: ValueKey(Object.hashAll(ConfigParamExt.favs.val())),
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
                    const SliverAppBar(
                        backgroundColor: Colors.transparent,
                        pinned: false,
                        title: Text('Закладки'),
                        actions: [])
                  ],
              body: SaintList(ids: ConfigParamExt.favs.val())));
}

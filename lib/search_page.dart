import 'package:flutter/material.dart';
import 'package:flutter_toolkit/flutter_toolkit.dart';

import 'dart:async';

import 'globals.dart';
import 'saint_list.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _controller;
  StreamSubscription? searchChanged;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ConfigParamExt.search.val());
    searchChanged = ConfigParamExt.search.onChange((_) => setState(() {}));
  }

  @override
  void dispose() {
    searchChanged?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
              SliverAppBar(
                  backgroundColor: Colors.transparent,
                  pinned: false,
                  title: TextField(
                      controller: _controller,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        hintText: "Имя святого",
                      ),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontSize: ConfigParam.fontSize.val()),
                      onChanged: (String name) => ConfigParamExt.search.set(name)))
            ],
        body: ConfigParamExt.search.val().length <= 2
            ? Container()
            : SaintList(search: ConfigParamExt.search.val()));
  }
}

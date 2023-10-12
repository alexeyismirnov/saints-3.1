import 'package:flutter/material.dart';

import 'dart:core';

import 'package:flutter_toolkit/flutter_toolkit.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:share_plus/share_plus.dart';

import 'saint_model.dart';
import 'saint_popup.dart';
import 'globals.dart';

class SaintDetailPage extends StatefulWidget {
  final Saint saint;
  SaintDetailPage(this.saint);

  @override
  _SaintDetailPageState createState() => _SaintDetailPageState();
}

class _SaintDetailPageState extends State<SaintDetailPage> {
  late ScrollController _scrollController;
  late String markdown;
  double _appBarHeight = 0.0;

  @override
  void initState() {
    super.initState();

    markdown = html2md
        .convert(widget.saint.zhitie)
        .trim()
        .replaceAll(RegExp(r'\n '), '\n')
        .replaceAll('\\', '')
        .replaceAll('\u00AD', '');

    markdown += "\n";

    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset + 10.0 > _appBarHeight - kToolbarHeight;
  }

  bool get _showDots {
    return !_scrollController.hasClients ||
        _scrollController.hasClients && _scrollController.offset < 30.0;
  }

  Widget _getActions() {
    List<String> favs = List<String>.from(ConfigParamExt.favs.val());
    bool isFaved = favs.contains(widget.saint.id.toString());

    List<PopupMenuEntry> contextMenu = [
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

          if (isFaved) {
            favs.removeWhere((String id) => id == widget.saint.id.toString());
          } else {
            favs.add(widget.saint.id.toString());
          }

          setState(() => ConfigParamExt.favs.set(favs));
        },
        child: ListTile(
          leading: isFaved
              ? const Icon(Icons.bookmark, size: 30.0)
              : const Icon(Icons.bookmark_border, size: 30.0),
          title: const Text('Закладка'),
        ),
      )),
      PopupMenuItem(
          child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Share.share(markdown);
              },
              child: const ListTile(
                  leading: Icon(Icons.share, size: 30.0), title: Text('Поделиться')))),
    ];

    return PopupMenuButton(
      icon: const Icon(Icons.arrow_circle_down, size: 25),
      itemBuilder: (_) => contextMenu,
    );
  }

  @override
  Widget build(BuildContext context) {
    final TabController? controller = DefaultTabController.of(context);

    if (_appBarHeight == 0.0) {
      _appBarHeight = widget.saint.has_icon ? 400.0 : 120.0;
      if (controller != null) _appBarHeight += 40.0;
    }

    final _textMinHeight = MediaQuery.of(context).size.height - _appBarHeight;

    final fontSize = ConfigParam.fontSize.val();
    final body1 = Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: fontSize);
    // final String

    final mkText =
        SelectableText(markdown, key: ValueKey(ConfigParam.fontSize.val()), style: body1);

    return Scrollbar(
        controller: _scrollController,
        child: Container(
            height: MediaQuery.of(context).size.height,
            decoration:
                AppTheme.bg_decor_2() ?? BoxDecoration(color: Theme.of(context).canvasColor),
            child: SafeArea(
                top: false,
                child: CustomScrollView(
                    controller: _scrollController,
                    physics: const ClampingScrollPhysics(),
                    slivers: <Widget>[
                      SliverAppBar(
                          elevation: 0.0,
                          expandedHeight: _appBarHeight,
                          pinned: true,
                          title: _showTitle ? Text(widget.saint.name) : null,
                          actions: [_getActions()],
                          bottom: controller != null && _showDots && controller.length > 1
                              ? PreferredSize(
                                  preferredSize: const Size.fromHeight(48.0),
                                  child: Container(
                                      height: 48.0,
                                      alignment: Alignment.center,
                                      child: TabPageSelector(controller: controller)))
                              : null,
                          flexibleSpace: _showTitle
                              ? null
                              : FlexibleSpaceBar(
                                  title: null,
                                  background: Container(
                                    decoration: AppTheme.bg_decor_3() ??
                                        BoxDecoration(color: Theme.of(context).primaryColor),
                                    padding:
                                        const EdgeInsets.fromLTRB(10.0, kToolbarHeight, 10.0, 0.0),
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          if (widget.saint.has_icon)
                                            GestureDetector(
                                                onTap: () => SaintPopup(widget.saint).show(context),
                                                child: Material(
                                                    elevation: 10.0,
                                                    child: SizedBox(
                                                        height: 280.0,
                                                        child: FittedBox(
                                                          child: Image.asset(
                                                            "assets/icons/${widget.saint.id}.jpg",
                                                          ),
                                                          fit: BoxFit.contain,
                                                        )))),
                                          Container(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 25),
                                              constraints: const BoxConstraints(
                                                maxHeight: 80.0,
                                              ),
                                              child: Center(
                                                  child: Text(widget.saint.name,
                                                      textAlign: TextAlign.center,
                                                      maxLines: 3,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 20.0,
                                                      ))))
                                        ]),
                                  ))),
                      SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) => Container(
                                  padding: const EdgeInsets.all(10.0),
                                  constraints: BoxConstraints(minHeight: _textMinHeight),
                                  decoration: AppTheme.bg_decor_2() ??
                                      BoxDecoration(color: Theme.of(context).canvasColor),
                                  child: SafeArea(top: false, child: mkText)),
                              childCount: 1))
                    ]))));
  }
}

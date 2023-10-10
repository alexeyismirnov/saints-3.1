import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:async';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

import 'saint_model.dart';

class SaintPopup extends StatefulWidget {
  final Saint saint;
  SaintPopup(this.saint);

  @override
  _SaintPopupState createState() => _SaintPopupState();
}

class _SaintPopupState extends State<SaintPopup> {
  final fToast = FToast();

  @override
  void initState() {
    super.initState();

    fToast.init(context);
  }

  Future<File> getImageFileFromAssets(String path) async {
    ByteData byteData = await rootBundle.load(join("assets/icons", path));

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file
        .writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Future<bool?> saveIcon(String path) async {
    File f = await getImageFileFromAssets(path);
    return GallerySaver.saveImage(f.path);
  }

  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text("Сохранено в Фотографиях"),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.CENTER,
      toastDuration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      titlePadding: const EdgeInsets.all(5.0),
      title: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              icon: const Icon(Icons.clear, size: 40.0),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          Expanded(
              child: Text(widget.saint.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18.0,
                  ))),
          IconButton(
              icon: const Icon(Icons.save, size: 40.0),
              onPressed: () {
                Navigator.of(context).pop();

                saveIcon("${widget.saint.id}.jpg").then((_) {
                  _showToast();
                });
              })
        ],
      ),
      content: SizedBox(
          width: 500.0,
          height: 400.0,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Image.asset(
              "assets/icons/${widget.saint.id}.jpg",
            ),
          )));
}

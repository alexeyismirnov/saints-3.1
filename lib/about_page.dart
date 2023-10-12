import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_toolkit/flutter_toolkit.dart';
import 'package:store_redirect/store_redirect.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  List<Widget> getContent() {
    return [
      Row(mainAxisSize: MainAxisSize.max, children: [
        Expanded(
            child: Text("mobile_apps".tr(),
                textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge)),
      ]),
      const SizedBox(height: 20),
      Text("about_us".tr(), style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 20),
      RichText(
          text: TextSpan(children: [
        TextSpan(
            text: "Православный календарь+\n\n", style: Theme.of(context).textTheme.titleLarge),
        TextSpan(text: "calendar_app_info".tr(), style: Theme.of(context).textTheme.titleMedium)
      ])),
      const SizedBox(height: 20),
      SimpleCard(
          title: "calendar_app_install".tr(),
          image: "assets/images/calendar.png",
          onTap: () =>
              StoreRedirect.redirect(androidAppId: "com.rlc.ponomar_ru", iOSAppId: "1095609748")),
      const SizedBox(height: 20),
      RichText(
          text: TextSpan(children: [
        TextSpan(text: "Храм в Гонконге\n\n", style: Theme.of(context).textTheme.titleLarge),
        TextSpan(text: "church_app_info".tr(), style: Theme.of(context).textTheme.titleMedium)
      ])),
      const SizedBox(height: 20),
      SimpleCard(
          title: "church_app_install".tr(),
          image: "assets/images/church_icon.jpg",
          onTap: () =>
              StoreRedirect.redirect(androidAppId: "com.rlc.church", iOSAppId: "1566259967")),
      const SizedBox(height: 20),
      RichText(
          text: TextSpan(children: [
        TextSpan(
            text: "Библиотека на китайском\n\n", style: Theme.of(context).textTheme.titleLarge),
        TextSpan(text: "bookshop_app_info".tr(), style: Theme.of(context).textTheme.titleMedium)
      ])),
      const SizedBox(height: 20),
      SimpleCard(
          title: "bookshop_app_install".tr(),
          image: "assets/images/bookshop.jpg",
          onTap: () =>
              StoreRedirect.redirect(androidAppId: "com.rlc.bookshop", iOSAppId: "1105252815")),
    ];
  }

  @override
  Widget build(BuildContext context) => SafeArea(
      child: Center(
          child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: CustomScrollView(slivers: <Widget>[
                SliverPadding(
                    padding: const EdgeInsets.all(15),
                    sliver: SliverList(delegate: SliverChildListDelegate(getContent())))
              ]))));
}

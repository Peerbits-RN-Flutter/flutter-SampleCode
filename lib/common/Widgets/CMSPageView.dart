import 'dart:io';

import '../Config/AppImages.dart';
import '../Config/AppFont.dart';
import '../ApiFactory/Models/Cms.dart';
import '../Config/Localization/Localize.dart';
import '../Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

var objCms = Cms().obs;

class CMSPageView extends StatefulWidget {
  CMSPagesType pageType;

  CMSPageView(this.pageType);

  @override
  _CMSPageViewState createState() => _CMSPageViewState();
}

class _CMSPageViewState extends State<CMSPageView> {
  var url = "";
  var title = "";

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    switch (widget.pageType) {
      case CMSPagesType.AboutUs:
        setState(() {
          url = objCms.value!.about!;
          title = Localize.about_us.tr;
        });
        break;
      case CMSPagesType.PrivacyPolicy:
        setState(() {
          url = objCms.value!.privacy_policy!;
          title = Localize.privacy_policy.tr;
        });
        break;
      case CMSPagesType.TermsAndCondition:
        setState(() {
          url = objCms.value!.terms_and_conditions!;
          title = Localize.terms_and_condition.tr;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1.0,
        leading: IconButton(
          icon: Image.asset(AppImages.ic_back),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: AppFont.Body1_Regular(),
        ),
      ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        onPageStarted: (url) {},
        onPageFinished: (url) {},
        initialUrl: url,
      ),
    );
  }
}

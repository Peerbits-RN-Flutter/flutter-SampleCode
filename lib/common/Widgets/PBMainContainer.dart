import '../config/AppColors.dart';
import '../config/AppFont.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class PBMainContainer extends StatelessWidget {
  String? appBarTitle;
  Widget child;
  List<Widget>? actions = [];
  bool isAppBar = true;
  Widget? leading;
  Color? backgroundColor;
  Widget? floatingActionButton;
  double? padding, elevation;
  Widget? bottomNavigationBar;
  Widget? drawer;

  PBMainContainer(
      {required this.child,
      this.backgroundColor,
      this.appBarTitle,
      this.isAppBar = true,
      this.actions,
      this.floatingActionButton,
      this.padding,
      this.elevation,
      this.leading,
      this.drawer,
      this.bottomNavigationBar});

  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    // FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    return Scaffold(
      drawer: drawer ?? null,
      floatingActionButton: floatingActionButton ?? null,
      backgroundColor: backgroundColor ?? Colors.white,
      appBar: isAppBar == true
          ? AppBar(
              leading: leading ?? null,
              elevation: elevation ?? 1.0,
              centerTitle: true,
              actions: actions,
              title: Text(appBarTitle ?? '',
                  style: AppFont.Body1_Regular(color: Colors.white)),
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(padding ?? 0.0),
          child: child,
        ),
      ),
      bottomNavigationBar: bottomNavigationBar ?? null,
    );
  }
}

import '../config/AppColors.dart';
import '../config/AppFont.dart';
import '../Config/Localization/Localize.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PBEmptyView extends StatelessWidget {
  String errorMsg;
  PBEmptyView({required this.errorMsg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 16.0),
      alignment: Alignment.center,
      child: Text(
        errorMsg ?? Localize.no_data_found.tr,
        style: AppFont.Caption1_Body(color: AppColors.grey),
      ),
    );
  }
}

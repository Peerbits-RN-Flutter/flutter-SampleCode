import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../Config/Localization/Localize.dart';

extension MyString on String {
  String get first => this[0];

  String get last => this[this.length - 1];

  String get capitalize => "${this[0].toUpperCase()}${this.substring(1)}";

  String get trimMobile => this.replaceAll(" ", "");

  String get setDefaultVal =>
      (this == null || this.trim() == "") ? "..." : this;

  String get setPerc => this.trim() == "" ? "" : '$this%';

  String get setNAVal => this.trim() == "" ? "N/A" : this;

  bool get isNullOrEmpty => (this == null || this.trim() == "") ? true : false;

  String get setChatId => (this == null || this.trim() == "") ? this : 'c$this';

  String get setYears => this.trim() != "" ? this + Localize.years.tr : this;

  int? get toInt => this.trim() == "" ? null : int.parse(this);

  Image image({color: Color}) {
    return Image.asset(
      this,
      color: color,
    );
  }

  CachedNetworkImage cachedImage(
          {double? height, double? width, BoxFit? fit, String? placeholder}) =>
      CachedNetworkImage(
        fit: fit ?? BoxFit.fill,
        height: height ?? 20.0,
        width: width ?? 20.0,
        imageUrl: this,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => placeholder != null
            ? Image.asset(placeholder, fit: BoxFit.fill)
            : Icon(Icons.error),
      );

  String setKVal() {
    return '$this k';
  }

  String withCompany(String company) {
    if (!this.isNullOrEmpty && !company.isNullOrEmpty) {
      return this + ' at ' + company;
    } else if (!this.isNullOrEmpty) {
      return this;
    } else if (!company.isNullOrEmpty) {
      return company;
    } else {
      return this.setDefaultVal;
    }
  }
}

extension MyInt on int {
  bool get boolType => this == 0 ? false : true;

  String get setCurrency => (this == null || this == 0)
      ? Localize.not_disclosed.tr
      : '${setFormatted(this)} €';

  String get setCurrencyBefore => (this == null || this == 0)
      ? Localize.not_disclosed.tr
      : '€ ${setFormatted(this)}';

  String get setDigit => NumberFormat.compactCurrency(
        decimalDigits: 0,
        symbol:
            '', // if you want to add currency symbol then pass that in this else leave it empty.
      ).format(this ?? 0);

  String get setMonths => (this != null)
      ? this.toString() + ' months'
      : this.toString().setDefaultVal;

  String setFormatted(int val) {
    return NumberFormat.currency(symbol: "", decimalDigits: 0).format(val);
  }

  String setKVal() {
    var val = this ?? 0;
    return '$val\k';
  }

  String setPayscale() {
    var val = this ?? 0;
    return '${setFormatted(this)}/pm';
  }
}

extension MyDateTime on DateTime {
  String toTimeAgoDate() {
    final date2 = DateTime.now();
    final difference = date2.difference(this);
    if ((difference.inDays / 365).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} ${Localize.yearsAgo.tr}';
    } else if ((difference.inDays / 365).floor() >= 1) {
      return Localize.oneYearAgo.tr;
    } else if ((difference.inDays / 30).floor() >= 2) {
      return '${(difference.inDays / 30).floor()} ${Localize.monthsAgo.tr}';
    } else if ((difference.inDays / 30).floor() >= 1) {
      return Localize.oneMonthAgo.tr;
    } else if ((difference.inDays / 7).floor() >= 2) {
      return '${(difference.inDays / 7).floor()} ${Localize.weeksAgo.tr}';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return Localize.oneWeekAgo.tr;
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} ${Localize.daysAgo.tr}';
    } else if (difference.inDays >= 1) {
      return Localize.oneDayAgo.tr; //'Yesterday'
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} ${Localize.hoursAgo.tr}';
    } else if (difference.inHours >= 1) {
      return Localize.oneHourAgo.tr; //'An hour ago'
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} ${Localize.minutesAgo.tr}';
    } else if (difference.inMinutes >= 1) {
      return Localize.oneMinAgo.tr; //'A minute ago'
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} ${Localize.secondsAgo.tr}';
    } else {
      return Localize.justNow.tr;
    }
  }

  String get getAgeInYears {
    int ageInteger = 0;

    if (this != null) {
      DateTime today = DateTime.now();
      today = DateTime(today.year, today.month, today.day);
      DateTime dob = DateTime(this.year, this.month, this.day);

      ageInteger = today.year - dob.year;

      if (today.month == dob.month) {
        if (today.day < dob.day) {
          ageInteger = ageInteger - 1;
        }
      } else if (today.month < dob.month) {
        ageInteger = ageInteger - 1;
      }
    }
    return ageInteger.toString() + ' yr';
  }
}

import 'package:flutter/foundation.dart';

class PBLog {
  PBLog(var value) {
    if (!kReleaseMode)
      print("===============> ${value.toString()} <=====================");
  }
}

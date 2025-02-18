import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

customPrint(String value) {
  if (kDebugMode) {
    DateTime now = DateTime.now();
    log("===>>> ${DateFormat("dd/MM/yyy").add_jms().format(now)} ===>>> $value");
  }
}

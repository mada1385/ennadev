import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../services/api/api.dart';

class HomePageModel extends BaseNotifier {
  final Api api;

  HomePageModel({@required this.api}) {
    someFunction();
  }
  someFunction() async {
    await Future.delayed(Duration(seconds: 5));

    Logger().v("Verbose log ");

    Logger().d("Debug log");

    Logger().i("Info log");

    Logger().w("Warning log");

    Logger().e("Error log");

    Logger().wtf("What a terrible failure log");

    setIdle();
  }

  openPostPage(BuildContext context) async {}

  renderAgain() {
    setState();
  }
}

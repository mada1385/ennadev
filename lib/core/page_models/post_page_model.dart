import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';

import '../services/api/api.dart';

class PostPageModel extends BaseNotifier {
  final Api api;

  PostPageModel({@required this.api}) {
    someFunction();
  }
  someFunction() async {
    await Future.delayed(Duration(seconds: 5));

    setIdle();
  }

  renderAgain() {
    setState();
  }
}

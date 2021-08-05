// provider_setup.dart
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/core/services/localization/localization.dart';
import 'package:enna/core/services/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../services/notification/notification_service.dart';

const bool USE_FAKE_IMPLEMENTATION = false;

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders,
];

List<SingleChildWidget> independentServices = [
  // Provider(create: (_) => () => DatabaseHelper.instance),
  Provider<Api>(create: (_) => HttpApi()),
  // ChangeNotifierProvider<ConnectivityService>(
  //     create: (context) => ConnectivityService()),
];

List<SingleChildWidget> dependentServices = [
  ProxyProvider<Api, AuthenticationService>(
      update: (context, api, authenticationService) =>
          AuthenticationService(api: api)),
  ProxyProvider<AuthenticationService, NotificationService>(
      update: (context, auth, ns) => NotificationService(auth: auth)),
];

List<SingleChildWidget> uiConsumableProviders = [
  ChangeNotifierProvider(create: (_) => ThemeProvider()),
  ChangeNotifierProvider<AppLanguageModel>(create: (_) => AppLanguageModel()),
];

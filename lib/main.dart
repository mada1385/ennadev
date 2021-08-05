import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'core/services/localization/localization.dart';
import 'core/services/preference/preference.dart';
import 'core/services/theme/theme_provider.dart';
import 'core/utils/provider_setup.dart';
import 'ui/shared/routes/route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preference.init();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MyApp());
}

// This widget is the root of your application.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MultiProvider(
        providers: providers,
        child: Consumer2<AppLanguageModel, ThemeProvider>(
          builder: (context, language, theme, child) {
            return MaterialApp(
              home: Routes.splash,
              debugShowCheckedModeBanner: false,
              //theme: theme.isDark ? theme.dark : theme.light,
              theme: ThemeData(
                textTheme: GoogleFonts.cairoTextTheme(
                  Theme.of(context).textTheme,
                ),
              ),
              locale: language.appLocal,
              supportedLocales: [const Locale('en'), const Locale('ar')],
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'package:enna/core/models/user.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/core/services/notification/notification_service.dart';
import 'package:enna/core/services/preference/preference.dart';
import 'package:enna/ui/shared/routes/route.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration(seconds: 2))
    //     .then((value) => UI.push(context, Routes.signIn, replace: true));

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<NotificationService>(context, listen: false)
          .init(context);

      Future.delayed(Duration(seconds: 6)).then((value) async {
        if (Preference.getString(PrefKeys.USER_ID) != null) {
          // get user
          UserInfo temp = await Provider.of<Api>(context, listen: false)
              .getUserByID(context,
                  userId: Preference.getString(PrefKeys.USER_ID));

          if (temp != null) {
            User user =
                User(token: Preference.getString(PrefKeys.USER_ID), user: temp);

            await Provider.of<AuthenticationService>(context, listen: false)
                .saveUser(user: user);

            await Provider.of<AuthenticationService>(context, listen: false)
                .setUser(user: user);

            if (Preference.getString(PrefKeys.TEAM_ID) != null) {
              UI.pushReplaceAll(context, Routes.homePage);
            } else {
              if (Provider.of<AuthenticationService>(context, listen: false)
                          .user
                          .user
                          .teams !=
                      null &&
                  Provider.of<AuthenticationService>(context, listen: false)
                      .user
                      .user
                      .teams
                      .isNotEmpty) {
                UI.pushReplaceAll(context, Routes.selectTeam(isInvited: false));
              } else {
                UI.pushReplaceAll(context, Routes.creatOrJoinTeam);
              }
            }
          } else {
            UI.pushReplaceAll(context, Routes.signIn);
          }
        } else {
          UI.pushReplaceAll(context, Routes.signIn);
        }
        // UI.pushReplaceAll(context, Routes.signIn);
        // }
      });

      // fcmToken = Preference.getString(PrefKeys.fcmToken);

      // if (fcmToken == null || fcmToken == "") {
      //   fcmToken = Provider.of<AuthenticationService>(context, listen: false)
      //       .user
      //       .user
      //       .fcmToken;
      //   if (fcmToken != null || fcmToken == "") {
      //     await Provider.of<AuthenticationService>(context, listen: false)
      //         .sendFCMToken(context, fcm: fcmToken);
      //   }
      // } else {
      //   await Provider.of<AuthenticationService>(context, listen: false)
      //       .sendFCMToken(context, fcm: fcmToken);
      // }

      // UI.pushReplaceAll(context, Routes.signIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(

        // backgroundColor: Color.fromARGB(255, 34, 50, 151),
        body: Stack(
      fit: StackFit.expand,
      children: [
        Container(
          height: ScreenUtil.screenHeightDp,
          width: ScreenUtil.screenWidthDp,
          color: Color.fromARGB(255, 45, 64, 158),

          // child: Image.asset(
          //   'assets/images/background.png',
          //   fit: BoxFit.fill,
          //   color: Color.fromARGB(255, 45, 64, 158),
          // ),
        ),
        // Center(
        //     child: SvgPicture.asset(
        //   'assets/images/logo.svg',
        //   color: Colors.white,
        // )),
        // Align(
        //   alignment: Alignment.bottomCenter,
        //   child: SvgPicture.asset(
        //     'assets/images/khema.svg',
        //     color: Colors.white,
        //   ),
        // )
      ],
    ));

    //   body: Center(
    //     child: Column(
    //       children: [
    //         SizedBox(
    //           height: 100,
    //         ),
    //         Padding(
    //             padding: const EdgeInsets.only(top: 50.0, bottom: 5),
    //             child: Image.asset('assets/images/intro1.png')),
    //         SizedBox(
    //           height: 30,
    //         ),
    //         Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Center(
    //             child: Text(
    //               'Enna',
    //               style: TextStyle(
    //                   color: AppColors.primaryBackground,
    //                   fontSize: 50,
    //                   fontWeight: FontWeight.bold),
    //             ),
    //           ),
    //         ),
    //         Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Center(
    //             child: Text(
    //               'Splitting made simpler',
    //               style: TextStyle(
    //                 color: AppColors.primaryElement,
    //                 fontSize: 20,
    //               ),
    //             ),
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}

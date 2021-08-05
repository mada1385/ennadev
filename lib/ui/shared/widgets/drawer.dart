import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/core/services/localization/localization.dart';
import 'package:enna/ui/shared/drawer/my_orders.dart';
import 'package:enna/ui/shared/routes/route.dart';
import 'package:enna/ui/shared/styles/colors.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:ui_utils/ui_utils.dart';

import '../../../core/services/localization/localization.dart';
import '../../home/home_page.dart';

class AppDrawer extends StatelessWidget {
  final BuildContext ctx;
  final HomePageModel model;
  const AppDrawer({this.ctx, this.model});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return BaseWidget<DrawerPageModel>(
      model: DrawerPageModel(
          api: Provider.of<Api>(context),
          context: context,
          auth: Provider.of(context)),
      builder: (context, model, child) => Drawer(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: ScreenUtil.screenHeightDp,
              width: ScreenUtil.screenWidthDp * 0.9,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: CircleAvatar(
                        backgroundColor: model.auth.user.user.image != null ||
                                model.auth.user.user.image.isNotEmpty
                            ? Colors.transparent
                            : Colors.blue[900],
                        maxRadius: 35,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: model.auth.user.user.image,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) => ClipOval(
                              child: Container(
                                  color: Colors.blue[900],
                                  alignment: Alignment.center,
                                  height: 55.0,
                                  width: 55.0,
                                  child: Text(
                                    model.auth.user.user.name
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    model.auth.user.user.name,
                    style: TextStyle(
                        color: Colors.blue[900],
                        fontSize: 20,
                        fontWeight: FontWeight.w900),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    model.auth.user.user.email,
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    model.auth.user.user.mobile,
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                        width: MediaQuery.of(context).size.width / 3.5,
                        height: 30.0,
                        child: GestureDetector(
                            onTap: () {
                              UI.push(context, Routes.editProfile);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                  width: 1.0,
                                ),
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Center(
                                child: Text(
                                  locale.get("Edit profile") ?? "Edit profile",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      UI.push(context, Routes.homePage);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      height: 60,
                      child: Row(
                        children: [
                          SizedBox(
                              width: 20,
                              height: 20,
                              child: SvgPicture.asset(
                                'assets/images/homeIcon.svg',
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              locale.get('Home') ?? "Home",
                              style: TextStyle(
                                  color: AppColors.secondaryText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: 0.3,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        height: 60,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width: 20,
                                height: 20,
                                child: SvgPicture.asset(
                                  'assets/images/language.svg',
                                )),
                            Text(
                              locale.get('Language') ?? 'Language',
                              style: TextStyle(
                                  color: AppColors.secondaryText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                            ToggleSwitch(
                              minWidth: 50.0,
                              minHeight: 30,
                              initialLabelIndex: model.languageSelection,
                              fontSize: 15,
                              activeBgColor: [AppColors.primaryText],
                              // icons: [Icons.ac_unit, Icons.accessibility],
                              // activeTextColor: Colors.white,
                              inactiveBgColor: Colors.white,
                              // inactiveTextColor: Colors.grey[900],
                              labels: ['AR', 'EN'],
                              onToggle: (index) {
                                model.languageSelection = index;
                                Provider.of<AppLanguageModel>(context,
                                        listen: false)
                                    .changeLanguage(index == 0
                                        ? Locale("ar")
                                        : Locale("en"));
                                model.setState();
                                print('switched to: $index');
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 0.3,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          UI.push(context, Routes.teamMembers);
                        },
                        child: Container(
                          height: 30,
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            children: [
                              SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: SvgPicture.asset(
                                    'assets/images/teamMember.svg',
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  locale.get('Team Members') ?? "Team Members",
                                  style: TextStyle(
                                      color: AppColors.secondaryText,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 0.3,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          UI.push(context, MyOrdersPage());
                        },
                        child: Container(
                          height: 30,
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            children: [
                              SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: SvgPicture.asset(
                                    'assets/images/myOrders.svg',
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  locale.get('My Orders') ?? 'My Orders',
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 0.3,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          UI.push(context, Routes.location);
                        },
                        child: Container(
                          height: 30,
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            children: [
                              SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: SvgPicture.asset(
                                    'assets/images/location.svg',
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  locale.get('Location') ?? 'Location',
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 0.3,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          UI.push(context, Routes.privacyPolicy);
                        },
                        child: Container(
                          height: 30,
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            children: [
                              SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: SvgPicture.asset(
                                    'assets/images/privacyPolicy.svg',
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  locale.get('Privacy Policy') ??
                                      'Privacy Policy',
                                  style: TextStyle(
                                      color: AppColors.secondaryText,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 0.3,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () async {
                      await Provider.of<AuthenticationService>(ctx,
                              listen: false)
                          .signOut;
                      UI.pushReplaceAll(context, Routes.signIn);
                    },
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          SizedBox(
                              width: 20,
                              height: 20,
                              child: SvgPicture.asset(
                                'assets/images/logout.svg',
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              locale.get('Logout') ?? 'Logout',
                              style: TextStyle(
                                  color: AppColors.secondaryText,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DrawerPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  int languageSelection;

  AppLocalizations locale;

  DrawerPageModel({NotifierState state, this.api, this.auth, this.context})
      : super(state: state) {
    locale = AppLocalizations.of(context);
    languageSelection = locale.locale.languageCode == 'en' ? 1 : 0;
  }
}

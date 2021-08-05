import 'package:enna/ui/shared/widgets/drawer.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/ui/shared/routes/route.dart';
import 'package:enna/ui/shared/widgets/app_bar.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:enna/ui/shared/styles/colors.dart';

import '../../core/services/localization/localization.dart';

class HomePage extends StatelessWidget {
  bool noSeason = true;
  HomePage({this.noSeason});
  @override
  Widget build(BuildContext context) {
    return FocusWidget(
      child: BaseWidget<HomePageModel>(
          // initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.getTEAM_ID()),
          model: HomePageModel(
              api: Provider.of<Api>(context),
              auth: Provider.of(context),
              noSeason: noSeason,
              context: context),
          builder: (context, model, child) {
            return Scaffold(
                key: model.homeScaffoldKey,
                appBar: AppBarWidget(
                  openDrawer: () =>
                      model.homeScaffoldKey.currentState.openDrawer(),
                ),
                //endDrawer: NotificationDrawer(context, model),
                drawer: AppDrawer(ctx: context, model: model),
                bottomNavigationBar: bottomNavBar(context, model),
                body: model.pages[model.currentPageIndex]);
          }),
    );
  }

  bottomNavBar(BuildContext context, HomePageModel model) {
    final locale = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(15), topLeft: Radius.circular(15)),
        boxShadow: [
          BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: model.currentPageIndex,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (i) {
          model.changeTap(context, i);
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/images/homeIcon.svg",
                color: model.currentPageIndex == 0
                    ? Colors.blue[900]
                    : Colors.grey),
            label:
                //  Text(
                locale.get('Home') ?? 'Home',
            //   style: TextStyle(
            //     color: model.currentPageIndex == 0
            //         ? Colors.blue[900]
            //         : Colors.grey,
            //   ),
          ),
          // ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/images/transactionIcon.svg",
                color: model.currentPageIndex == 1
                    ? Colors.blue[900]
                    : Colors.grey),
            label:
                //  Text(
                locale.get('Transactions') ?? 'Transactions',
            //     style: TextStyle(
            //         color: model.currentPageIndex == 1
            //             ? Colors.blue[900]
            //             : Colors.grey),
            //   ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/images/calenderIcon.svg",
                color: model.currentPageIndex == 2
                    ? Colors.blue[900]
                    : Colors.grey),
            label:
                //  Text(
                locale.get('Events') ?? 'Events',
            //     style: TextStyle(
            //         color: model.currentPageIndex == 2
            //             ? Colors.blue[900]
            //             : Colors.grey),
            //   ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/images/contactsIcon.svg",
                color: model.currentPageIndex == 3
                    ? Colors.blue[900]
                    : Colors.grey),
            label:
                //  Text(
                locale.get('Contacts') ?? 'Contacts',
            //     style: TextStyle(
            //         color: model.currentPageIndex == 3
            //             ? Colors.blue[900]
            //             : Colors.grey),
            //   ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/images/shopIcon.svg",
                color: model.currentPageIndex == 4
                    ? Colors.blue[900]
                    : Colors.grey),
            label:
                //  Text(
                locale.get('Shop') ?? 'Shop',
            //     style: TextStyle(
            //         color: model.currentPageIndex == 4
            //             ? Colors.blue[900]
            //             : Colors.grey),
            //   ),
          ),
        ],
        selectedItemColor: AppColors.ternaryBackground,
      ),
    );
  }
}

class HomePageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  bool noSeason = true;
  final GlobalKey<ScaffoldState> homeScaffoldKey =
      new GlobalKey<ScaffoldState>();

  int currentPageIndex = 0;

  HomePageModel(
      {NotifierState state, this.api, this.auth, this.context, this.noSeason})
      : super(state: state) {
    if (noSeason == null) {
      currentPageIndex = 0;
    } else {
      currentPageIndex = 4;
    }
  }
  final List<Widget> pages = [
    Routes.home,
    Routes.transaction,
    Routes.events,
    Routes.contacts,
    Routes.shop,
  ];

  changeTap(BuildContext context, int i) {
    final locale = AppLocalizations.of(context);

    if (noSeason != false) {
      if (i != currentPageIndex) {
        currentPageIndex = i;
        setState();
      }
    } else {
      UI.toast(locale.get("you don't have team") ?? "you don't have team");
      UI.push(context, Routes.selectTeam(isInvited: false));
      return null;
    }
  }

  logout() async {
    auth.signOut;
    UI.pushReplaceAll(context, Routes.signIn);
  }
}

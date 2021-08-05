import 'package:enna/core/services/localization/localization.dart';
import 'package:enna/ui/home/home_taps/contacts/business_page.dart';
import 'package:enna/ui/home/home_taps/contacts/user_contacts_page.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:ui_utils/ui_utils.dart';

class MainContactsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return FocusWidget(
      child: DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(ScreenUtil.screenHeightDp / 13),
            child: AppBar(
              backgroundColor: Colors.blue[900],
              bottom: TabBar(
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                tabs: [
                  Tab(
                    text: "${locale.get("CONTACTS") ?? "CONTACTS"}",
                  ),
                  Tab(text: "${locale.get("BUSINSSES") ?? "BUSINSSES"}"),
                ],
              ),
            ),
          ),
          body: BaseWidget<ContactsPageModel>(
              //initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.initializeProfileData()),
              model: ContactsPageModel(
                  api: Provider.of<Api>(context),
                  auth: Provider.of(context),
                  context: context),
              builder: (context, model, child) {
                return TabBarView(
                  children: [
                    UserContactsPage(),
                    BusinessContactsPage(),
                  ],
                );
              }),
        ),
      ),
    );
  }
}

class ContactsPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  ContactsPageModel({NotifierState state, this.api, this.auth, this.context})
      : super(state: state);
}

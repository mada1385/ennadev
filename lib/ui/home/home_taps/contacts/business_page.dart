
import 'package:enna/core/models/contacts.dart';
import 'package:enna/core/models/user.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/core/services/localization/localization.dart';
import 'package:enna/core/services/preference/preference.dart';
import 'package:enna/ui/shared/routes/route.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

class BusinessContactsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return FocusWidget(
      child: Scaffold(
        body: BaseWidget<BusinessContactsPageModel>(
            // initState: (m) => WidgetsBinding.instance
            //     .addPostFrameCallback((_) => m.getBusinessContacts()),
            model: BusinessContactsPageModel(
                api: Provider.of<Api>(context),
                auth: Provider.of(context),
                context: context),
            builder: (context, model, child) {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    model.busy
                        ? Center(child: CircularProgressIndicator())
                        : model.hasError
                            ? Center(
                                child: Text(
                                locale.get('Error') ?? 'Error',
                              ))
                            : model.businessContacts != null &&
                                    model.businessContacts.isEmpty
                                ? Container(
                                    height: 100,
                                    child: Center(
                                        child: Text(
                                      locale.get('You have no contacts') ??
                                          'You have no contacts',
                                    )))
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(children: [
                                      ...List.generate(
                                          model?.businessContacts?.length ?? 0,
                                          (index) => Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Container(
                                                child: Card(
                                                  elevation: 5,
                                                  color: Colors.grey[100],
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            height: 40,
                                                            width: 40,
                                                            child:
                                                                CachedNetworkImage(
                                                              placeholder: (context,
                                                                      url) =>
                                                                  Center(
                                                                      child:
                                                                          CircularProgressIndicator()),
                                                              imageUrl: model
                                                                  .businessContacts[
                                                                      index]
                                                                  .icon,
                                                              fit: BoxFit
                                                                  .scaleDown,
                                                              errorWidget:
                                                                  (context, url,
                                                                          error) =>
                                                                      Icon(
                                                                Icons
                                                                    .restaurant_menu,
                                                                color: Colors
                                                                    .blue[900],
                                                                size: 40,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        15),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  model
                                                                      .businessContacts[
                                                                          index]
                                                                      .name
                                                                      .localized(
                                                                          context),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                Text(
                                                                  "${model.businessContacts[index].contacts.length} ${locale.get("contact") ?? "contact"}",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )))
                                    ]))
                  ],
                ),
              );
            }),
      ),
    );
  }
}

class BusinessContactsPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  List<ContactsCateoryModel> businessContacts;
  Map<String, dynamic> param;

  Teams team;

  AppLocalizations locale;

  // List<ContactsCateoryModel> userContacts;

  BusinessContactsPageModel(
      {NotifierState state, this.api, this.auth, this.context})
      : super(state: state) {
    locale = AppLocalizations.of(context);
    getTeam();
  }

  getTeam() async {
    setBusy();
    team = Preference.getString(PrefKeys.TEAM_ID) == null
        ? UI.pushReplaceAll(context, Routes.creatOrJoinTeam)
        : await api.getTeamByTeamID(context,
            teamID: Preference.getString(PrefKeys.TEAM_ID));

    if (team != null) {
      param = {"teamId": team.id, "lang": locale.locale.languageCode};
      await getBusinessContacts();
    } else {
      setError();
    }
  }

  getBusinessContacts() async {
    setBusy();
    businessContacts = await api.getCompanyContacts(context, param: param);
    businessContacts != null ? setIdle() : setError();
  }
}

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

class UserContactsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return FocusWidget(
      child: Scaffold(
        body: BaseWidget<UserContactsPageModel>(
            // initState: (m) => WidgetsBinding.instance
            //     .addPostFrameCallback((_) => m.getUserContacts()),
            model: UserContactsPageModel(
                api: Provider.of<Api>(context),
                auth: Provider.of(context),
                context: context),
            builder: (context, model, child) {
              return SingleChildScrollView(
                child: model.busy
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Center(child: CircularProgressIndicator())],
                      )
                    : model.hasError
                        ? Center(
                            child: Text(
                            locale.get('Error') ?? 'Error',
                          ))
                        : Column(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                child: Container(
                                  height: 70,
                                  width: ScreenUtil.screenWidthDp / 1.1,
                                  child: RaisedButton(
                                      onPressed: () {
                                        UI
                                            .push(
                                                context, Routes.addUserContact)
                                            .then((value) {
                                          if (value is bool && value) {
                                            model.getUserContacts();
                                          }
                                        });
                                      },
                                      textColor: Colors.white,
                                      color: Colors.white,
                                      child: Center(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.add_circle,
                                                  color: Colors.blue[900],
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "${locale.get("Add Contact") ?? "Add Contact"}",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blue[900]),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(0.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(5.0),
                                      )),
                                ),
                              ),
                              model.busy
                                  ? Center(child: CircularProgressIndicator())
                                  : model.userContacts != null &&
                                          model.userContacts.isEmpty
                                      ? Center(
                                          child: Text(
                                          locale.get('You have no contacts') ??
                                              'You have no contacts',
                                        ))
                                      : Column(
                                          children: [
                                            ...List.generate(
                                                model?.userContacts?.length ??
                                                    0,
                                                (index) => Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15.0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        UI.push(
                                                            context,
                                                            Routes.contactsDetails(
                                                                contacts: model
                                                                        .userContacts[
                                                                    index]));
                                                      },
                                                      child: Container(
                                                        child: Card(
                                                          elevation: 5,
                                                          color:
                                                              Colors.grey[100],
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                children: [
                                                                  CircleAvatar(
                                                                    radius: 30,
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              50),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(12.0),
                                                                        child:
                                                                            CachedNetworkImage(
                                                                          color:
                                                                              Colors.white,
                                                                          height:
                                                                              double.infinity,
                                                                          width:
                                                                              double.infinity,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          placeholder: (context, url) =>
                                                                              Center(child: CircularProgressIndicator()),
                                                                          imageUrl: model
                                                                              .userContacts[index]
                                                                              .icon,
                                                                          errorWidget: (context, url, error) =>
                                                                              Icon(
                                                                            Icons.phone,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                40,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            15),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          model
                                                                              .userContacts[index]
                                                                              .name
                                                                              .localized(context),
                                                                          style:
                                                                              TextStyle(color: Colors.black),
                                                                        ),
                                                                        Text(
                                                                          "${model.userContacts[index].contacts.length} ${locale.get("contact") ?? "contact"}",
                                                                          style:
                                                                              TextStyle(color: Colors.grey),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )))
                                          ],
                                        )
                            ],
                          ),
              );
            }),
      ),
    );
  }
}

class UserContactsPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  Map<String, dynamic> param;

  Teams team;

  AppLocalizations locale;

  List<ContactsCateoryModel> userContacts;

  UserContactsPageModel(
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
      userContacts = await api.getUSerContacts(context, param: param);
      userContacts != null ? setIdle() : setError();
    } else {
      setError();
    }
  }

  getUserContacts() async {
    setBusy();
    if (team != null) {
      param = {"teamId": team.id, "lang": locale.locale.languageCode};
      userContacts = await api.getUSerContacts(context, param: param);
      userContacts != null ? setIdle() : setError();
    } else {
      setError();
    }
  }
}

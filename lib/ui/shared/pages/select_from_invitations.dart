import 'dart:convert';

import 'package:enna/core/models/user.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/core/services/localization/localization.dart';
import 'package:enna/core/services/preference/preference.dart';
import 'package:enna/ui/shared/routes/route.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

class SelectFromInvitationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return BaseWidget<SelectFromInvitationsPageModl>(
      model: SelectFromInvitationsPageModl(
          auth: Provider.of(context),
          api: Provider.of<Api>(context),
          context: context),
      builder: (context, model, child) => Scaffold(
        backgroundColor: const Color(0xff1e319d),
        body: SizedBox.expand(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(height: ScreenUtil.screenHeightDp / 8),
              Text(
                'Enna',
                style: TextStyle(
                  fontFamily: 'Volkswagen-Serial',
                  fontSize: 51,
                  color: const Color(0xffffffff),
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                "${locale.get("Splitting made simpler") ?? "Splitting made simpler"}: ",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: const Color(0xff889aff),
                ),
                textAlign: TextAlign.left,
              ),
              Container(
                height: ScreenUtil.screenHeightDp / 1.85,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: model.auth.user.user.invitedTeams.length,
                      itemBuilder: (ctx, index) => Padding(
                            padding: EdgeInsets.all(8),
                            child: buildListOFInvitations(ctx, model, 0),
                          )),
                ),
              ),
              model.busy
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        InkWell(
                          onTap: () {
                            model.confirmBtn();
                          },
                          child: Container(
                            width: ScreenUtil.screenWidthDp / 1.50,
                            height: 45,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.blue)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  locale.get('Confirm') ?? 'Confirm',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    color: const Color(0xffffffff),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            model.selectFromJoined();
                          },
                          child: Container(
                            width: ScreenUtil.screenWidthDp / 1.50,
                            height: 45,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.blue)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  locale.get('Select from joind teams') ??
                                      'Select from joind teams',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    color: const Color(0xffffffff),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  buildListOFInvitations(
      BuildContext ctx, SelectFromInvitationsPageModl model, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: InkWell(
        onTap: () {
          model.selection = index;
          model.setState();
        },
        child: Container(
          // width1: 257.0,
          height: 50.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: model.selection == index
                ? const Color.fromARGB(255, 255, 170, 0)
                : Colors.white,
            border: Border.all(width: 1.0, color: const Color(0xffffffff)),
          ),
          child: Center(
              child: Text(
            model.auth.user.user.invitedTeams[index].name
                .localied(model.context),
            style: TextStyle(color: Colors.blue[900]),
          )),
        ),
      ),
    );
  }
}

class SelectFromInvitationsPageModl extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  int selection;
  SelectFromInvitationsPageModl(
      {NotifierState state, this.api, this.auth, this.context})
      : super(state: state) {
    selection = -1;
  }

  void confirmBtn() async {
    if (selection >= 0) {
      bool res = false;
      Teams selectedInvitedTeam = auth.user.user.invitedTeams[selection];
      setBusy();
      await Preference.setString(
          PrefKeys.TEAM_ID, jsonEncode(selectedInvitedTeam.toJson()));
      setIdle();
      if (Preference.getString(PrefKeys.TEAM_ID) != null) {
        // join team request
        res = await api.joinTeam(context, teamId: selectedInvitedTeam.id);
        // Check for active season
        if (res) {
          if (selectedInvitedTeam.season != null) {
            UI.push(context, Routes.homePage, replace: true);
          } else {
            UI.push(context, Routes.createSeason, replace: true);
          }
        } else {
          UI.toast("Can not join this team");
        }
      } else {
        UI.push(context, Routes.createTeam, replace: true);
      }
    } else {
      UI.toast("You must select a team!");
    }
  }

  void selectFromJoined() {
    selection = -1;
    setState();
    UI.push(context, Routes.selectTeam(isInvited: false));
  }
}

import 'package:enna/core/models/user.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/core/services/preference/preference.dart';
import 'package:enna/ui/shared/routes/route.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

import '../../../../core/services/localization/localization.dart';

class ChangeTeamDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FocusWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BaseWidget<ChangeTeamDialogModel>(
            //initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.initializeProfileData()),
            model: ChangeTeamDialogModel(
                api: Provider.of<Api>(context),
                auth: Provider.of(context),
                context: context),
            builder: (context, model, child) {
              return Dialog(
                child: Container(
                  height: ScreenUtil.screenHeightDp / 2,
                  child: model.busy
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(child: CircularProgressIndicator())
                          ],
                        )
                      : Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(Icons.close)),
                            ),
                          ),
                          Container(
                            height: ScreenUtil.screenHeightDp / 3,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: model.auth.user.user.teams.length,
                                itemBuilder: (ctx, index) {
                                  Teams team =
                                      model.auth.user.user.teams[index];

                                  return RadioListTile(
                                    value: team,
                                    title: Text(model.teamVal.name.localied(context)),
                                    groupValue: model.param['team'],
                                    onChanged: (val) {
                                      model.param['team'] = val;
                                      model.teamVal = val;
                                      print(val);
                                      model.setState();
                                    },
                                  );
                                }),
                          ),
                          RaisedButton(
                              onPressed: () async {
                                await Preference.setString(
                                    PrefKeys.TEAM_ID, model.teamVal.id);

                                UI.pushReplaceAll(context, Routes.homePage);
                              },
                              child: Text(
                                locale.get('Choose') ?? 'Choose',
                              ))
                        ]),
                ),
              );
            }),
      ),
    );
  }
}

class ChangeTeamDialogModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  Teams team;
  Teams teamVal;

  Map<String, dynamic> param = {};

  ChangeTeamDialogModel(
      {NotifierState state, this.api, this.auth, this.context})
      : super(state: state) {
    getTeam();
  }

  getTeam() async {
    setBusy();
    team = await api.getTeamByTeamID(context,
        teamID: Preference.getString(PrefKeys.TEAM_ID));

    if (team != null) {
      teamVal = team;
      param = {
        "team": teamVal,
      };
      setIdle();
    } else {
      setError();
    }
  }
}

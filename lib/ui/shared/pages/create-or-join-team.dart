import 'package:enna/core/services/localization/localization.dart';
import 'package:enna/ui/shared/routes/route.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:ui_utils/ui_utils.dart';

class CreatOrJoinTeam extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FocusWidget(
      child: Scaffold(
        backgroundColor: Colors.blue[900],
        body: BaseWidget<CreatOrJoinTeamModel>(
            //initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.initializeProfileData()),
            model: CreatOrJoinTeamModel(
                api: Provider.of<Api>(context),
                auth: Provider.of(context),
                context: context),
            builder: (context, model, child) {
              return Container(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 100,
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.only(top: 50.0, bottom: 5),
                                child: SvgPicture.asset(
                                    'assets/images/splashfinalll.svg')),
                            SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  'Enna',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  "${locale.get("Splitting made simpler") ?? "Splitting made simpler"}: ",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Container(
                                width: 335,
                                height: 50,
                                child: RaisedButton(
                                    onPressed: () {
                                      UI.push(context, Routes.createTeam);
                                    },
                                    textColor: Colors.blue[900],
                                    color: Colors.white,
                                    child: Text(
                                      "${locale.get("Create Team") ?? "Create Team"}: ",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    padding: const EdgeInsets.all(0.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                    )),
                              ),
                            ),
                            model.auth.user.user.invitedTeams.length > 0
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Container(
                                      width: 335,
                                      height: 50,
                                      child: RaisedButton(
                                          onPressed: () {
                                            UI.push(
                                                context,
                                                Routes.selectTeam(
                                                    isInvited: true));
                                          },
                                          textColor: Colors.blue[900],
                                          color: Colors.white,
                                          child: Text(
                                            "${locale.get("Join Team") ?? "Join Team"}: ",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          padding: const EdgeInsets.all(0.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(5.0),
                                          )),
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class CreatOrJoinTeamModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  CreatOrJoinTeamModel({NotifierState state, this.api, this.auth, this.context})
      : super(state: state);
}

import 'package:enna/core/models/user.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/core/services/preference/preference.dart';
import 'package:enna/ui/shared/drawer/team_members/change_team.dart';
import 'package:enna/ui/shared/routes/route.dart';
import 'package:enna/ui/shared/styles/colors.dart';
import 'package:enna/ui/shared/widgets/app_bar.dart';
import 'package:enna/ui/shared/widgets/buttons/raised_button.dart';
import 'package:enna/ui/shared/widgets/drawer.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

import '../../../../core/services/localization/localization.dart';

class TeamMembersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FocusWidget(
      child: BaseWidget<TeamMembersPageModel>(
          //initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.initializeProfileData()),
          model: TeamMembersPageModel(
              api: Provider.of<Api>(context),
              auth: Provider.of(context),
              context: context),
          builder: (context, model, child) {
            return Scaffold(
              key: model.key,
              appBar: AppBarWidget(
                openDrawer: () => model.key.currentState.openDrawer(),
              ),
              drawer: AppDrawer(ctx: context),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: model.busy
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(child: CircularProgressIndicator()),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 4,
                                ),
                                Text(
                                  locale.get('Team Members') ?? 'Team Members',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              model.team.name.localied(context),
                              style: TextStyle(fontSize: 20),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0),
                                    child: Container(
                                      height: 50,
                                      child: RaisedButton(
                                          onPressed: () async {
                                            final result = await UI.push(
                                                context, Routes.addContact);
                                            if (result != null) {
                                              model.getTeamById();
                                            }
                                          },
                                          textColor: Colors.white,
                                          color: Colors.blue[900],
                                          child: Center(
                                            child: Text(
                                              locale.get('Add member') ??
                                                  'Add member',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(0.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(5.0),
                                          )),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: ScreenUtil.screenWidthDp / 13,
                                ),
                                Expanded(
                                  child: Container(
                                      height: 80,
                                      child: selectCurruntTeambutton(
                                          context, model)),
                                ),
                              ],
                            ),
                            Container(
                              height: ScreenUtil.screenHeightDp / 4,
                              child: ListView.builder(
                                itemCount: model.team.members.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 20,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(150),
                                                child: CachedNetworkImage(
                                                  placeholder: (context, url) =>
                                                      Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                  imageUrl: model.team
                                                      .members[index].image,
                                                  height: double.infinity,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          CircleAvatar(
                                                    radius: 30,
                                                    child: SvgPicture.asset(
                                                      "assets/images/contactsIcon.svg",
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              width: ScreenUtil.screenWidthDp *
                                                  .65,
                                              child: Text(
                                                model.team.members[index].name,
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          color: Colors.grey[500],
                                          height: 0.2,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            Center(
                              child: Text(
                                locale.get('Invited Members') ??
                                    'Invited Members',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              height: ScreenUtil.screenHeightDp / 4,
                              child: ListView.builder(
                                itemCount: model.team.emailsOrPhones.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                                  AppColors.ternaryBackground,
                                              radius: 20,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: Container(
                                                    color: Colors.blue[900],
                                                    alignment: Alignment.center,
                                                    height: 45.0,
                                                    width: 45.0,
                                                    child: Text(
                                                      model.team
                                                          .emailsOrPhones[index]
                                                          .substring(0, 1)
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    )),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              width: ScreenUtil.screenWidthDp *
                                                  .65,
                                              child: Text(
                                                model
                                                    .team.emailsOrPhones[index],
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    height: 50.0,
                                    child: GestureDetector(
                                        onTap: () {
                                          model.exitTeam();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.red[200],
                                              style: BorderStyle.solid,
                                              width: 1.0,
                                            ),
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          child: Center(
                                            child: Text(
                                              locale.get('Exit from team') ??
                                                  'Exit from team',
                                              style: TextStyle(
                                                color: Colors.red[200],
                                                fontSize: 20,
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                          ),
                                        ))),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            );
          }),
    );
  }

  Widget selectCurruntTeambutton(
      BuildContext context, TeamMembersPageModel model) {
    final locale = AppLocalizations.of(context);

    return Button(
      color: Colors.white,
      borderColor: Colors.blue[900],
      text: locale.get('Change team') ?? 'Change team',
      textColor: Colors.blue[900],
      onClicked: () {
        return showDialog(
          context: context,
          builder: (context) {
            return ChangeTeamDialog();
          },
        );
      },
    );
  }
}

class TeamMembersPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  Teams team;

  final key = GlobalKey<ScaffoldState>();

  TeamMembersPageModel({NotifierState state, this.api, this.auth, this.context})
      : super(state: state) {
    getTeamById();
  }

  getTeamById() async {
    setBusy();
    team = await api.getTeamByTeamID(context,
        teamID: Preference.getString(PrefKeys.TEAM_ID));
    if (team != null) {
      setIdle();
    } else {
      setError();
    }
  }

  void exitTeam() async {
    bool res = false;
    setBusy();
    res = await api.exitTeam(context,
        teamId: Preference.getString(PrefKeys.TEAM_ID));
    if (res) {
      setIdle();
      await auth.signOut;
      UI.pushReplaceAll(context, Routes.signIn);
    } else {
      setError();
      UI.toast("Error in exiting team, please try again");
    }
  }
}

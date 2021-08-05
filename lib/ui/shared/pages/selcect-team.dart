import 'package:enna/core/models/user.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/core/services/localization/localization.dart';
import 'package:enna/core/services/preference/preference.dart';
import 'package:enna/ui/home/home_page.dart';
import 'package:enna/ui/shared/routes/route.dart';
import 'package:enna/ui/shared/widgets/buttons/raised_button.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:enna/ui/shared/styles/colors.dart';

class SelectTeamPage extends StatelessWidget {
  final bool isInvited;
  SelectTeamPage({this.isInvited});
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return FocusWidget(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BaseWidget<SelectTeamPageModel>(
            //initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.initializeProfileData()),
            model: SelectTeamPageModel(
                api: Provider.of<Api>(context),
                auth: Provider.of(context),
                context: context),
            builder: (context, model, child) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: ScreenUtil.screenHeightDp / 7),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Enna',
                          style: GoogleFonts.cairo(
                            textStyle: TextStyle(
                                color: AppColors.primaryText,
                                letterSpacing: .5,
                                fontSize: 40,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                          "${locale.get("Splitting made simpler") ?? "Splitting made simpler"} ",
                          style: GoogleFonts.cairo(
                            textStyle: TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 18,
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Container(
                        height: ScreenUtil.screenHeightDp / 2.9,
                        width: ScreenUtil.screenWidthDp / 1.15,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: isInvited
                              ? model.auth.user.user.invitedTeams.length
                              : model.auth.user.user.teams.length,
                          itemBuilder: (ctx, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: teams(ctx, model, index),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    createSkipButton(context, model),
                    createTeamButton(context, model),
                    confirmButton(context, model),
                    // selectCurruntTeambutton(context, model),
                  ],
                ),
              );
            }),
      ),
    );
  }

  Widget selectCurruntTeambutton(
      BuildContext context, SelectTeamPageModel model) {
    final locale = AppLocalizations.of(context);

    return Center(
      child: Container(
        width: 257,
        child: Button(
          color: Colors.blue[900],
          borderColor: Colors.white,
          text: "${locale.get("Add more members") ?? "Add more members"}: ",
          textColor: Colors.white,
          onClicked: () {},
        ),
      ),
    );
  }

  Widget teams(BuildContext context, SelectTeamPageModel model, int index) {
    return Container(
      child: RaisedButton(
        onPressed: () {
          model.selection = index;
          model.TEAM_ID = model.auth.user.user.teams[index];
          model.setState();
        },
        textColor: Colors.white,
        color: model.selection == index ? AppColors.primaryText : Colors.white,
        padding: const EdgeInsets.all(0.0),
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: model.selection == index
                  ? AppColors.primaryText
                  : AppColors.primaryText),
          borderRadius: new BorderRadius.circular(4.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Container(
            width: 250,
            height: 43,
            child: Center(
              child: model.auth.user.user.teams.length > 0
                  ? Text(
                      "${model.auth.user.user.teams[index].name.localied(context)}",
                      style: GoogleFonts.cairo(
                        textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: model.selection == index
                                ? Colors.white
                                : AppColors.primaryText),
                      ),
                    )
                  : SizedBox(),
            ),
          ),
        ),
      ),
    );
  }

  Widget createSkipButton(BuildContext context, SelectTeamPageModel model) {
    final locale = AppLocalizations.of(context);

    return Center(
      child: Container(
        width: ScreenUtil.screenWidthDp / 1.3,
        height: 70,
        child: Button(
          color: Colors.white,
          borderColor: AppColors.primaryText,
          text: "${locale.get("Skip this step") ?? "Skip this step"} ",
          textColor: AppColors.primaryText,
          onClicked: () async {
            UI.pushReplaceAll(
                context,
                HomePage(
                  noSeason: false,
                ));
          },
        ),
      ),
    );
  }

  Widget createTeamButton(BuildContext context, SelectTeamPageModel model) {
    final locale = AppLocalizations.of(context);

    return Center(
      child: Container(
        width: ScreenUtil.screenWidthDp / 1.3,
        height: 70,
        child: Button(
          color: AppColors.primaryText,
          // borderColor: ,
          text: "${locale.get("Create team") ?? "Create team"} ",

          textColor: Colors.white,
          onClicked: () async {
            UI.push(context, Routes.createTeam);
          },
        ),
      ),
    );
  }

  Widget confirmButton(BuildContext context, SelectTeamPageModel model) {
    return Center(
      child: Container(
        width: ScreenUtil.screenWidthDp / 1.3,
        height: 70,
        child: Button(
          color: AppColors.primaryText,
          // borderColor: ,
          text: "Confirm",
          textColor: Colors.white,
          onClicked: () async {
            if (model.TEAM_ID != null) {
              await Preference.setString(PrefKeys.TEAM_ID, model.TEAM_ID.id);

              if (Preference.getString(PrefKeys.TEAM_ID) != null) {
                // Check for active season
                if (model.TEAM_ID.season != null) {
                  UI.push(context, Routes.homePage, replace: true);
                } else {
                  UI.push(context, Routes.createSeason);
                }
              } else {
                UI.push(context, Routes.createTeam, replace: true);
              }
            } else {
              UI.toast("You must select a team!");
            }
          },
        ),
      ),
    );
  }
}

class SelectTeamPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  int selection = -1;
  Teams TEAM_ID;

  SelectTeamPageModel({NotifierState state, this.api, this.auth, this.context})
      : super(state: state);
}

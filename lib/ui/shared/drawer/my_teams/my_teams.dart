import 'package:enna/ui/shared/widgets/buttons/raised_button.dart';
import 'package:enna/ui/shared/widgets/drawer.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/ui/shared/routes/route.dart';
import 'package:enna/ui/shared/widgets/app_bar.dart';
import 'package:ui_utils/ui_utils.dart';

import '../../../../core/services/localization/localization.dart';

class MyTeamsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FocusWidget(
      child: BaseWidget<MyTeamsPageModel>(
          //initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.initializeProfileData()),
          model: MyTeamsPageModel(
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
                  child: Column(
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
                            locale.get('My Teams') ?? 'My Teams',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            locale.get('Current Team') ?? 'Current Team',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Pubg',
                            style: TextStyle(
                                fontSize: 20, color: Colors.blue[900]),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: Container(
                                height: 60,
                                child: RaisedButton(
                                    onPressed: () {
                                      UI.push(context, Routes.addContact);
                                    },
                                    textColor: Colors.white,
                                    color: Colors.blue[900],
                                    child: Center(
                                      child: Text(
                                        'New Team',
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
                                child: selectCurruntTeambutton(context, model)),
                          ),
                        ],
                      ),
                      ...List.generate(
                          5,
                          (index) => Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 0.2,
                                      width: ScreenUtil.screenWidthDp / 3,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              'Team 1',
                                              style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              '5 Members',
                                              style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'From : 01/10/2020',
                                              style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'To : 01/11/2020',
                                              style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
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
                              )),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Container(
                              width: MediaQuery.of(context).size.width / 2,
                              height: 50.0,
                              child: GestureDetector(
                                  onTap: () {
                                    UI.push(context, Routes.editProfile);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.red[200],
                                        style: BorderStyle.solid,
                                        width: 1.0,
                                      ),
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(5.0),
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

  teamsListDialog(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: ScreenUtil.screenHeightDp / 3,
              child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.cancel)),
                        ),
                        Text(
                          locale.get('Select Team') ?? 'Select Team',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        ...List.generate(
                          5,
                          (index) => Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  'Team1',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              Container(
                                width: ScreenUtil.screenWidthDp,
                                height: 0.2,
                                color: Colors.grey,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            ),
          );
        });
  }

  Widget selectCurruntTeambutton(BuildContext context, MyTeamsPageModel model) {
    final locale = AppLocalizations.of(context);

    return Expanded(
      child: Button(
        color: Colors.white,
        borderColor: Colors.blue[900],
        text: locale.get('Change team') ?? 'Change team',
        textColor: Colors.blue[900],
        onClicked: () {
          teamsListDialog(context);
        },
      ),
    );
  }
}

class MyTeamsPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  final key = GlobalKey<ScaffoldState>();

  MyTeamsPageModel({NotifierState state, this.api, this.auth, this.context})
      : super(state: state);
}

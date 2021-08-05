import 'package:enna/core/services/localization/localization.dart';
import 'package:enna/ui/shared/routes/route.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:ui_utils/ui_utils.dart';

class CreateSeasonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FocusWidget(
      child: Scaffold(
        backgroundColor: Colors.blue[900],
        body: BaseWidget<CreateSeasonPageModel>(
            //initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.initializeProfileData()),
            model: CreateSeasonPageModel(
                api: Provider.of<Api>(context),
                auth: Provider.of(context),
                context: context),
            builder: (context, model, child) {
              return Container(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(children: [
                      SizedBox(
                        height: 100,
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
                        height: 50,
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                "${locale.get("No Started Season's Yet") ?? "No Started Season's Yet"}: ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil.screenHeightDp / 3,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Container(
                              width: ScreenUtil.screenWidthDp / 1.2,
                              height: 50,
                              child: RaisedButton(
                                  onPressed: () {
                                    UI.push(context, Routes.campingDate);
                                  },
                                  textColor: Colors.blue[900],
                                  color: Colors.white,
                                  child: Text(
                                    "${locale.get("Create Season ?") ?? "Create Season ?"} ",
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
                        ],
                      ),
                    ]),
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class CreateSeasonPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  CreateSeasonPageModel(
      {NotifierState state, this.api, this.auth, this.context})
      : super(state: state);
}

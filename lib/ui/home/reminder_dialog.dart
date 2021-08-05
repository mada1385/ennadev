import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:enna/ui/shared/styles/colors.dart';

import '../../core/services/localization/localization.dart';

class ReminderDialog extends StatelessWidget {
  final String userId;
  final String senderId;
  final BuildContext ctx;

  ReminderDialog({this.userId, this.senderId, this.ctx});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FocusWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BaseWidget<ReminderDialogModel>(
            //initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.initializeProfileData()),
            model: ReminderDialogModel(
                api: Provider.of<Api>(context),
                auth: Provider.of(context),
                context: ctx),
            builder: (context, model, child) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0)), //this right here
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(ctx);
                          },
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.cancel)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: ScreenUtil.screenWidthDp / 3.5,
                            height: ScreenUtil.screenHeightDp / 4,
                            child: Image.asset(
                              'assets/images/reminder.png',
                            ),
                          ),
                        ),
                        Text(
                          locale.get('Send Reminder') ?? 'Send Reminder',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.normal),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              locale.get('Title') ?? 'Title',
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, bottom: 10),
                              child: TextFormField(
                                  controller: model.titleReminderController,
                                  decoration: new InputDecoration(
                                    hintText:
                                        locale.get("Type Reminder Title") ??
                                            "Type Reminder Title",
                                    hintStyle: TextStyle(fontSize: 13),
//                                  labelText: "Type a note about the reminder",
                                    labelStyle: TextStyle(color: Colors.grey),
                                    focusedBorder: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                          color: Colors.blue[700]),
                                    ),
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                    ),
                                  )),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              locale.get('Add a note') ?? 'Add a note',
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, bottom: 10),
                              child: TextFormField(
                                  controller: model.descrptionController,
                                  decoration: new InputDecoration(
                                    hintText: locale.get(
                                            'Type a note about the reminder') ??
                                        'Type a note about the reminder',
                                    hintStyle: TextStyle(fontSize: 13),
//                                  labelText: "Type a note about the reminder",
                                    labelStyle: TextStyle(color: Colors.grey),
                                    focusedBorder: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                          color: AppColors.ternaryBackground),
                                    ),
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        model.busy
                            ? Center(child: CircularProgressIndicator())
                            : Container(
                                width: ScreenUtil.screenWidthDp / 3,
                                child: RaisedButton(
                                  onPressed: () {
                                    model.sendReminder(ctx, senderId, userId);
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(5.0),
                                  ),
                                  child: Text(
                                    locale.get('Send') ?? 'Send',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: AppColors.ternaryBackground,
                                ),
                              )
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class ReminderDialogModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  ReminderDialogModel({NotifierState state, this.api, this.auth, this.context})
      : super(state: state);

  TextEditingController descrptionController = TextEditingController();
  TextEditingController titleReminderController = TextEditingController();

  sendReminder(BuildContext con, senderId, userId) async {
    bool res = false;
    setBusy();
    Map<String, dynamic> body = {
      "title": titleReminderController.text,
      "description": descrptionController.text,
      "sender": {"id": senderId},
      "user": {"id": userId},
    };
    res = await api.sendReminder(context, body: body);
    if (res) {
      Navigator.pop(con);
    } else {
      UI.toast("Error in reminding this user, please try again");
      setError();
    }
  }
}

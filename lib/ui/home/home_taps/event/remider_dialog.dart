import 'package:enna/core/models/event.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/core/services/localization/localization.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ui_utils/ui_utils.dart';

class EventRemiderDialog extends StatelessWidget {
  final BuildContext ctx;
  final oEvent event;

  EventRemiderDialog({this.ctx, this.event});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: BaseWidget<EventRemiderDialogModel>(
          //initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.initializeProfileData()),
          model: EventRemiderDialogModel(
              api: Provider.of<Api>(context),
              auth: Provider.of(context),
              event: event,
              context: context),
          builder: (context, model, child) {
            final locale = AppLocalizations.of(context);
            return SingleChildScrollView(
              child: ReactiveForm(
                formGroup: model.form,
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ReactiveDropdownField(
                          formControlName: 'userId',
                          items: event.members
                              .map((e) => DropdownMenuItem(
                                    child: Text(e.name),
                                    value: e.id,
                                  ))
                              .toList(),
                          decoration: InputDecoration(
                            // labelStyle: TextStyle(color: Colors.blue),
                            labelText: locale.get("Members") ?? "Members",
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Colors.blue[900],
                                width: 2.0,
                              ),
                            ),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: ReactiveFormConsumer(
                          builder: (context, formGroup, child) => model.busy
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Container(
                                  width: ScreenUtil.screenWidthDp * .8,
                                  height: 50,
                                  child: RaisedButton(
                                      onPressed: model.form.valid
                                          ? () {
                                              model.remind();
                                            }
                                          : null,
                                      textColor: Colors.white,
                                      color: Colors.blue[900],
                                      child: Text(
                                        locale.get("Remind") ?? "Remind",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      padding: const EdgeInsets.all(0.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(5.0),
                                      )),
                                )),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class EventRemiderDialogModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  oEvent event;

  FormGroup form;

  EventRemiderDialogModel(
      {NotifierState state, this.api, this.auth, this.context, this.event})
      : super(state: state) {
    form = FormGroup({
      "eventId": FormControl(value: event.id),
      "userId": FormControl(),
    });
  }

  void remind() async {
    bool res = false;
    setBusy();
    res = await api.remind(context: context, param: form.value);
    if (res) {
      Navigator.pop(context);
    } else {
      UI.toast("Error");
    }
  }
}

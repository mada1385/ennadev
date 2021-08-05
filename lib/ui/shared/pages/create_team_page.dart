import 'package:enna/core/models/user.dart';
import 'package:enna/core/services/localization/localization.dart';
import 'package:enna/core/services/preference/preference.dart';
import 'package:enna/core/utils/constants.dart';
import 'package:enna/ui/shared/routes/route.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:enna/ui/shared/widgets/buttons/raised_button.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../core/services/api/api.dart';
import '../../../core/services/api/http_api.dart';
import '../../../core/services/auth/authentication_service.dart';

class CreateTeamPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FocusWidget(
      child: Scaffold(
        body: BaseWidget<CreateTeamPageModel>(
            //initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.initializeProfileData()),
            model: CreateTeamPageModel(
                api: Provider.of<Api>(context),
                auth: Provider.of(context),
                context: context),
            builder: (context, model, child) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Container(
                        child: Center(
                            child: SvgPicture.asset('assets/images/team.svg')),
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 16),
                      child: Text(
                        "${locale.get("Enter Team Name") ?? "Enter Team Name"}: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 8),
                        child: ReactiveForm(
                          formGroup: model.form,
                          child: Column(
                            children: [
                              ReactiveTextField(
                                formControlName: 'name.en',
                                autofocus: true,
                                validationMessages: (control) => {
                                  "required":
                                      "${locale.get("Required") ?? "Required"}: ",
                                },
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.blue)),
                                  hintText:
                                      locale.get('Name in en') ?? 'Name in en',
                                ),
                              ),
                              ReactiveTextField(
                                formControlName: 'name.ar',
                                autofocus: true,
                                validationMessages: (control) => {
                                  "required":
                                      "${locale.get("Required") ?? "Required"}: ",
                                },
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.blue)),
                                  hintText:
                                      locale.get('Name in ar') ?? 'Name in ar',
                                ),
                              ),
                              Padding(
                                // #TODO: check Validation
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  "${locale.get("Add members to your team to start splitting hassle free") ?? "Required"}: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                              ReactiveFormArray(
                                formArrayName: 'emailsOrPhones',
                                builder: (context, formArray, child) {
                                  final locale = AppLocalizations.of(context);

                                  return ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: formArray.controls.length,
                                    itemBuilder: (ctx, index) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 8),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: ReactiveTextField(
                                                formControl:
                                                    formArray.controls[index],
                                                validationMessages: (control) =>
                                                    {
                                                  'required':
                                                      "${locale.get("Required") ?? "Required"}: ",
                                                  'pattern':
                                                      'Please enter a valid email or phone'
                                                },
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                decoration: InputDecoration(
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .grey)),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .blue)),
                                                    hintText: locale.get(
                                                            'Email or phone number of member ') ??
                                                        'Email or phone number of member ' +
                                                            (index + 1)
                                                                .toString()),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: formArray.controls.length >
                                                      1
                                                  ? () {
                                                      if (index != 0) {
                                                        formArray
                                                            .removeAt(index);
                                                      } else {
                                                        UI.toast(locale.get(
                                                                "please select atleast one member") ??
                                                            "please select atleast one member");
                                                      }
                                                    }
                                                  : UI.toast(locale.get(
                                                          "please select atleast one member") ??
                                                      "please select atleast one member"),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0, right: 8),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Icon(
                                                    MdiIcons.accountMinus,
                                                    color: Colors.blue[900],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              ReactiveFormConsumer(
                                builder: (context, form, child) {
                                  return Column(
                                    children: [
                                      model.busy
                                          ? Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : Center(
                                              child: Button(
                                                borderRadius: 5,
                                                color: Colors.indigo[800],
                                                text:
                                                    "${locale.get("Send invite") ?? "Send invite"}: ",
                                                onClicked: form.valid
                                                    ? () {
                                                        model.createTeam();
                                                      }
                                                    : () => UI.toast(locale.get(
                                                            "please select atleast one member") ??
                                                        "please select atleast one member"),
                                              ),
                                            ),
                                      Center(
                                        child: Button(
                                          borderRadius: 5,
                                          color: Colors.white,
                                          borderColor: Colors.blue[900],
                                          text:
                                              "${locale.get("Add more members") ?? "Add more members"}: ",
                                          textColor: Colors.blue[900],
                                          onClicked: model.form
                                                  .control('emailsOrPhones')
                                                  .valid
                                              ? () {
                                                  var formArray = model.form
                                                          .control(
                                                              'emailsOrPhones')
                                                      as FormArray<String>;
                                                  formArray.add(
                                                      FormControl<String>(
                                                          validators: [
                                                        Validators.pattern(Constants
                                                            .emailOrPhoneRegEx),
                                                        Validators.required,
                                                      ]));
                                                }
                                              : () => UI.toast(locale.get(
                                                      "please select atleast one member") ??
                                                  "please select atleast one member"),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              );
            }),
      ),
    );
  }
}

class CreateTeamPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  CreateTeamPageModel({NotifierState state, this.api, this.auth, this.context})
      : super(state: state);

  Teams TEAM_ID;

  final form = FormGroup({
    'name': FormGroup({
      "en": FormControl(
          validators: [Validators.required, Validators.minLength(3)]),
      "ar": FormControl(
          validators: [Validators.required, Validators.minLength(3)]),
    }),
    'emailsOrPhones': FormArray<String>([
      FormControl<String>(validators: [
        Validators.required,
        Validators.composeOR([
          Validators.pattern(Constants.internationalPhoneRegEx),
          Validators.minLength(8),
          Validators.email
        ])
      ]),
      FormControl<String>(
          validators: [Validators.pattern(Constants.emailOrPhoneRegEx)]),
      FormControl<String>(
          validators: [Validators.pattern(Constants.emailOrPhoneRegEx)])
    ]),
  });

  createTeam() async {
    setBusy();
    Map<String, dynamic> body = form.value;
    TEAM_ID = await api.createTeam(context, body: body);
    if (TEAM_ID != null) {
      await Preference.setString(PrefKeys.TEAM_ID, TEAM_ID.id);

      if (Preference.getString(PrefKeys.TEAM_ID) != null) {
        UI.pushReplaceAll(context, Routes.createSeason);
      } else {
        setError();
        UI.toast("error in saving team");
      }
    } else {
      setError();
      UI.toast("Error in creating team");
    }
  }
}

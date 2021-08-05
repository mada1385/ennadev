import 'package:intl/intl.dart';
import 'package:enna/core/models/user.dart';
import 'package:enna/core/services/preference/preference.dart';
import 'package:enna/ui/shared/routes/route.dart';
import 'package:enna/ui/shared/widgets/buttons/raised_button.dart';
import 'package:enna/ui/shared/widgets/drawer.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:enna/ui/shared/widgets/app_bar.dart';
import 'package:enna/core/services/localization/localization.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:rxdart/rxdart.dart';
import 'package:enna/ui/shared/styles/colors.dart';
import 'package:ui_utils/ui_utils.dart';

class AddEventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FocusWidget(
      child: BaseWidget<AddEventPageModel>(
          //initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.initializeProfileData()),
          model: AddEventPageModel(
              api: Provider.of<Api>(context),
              auth: Provider.of(context),
              context: context),
          builder: (context, model, child) {
            return Scaffold(
              key: model.key,
              drawer: AppDrawer(ctx: context),
              appBar: AppBarWidget(
                openDrawer: () => model.key.currentState.openDrawer(),
              ),
              body: SingleChildScrollView(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: model.busy
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(child: CircularProgressIndicator())
                            ],
                          )
                        : model.hasError
                            ? Center(
                                child: Text(
                                locale.get('Error') ?? 'Error',
                              ))
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      color: AppColors.secondaryText,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Text(
                                    "${locale.get("Add Event") ?? "Add Event"}",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: AppColors.blackText,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  ReactiveForm(
                                      formGroup: model.form,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "${locale.get("Event Title") ?? "Event Title"}"),
                                          buildReactiveTitle(locale),
                                          Text(
                                            "${locale.get("Repeat") ?? "Repeat"}",
                                            style: TextStyle(
                                                color: Colors.grey.shade600),
                                          ),
                                          buildReactiveRepeatDropDown(
                                              context, model),
                                          Text(
                                            "${locale.get("Start date") ?? "Start date"}",
                                            style: TextStyle(
                                                color: Colors.grey.shade600),
                                          ),
                                          buildRecievedStartDate(
                                              context, model),
                                          Text(
                                            "${locale.get("Members Responsible") ?? "Members Responsible"}",
                                            style: TextStyle(
                                                color: Colors.grey.shade600),
                                          ),
                                          buildRecievedMemberResponsible(
                                              context, model),
                                          ReactiveFormConsumer(
                                            builder: (context, form, child) {
                                              return Column(
                                                children: [
                                                  Center(
                                                    child: Button(
                                                        borderRadius: 5,
                                                        color: Colors.white,
                                                        borderColor:
                                                            Colors.blue[900],
                                                        text: locale.get(
                                                                "Add more members") ??
                                                            "Add more members",
                                                        textColor:
                                                            Colors.blue[900],
                                                        onClicked: () {
                                                          var formArray =
                                                              form.control(
                                                                      'members')
                                                                  as FormArray<
                                                                      Members>;
                                                          formArray.add(
                                                            FormControl<
                                                                    Members>(
                                                                validators: [
                                                                  Validators
                                                                      .required,
                                                                ]),
                                                          );
                                                        }),
                                                  ),
                                                  model.busy
                                                      ? Center(
                                                          child:
                                                              CircularProgressIndicator())
                                                      : Center(
                                                          child: Button(
                                                            borderRadius: 5,
                                                            color: Colors
                                                                .indigo[800],
                                                            text: locale.get(
                                                                    "Add Event") ??
                                                                "Add Event",
                                                            onClicked:
                                                                form.valid
                                                                    ? () {
                                                                        model
                                                                            .addEvent();
                                                                      }
                                                                    : null,
                                                          ),
                                                        ),
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Container buildRecievedStartDate(context, AddEventPageModel model) {
    final locale = AppLocalizations.of(context);
    return Container(
        height: 50.0,
        child: ReactiveDatePicker(
          formControlName: 'startDate',
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
          locale: locale.locale,
          builder: (context, picker, child) {
            return ReactiveTextField(
                onTap: picker.showPicker,
                onSubmitted: () {
                  String formated = DateFormat('yyyy-MM-dd')
                      .format(model.form.control('startDate').value);
                  model.form.control('startDate').updateValue(formated);
                },
                // controller: model.form.control ,
                formControlName: 'startDate',
                readOnly: true,
                decoration: new InputDecoration(
                  hintStyle: TextStyle(fontSize: 13),
                  hintText: "${locale.get("Start Date") ?? "Start Date"}",
                  // labelText: "Enter Title of event",
                  labelStyle: TextStyle(color: Colors.grey.shade400),
                  focusedBorder: new OutlineInputBorder(
                    borderSide:
                        new BorderSide(color: AppColors.ternaryBackground),
                  ),
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                    borderSide: new BorderSide(color: AppColors.border),
                  ),
                ));
          },
        ));
  }

  Padding buildReactiveTitle(AppLocalizations locale) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 10),
      child: ReactiveTextField(
          formControlName: 'title',
          decoration: new InputDecoration(
            hintStyle: TextStyle(fontSize: 13),
            hintText:
                "${locale.get("Enter title of event") ?? "Enter title of event"}",
            // labelText: "Enter Title of event",
            labelStyle: TextStyle(color: AppColors.hintText),
            focusedBorder: new OutlineInputBorder(
              borderSide: new BorderSide(color: AppColors.ternaryBackground),
            ),
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(5.0),
              borderSide: new BorderSide(color: AppColors.border, width: 0.2),
            ),
          )),
    );
  }

  buildRecievedMemberResponsible(
      BuildContext context, AddEventPageModel model) {
    final locale = AppLocalizations.of(context);
    return Container(
        // height: 200,
        width: ScreenUtil.screenWidthDp,
        child: Padding(
            padding: const EdgeInsets.all(0),
            child: ReactiveFormArray(
                formArrayName: 'members',
                builder: (BuildContext context, FormArray<dynamic> formArray,
                    Widget child) {
                  return Column(
                    children: [
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: formArray.controls.length,
                          itemBuilder: (ctx, index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ReactiveDropdownField(
                                          isExpanded: true,
                                          formControl:
                                              formArray.controls[index],
                                          // formControl:
                                          //     formArray.controls[index],
                                          validationMessages: (control) => {
                                            'required': "Required",
                                            'pattern':
                                                'Please enter a valid email or phone'
                                          },

                                          items:
                                              model.team.members.map((member) {
                                            return DropdownMenuItem(
                                                value: member,
                                                child: Text(member.name));
                                          }).toList(),
                                          decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.blue)),
                                              hintText:
                                                  "${locale.get("Select member") ?? "Select member"}" +
                                                      (index + 1).toString()),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: formArray.controls.length > 1
                                            ? () {
                                                formArray.removeAt(index);
                                              }
                                            : null,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8),
                                          child: Align(
                                            alignment: Alignment.centerRight,
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
                              ))
                    ],
                  );
                })));
  }

  Widget buildReactiveRepeatDropDown(
      BuildContext context, AddEventPageModel model) {
    final locale = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: AppColors.border),
        ),
        child: ReactiveDropdownField(
            formControlName: 'repeat',
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10)),
            items: [
              DropdownMenuItem(
                child: Text(
                  locale.get("daily") ?? "daily",
                  style: TextStyle(color: AppColors.blackText),
                ),
                value: "daily",
              ),
              DropdownMenuItem(
                child: Text(
                  locale.get("weekly") ?? "weekly",
                  style: TextStyle(color: AppColors.blackText),
                ),
                value: "weekly",
              ),
              DropdownMenuItem(
                child: Text(
                  locale.get("monthly") ?? "monthly",
                  style: TextStyle(color: AppColors.blackText),
                ),
                value: "monthly",
              ),
            ]),
      ),
    );
  }
}

class AddEventPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  final formKey = GlobalKey<FormState>();
  final key = GlobalKey<ScaffoldState>();

  String startDate;

  Teams team;
  Members selectedMember;

  List<Members> membersList;

  String repeat;

  Map<String, dynamic> body;

  TextEditingController eventController = TextEditingController();

  AddEventPageModel({NotifierState state, this.api, this.auth, this.context})
      : super(state: state) {
    membersList = [];
    getTeam();
  }

  getTeam() async {
    setBusy();
    team = Preference.getString(PrefKeys.TEAM_ID) == null
        ? UI.pushReplaceAll(context, Routes.creatOrJoinTeam)
        : await api.getTeamByTeamID(context,
            teamID: Preference.getString(PrefKeys.TEAM_ID));

    if (team != null) {
      setIdle();
    } else {
      setError();
    }
  }

  final FormGroup form = fb.group(
    {
      'title': FormControl(validators: [
        Validators.required,
      ]),
      "repeat": FormControl(value: "weekly", validators: [Validators.required]),
      "startDate": FormControl<String>(validators: [Validators.required]),
      "members": FormArray<Members>([
        FormControl(validators: [
          Validators.required,
        ]),
      ], validators: [
        Validators.required
      ]),
      "team": FormControl(),
    },
    [Validators.required],
  );

  removeMember(int index) {
    membersList.removeAt(index);
    setState();
  }

  addEvent() async {
    print(form.value);
    form.control("team").updateValue(team);
    List<Members> members = form.control("members").value;
    List<Members> newMembers =
        await Stream.fromIterable(members).distinctUnique().toList();
    form.control("members").updateValue(newMembers);
    String formatedDate = DateFormat('yyyy-MM-dd')
        .format(DateTime.parse(form.control('startDate').value));
    form.control('startDate').updateValue(formatedDate);
    bool res = false;
    var value = form.value;
    form.control('startDate').updateValue(
          DateFormat('yyyy-MM-dd')
              .format(DateTime.parse(form.control('startDate').value)),
        );
    res = await api.createEvent(context, body: value);
    if (res) {
      Navigator.pop(context);
    } else {
      setError();
      UI.toast("Error in creating event");
    }
  }
}

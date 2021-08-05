import 'package:enna/core/models/user.dart';
import 'package:enna/core/services/preference/preference.dart';
import 'package:enna/ui/shared/routes/route.dart';
import 'package:enna/ui/shared/widgets/app_bar.dart';
import 'package:enna/ui/shared/widgets/drawer.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:provider/provider.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/core/services/localization/localization.dart';
import 'package:intl/intl.dart';
import 'package:enna/ui/shared/styles/colors.dart';
import 'package:enna/ui/shared/widgets/main_dropdown.dart';

class AddCashPage extends StatelessWidget {
  //TODo: Form array

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return FocusWidget(
      child: BaseWidget<AddCashPageModel>(
          //initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.initializeProfileData()),
          model: AddCashPageModel(
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
                                  Center(
                                    child: SvgPicture.asset(
                                      'assets/images/addcash.svg',
                                    ),
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        "${locale.get("Add Cash") ?? "Event Title"}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: AppColors.blackText,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  ReactiveForm(
                                      formGroup: model.form,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${locale.get("Amount") ?? "Amount"}",
                                            style: TextStyle(
                                                color: Colors.grey.shade600),
                                          ),
                                          buildAmountReactive(locale),
                                          Text(
                                            "${locale.get("Received from") ?? "Received from"}",
                                            style: TextStyle(
                                                color: Colors.grey.shade600),
                                          ),
                                          if (model.team != null)
                                            buildRecievedFromReactive(
                                                model, locale),
                                          Text(
                                            "${locale.get("Received date") ?? "Received date"}",
                                            style: TextStyle(
                                                color: Colors.grey.shade600),
                                          ),
                                          buildRecievedDateReactive(
                                              context, model),
                                          ReactiveFormConsumer(
                                            builder: (context, form, child) {
                                              return !model.busy
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20.0),
                                                      child: Center(
                                                          child: Container(
                                                              height: 50,
                                                              width: ScreenUtil
                                                                      .screenWidthDp *
                                                                  .8,
                                                              child:
                                                                  RaisedButton(
                                                                      onPressed:
                                                                          () {
                                                                        model
                                                                            .addCash();
                                                                      },
                                                                      textColor:
                                                                          Colors
                                                                              .white,
                                                                      color: Colors.blue[
                                                                          900],
                                                                      child:
                                                                          Text(
                                                                        "${locale.get("Add") ?? "Add"}",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              0.0),
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            new BorderRadius.circular(5.0),
                                                                      )))))
                                                  : Center(
                                                      child:
                                                          CircularProgressIndicator());
                                            },
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Container buildRecievedDateReactive(
      BuildContext context, AddCashPageModel model) {
    final locale = AppLocalizations.of(context);
    return Container(
        height: 50.0,
        child: ReactiveTextField(
          formControlName: 'receivedDate',
          readOnly: true,
          validationMessages: (control) => {
            'required': locale.get("Received Date is required") ??
                "Received Date is required"
          },
          decoration: InputDecoration(
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(5.0),
              borderSide: new BorderSide(color: Colors.black),
            ),
          ),
          onTap: () async {
            var date = await showDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime(2019),
              lastDate: DateTime.now(),
              // initialTime: TimeOfDay.now(),
              context: context,
            );

            model.receivedDateController.text =
                DateFormat('yyyy-MM-dd').format(date);

            model.form.control('receivedDate').value =
                model.receivedDateController.text;

            model.setState();

            print(model.form.value);
          },
          // decoration: InputDecoration(
          //   suffixIcon: ReactiveDatePicker(
          //     formControlName: 'receivedDate',
          //     firstDate: DateTime(1985),
          //     lastDate: DateTime(2030),

          //     builder: (context, picker, child) {
          //       return IconButton(
          //         onPressed: picker.showPicker,
          //         icon: Icon(Icons.date_range),
          //       );
          //     },
          //   ),
          // ),
        ));
  }

  Widget buildRecievedFromReactive(AddCashPageModel model, locale) {
    return MainReactiveDropDown(
      controllerName: "recevedFrom",
      label: locale.get("Select Member") ?? "Select Member",
      itemList: model.team.members
          .map((member) => DropdownMenuItem<Members>(
                child: Text(member.name),
                value: member,
              ))
          .toList(),
    );
  }

  Padding buildAmountReactive(AppLocalizations locale) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
      child: Container(
        height: 60,
        child: ReactiveTextField(
            keyboardType: TextInputType.number,
            formControlName: 'amount',
            decoration: new InputDecoration(
              hintText:
                  "${locale.get("Enter amount received") ?? "Enter amount received"}",
              hintStyle: TextStyle(fontSize: 13),
              labelStyle: TextStyle(color: Colors.grey),
              focusedBorder: new OutlineInputBorder(
                borderSide: new BorderSide(color: AppColors.ternaryBackground),
              ),
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(5.0),
                borderSide: new BorderSide(color: AppColors.border),
              ),
            )),
      ),
    );
  }
}

class AddCashPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  String recievedDate;
  TextEditingController amountController = TextEditingController();
  Teams team;
  Members selectedMember;
  Map<String, dynamic> body;
  final key = GlobalKey<ScaffoldState>();

  TextEditingController receivedDateController = TextEditingController();

  AddCashPageModel({NotifierState state, this.api, this.auth, this.context})
      : super(state: state) {
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

  FormGroup form = fb.group(
    {
      'amount':
          FormControl(validators: [Validators.required, Validators.number]),
      'recevedFrom': FormControl(validators: [Validators.required]),
      'receivedDate': FormControl<String>(
          value: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          validators: [
            Validators.required,
          ]),
      "team": FormControl()
    },
    [Validators.required],
  );

  void addCash() async {
    bool res = false;
    setBusy();

    form.control('team').updateValue({"id": team.id});

    res = await api.addCash(context, body: form.value);

    res != null
        ? Navigator.pop(context, true)
        : UI.toast("Error in adding cash");
  }
}

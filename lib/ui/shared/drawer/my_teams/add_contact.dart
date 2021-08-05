import 'package:enna/core/models/user.dart';
import 'package:enna/core/services/localization/localization.dart';
import 'package:enna/core/services/preference/preference.dart';
import 'package:enna/core/utils/constants.dart';
import 'package:enna/ui/shared/widgets/buttons/raised_button.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/ui/shared/widgets/app_bar.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ui_utils/ui_utils.dart';

class AddContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FocusWidget(
      child: BaseWidget<AddContactPageModel>(
          //initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.initializeProfileData()),
          model: AddContactPageModel(
              api: Provider.of<Api>(context),
              auth: Provider.of(context),
              context: context),
          builder: (context, model, child) {
            return Scaffold(
              key: model.key,
              appBar: AppBarWidget(
                openDrawer: () => model.key.currentState.openDrawer(),
              ),
              body: SingleChildScrollView(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                      Center(
                                          child: Text(
                                        locale.get('Add member') ??
                                            'Add member',
                                        style: TextStyle(fontSize: 20),
                                      )),
                                      SizedBox(
                                        width: ScreenUtil.screenWidthDp * 0.1,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  buildForm(context, model),
                                ],
                              ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  buildForm(BuildContext context, AddContactPageModel model) {
    final locale = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Center(child: SvgPicture.asset('assets/images/team.svg')),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
            child: ReactiveForm(
              formGroup: model.form,
              child: Column(
                children: [
                  Padding(
                    // #TODO: check Validation
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      locale.get(
                              'Add members to your team to start splitting hassle free') ??
                          'Add members to your team to start splitting hassle free',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  ReactiveFormArray(
                    formArrayName: 'emailsOrPhones',
                    builder: (context, formArray, child) {
                      return ListView.builder(
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
                                        child: ReactiveTextField(
                                          formControl:
                                              formArray.controls[index],
                                          validationMessages: (control) => {
                                            'required': "Required",
                                            'pattern':
                                                'Please enter a valid email or phone'
                                          },
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.blue)),
                                              hintText: locale.get(
                                                      'Email or phone number of member ') ??
                                                  'Email or phone number of member ' +
                                                      (index + 1).toString()),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: formArray.controls.length > 1
                                            ? () {
                                                if (index != 0) {
                                                  formArray.removeAt(index);
                                                } else {
                                                  UI.toast(locale.get(
                                                          "please select atleast one member") ??
                                                      "please select atleast one member");
                                                }
                                              }
                                            : () => UI.toast(locale.get(
                                                    "please select atleast one member") ??
                                                "please select atleast one member"),
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
                              ));
                    },
                  ),
                  ReactiveFormConsumer(
                    builder: (context, form, child) {
                      return Column(
                        children: [
                          model.busy
                              ? Center(child: CircularProgressIndicator())
                              : Center(
                                  child: Button(
                                    borderRadius: 5,
                                    color: Colors.indigo[800],
                                    text: locale.get('Add') ?? 'Add',
                                    onClicked: form.valid
                                        ? () {
                                            model.addMember();
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
                                text: locale.get('Add more members') ??
                                    'Add more members',
                                textColor: Colors.blue[900],
                                onClicked:
                                    //  model.form
                                    //         .control('emailsOrPhones')
                                    //         .valid
                                    //     ?
                                    () {
                                  var formArray =
                                      model.form.control('emailsOrPhones')
                                          as FormArray<String>;
                                  formArray.add(FormControl<String>(
                                      validators: [
                                        Validators.required,
                                        Validators.pattern(
                                            Constants.emailOrPhoneRegEx)
                                      ]));
                                }
                                // : () => UI.toast(locale.get(
                                //         "please select atleast one member") ??
                                //     "please select atleast one member"),
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
    );
  }

  Widget buildTextFormField(
      {TextEditingController controller,
      String hint,
      TextInputType keyboard,
      Function(String) validator,
      bool secure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: secure,
        keyboardType: keyboard,
        maxLines: 1,
        decoration: new InputDecoration(
          // labelStyle: TextStyle(color: Colors.blue),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0),
            borderSide: BorderSide(
              color: Colors.blue,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Colors.grey,
              width: .5,
            ),
          ),
          // labelText: hint,
          // fillColor: Colors.grey,
          hintText: hint,
          hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
          //       labelStyle: TextStyle(color: Colors.black),
          // fillColor: Colors.white,
        ),
      ),
    );
  }
}

class AddContactPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  final formKey = GlobalKey<FormState>();
  final key = GlobalKey<ScaffoldState>();

  TextEditingController memberController = TextEditingController();


  Teams team;

  AddContactPageModel({NotifierState state, this.api, this.auth, this.context})
      : super(state: state) {
    getTeam();
  }

  getTeam() async {
    setBusy();
    team = await api.getTeamByTeamID(context,
        teamID: Preference.getString(PrefKeys.TEAM_ID));

    team != null ? setIdle() : setError();
  }

  final form = FormGroup({
    'emailsOrPhones': FormArray<String>([
      FormControl<String>(validators: [
        Validators.required,
        // Validators.pattern(Constants.emailOrPhoneRegEx)
      ]),
      FormControl<String>(validators: [
        // Validators.pattern(Constants.emailOrPhoneRegEx)
      ]),
      FormControl<String>(validators: [
        // Validators.pattern(Constants.emailOrPhoneRegEx)
      ])
    ]),
  });

  void addMember() async {
    bool res = false;
    setBusy();
    res = await api
        .addMember(context, body: form.value, param: {'teamId': team.id});
    if (res) {
      Navigator.pop(context, true);
    } else {
      setError();
      UI.toast("You can't add membes now, Please try again");
    }
  }
}

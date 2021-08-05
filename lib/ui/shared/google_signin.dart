import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/core/services/localization/localization.dart';
import 'package:enna/core/services/notification/notification_service.dart';
import 'package:enna/core/services/preference/preference.dart';
import 'package:enna/core/utils/constants.dart';
import 'package:enna/ui/shared/routes/route.dart';
import 'package:enna/ui/shared/styles/colors.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:ui_utils/ui_utils.dart';
//#TODO: remove email validation
import 'package:google_fonts/google_fonts.dart';

class GoogleSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return FocusWidget(
      child: BaseWidget<GoogleSignInPageModel>(
          //initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.initializeProfileData()),
          model: GoogleSignInPageModel(
              api: Provider.of<Api>(context),
              auth: Provider.of(context),
              context: context),
          builder: (context, model, child) {
            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 80,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              "${locale.get('Language') ?? "Language"}: ",
                              style: GoogleFonts.cairo(
                                  textStyle: TextStyle(color: Colors.grey)),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: ToggleSwitch(
                              minWidth: 68,
                              minHeight: 38,
                              cornerRadius: 3.0,
                              initialLabelIndex: model.selectedLanguage,
                              activeBgColor: [AppColors.primaryText],
                              inactiveBgColor: AppColors.primaryBackground,
                              changeOnTap: true,
                              labels: ['EN', 'عر'],
                              onToggle: (index) {
                                print('switched to: $index');
                                model.selectedLanguage = index;
                                Provider.of<AppLanguageModel>(context,
                                        listen: false)
                                    .changeLanguage(
                                        Locale(index == 0 ? 'en' : 'ar'));
                                model.setState();
                                // Preference.setBool(PrefKeys.firstLaunch, false);
                                // UI.push(context, Routes.home);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
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
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Text(
                              locale.get("Login to your account") ??
                                  "Login to your account",
                              style: GoogleFonts.cairo(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                  )),
                            ),
                          ),
                          ReactiveForm(
                            formGroup: model.form,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: ReactiveTextField(
                                    formControlName: 'email',
                                    keyboardType: TextInputType.emailAddress,
                                    validationMessages: (control) => {
                                      'required': locale.get(
                                              "Email or phone is required") ??
                                          "Email or phone is required",
                                      'pattern': locale.get(
                                              "Provide A Valid Email Or Phone") ??
                                          "Please enter a valid email or phone"
                                    },
                                    decoration: new InputDecoration(
                                      labelText:
                                          locale.get("Email or phone number") ??
                                              "Email or phone number",
                                      labelStyle: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                              color: model.myFocusNode.hasFocus
                                                  ? AppColors.ternaryBackground
                                                  : Colors.black)),
                                      focusedBorder: new OutlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: AppColors.ternaryBackground),
                                      ),
                                      border: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(4.0),
                                        borderSide:
                                            new BorderSide(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: ReactiveTextField(
                                    formControlName: 'password',
                                    obscureText: true,
                                    keyboardType: TextInputType.emailAddress,
                                    validationMessages: (control) => {
                                      'required':
                                          locale.get("Password is required") ??
                                              "Password is required",
                                      'minLength': locale.get(
                                              'Password must exceed 8 characters') ??
                                          'Password must exceed 8 characters'
                                    },
                                    decoration: new InputDecoration(
                                      labelText:
                                          locale.get("Password") ?? "Password",
                                      labelStyle: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                              color: model.myFocusNode.hasFocus
                                                  ? AppColors.ternaryBackground
                                                  : Colors.black)),
                                      fillColor: Colors.white,
                                      focusedBorder: new OutlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: AppColors.ternaryBackground),
                                      ),
                                      border: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(4.0),
                                        borderSide: new BorderSide(),
                                      ),
                                    ),
                                  ),
                                ),
                                // ReactiveCheckboxListTile(
                                //   formControlName: "rememberMe",
                                //   // formControl: FormControl(),
                                //   title: Text(
                                //       '${locale.get("Remember me") ?? "Remember me"}'),
                                //   checkColor: Colors.blue[900],
                                // ),
                                ReactiveFormConsumer(
                                  builder: (context, form, child) {
                                    return !model.busy
                                        ? Container(
                                            width: 257,
                                            height: 43,
                                            child: RaisedButton(
                                                onPressed: model.form.valid
                                                    ? () {
                                                        model.signIn();
                                                      }
                                                    : null,
                                                textColor: Colors.white,
                                                color: AppColors.primaryText,
                                                child: Text(
                                                  locale.get("Sign in") ??
                                                      "Sign in",
                                                  style: GoogleFonts.cairo(
                                                      textStyle: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          5.0),
                                                )),
                                          )
                                        : Center(
                                            child: CircularProgressIndicator());
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                locale.get("Don't have account?") ??
                                    "Don't have account?",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.cairo(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                    )),
                              ),
                              InkWell(
                                child: Text(
                                  " ${locale.get('Sign up') ?? "Sign up"}",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.cairo(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      textStyle: TextStyle(
                                        color: Colors.blue[900],
                                      )),
                                ),
                                onTap: () {
                                  UI.push(context, Routes.signUp);
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class GoogleSignInPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  int selectedLanguage = 0;

  GoogleSignInPageModel(
      {NotifierState state, this.api, this.auth, this.context})
      : super(state: state) {
    selectedLanguage =
        AppLocalizations.of(context).locale.languageCode == 'en' ? 0 : 1;
  }
  final form = FormGroup({
    'email': FormControl(validators: [
      Validators.required,
      Validators.composeOR([
        Validators.pattern(Constants.internationalPhoneRegEx),
        Validators.minLength(8),
        Validators.email
      ])
    ]),
    'password':
        FormControl(validators: [Validators.required, Validators.minLength(8)]),
    // 'rememberMe': FormControl<bool>(value: false),
  });

  final formKey = new GlobalKey<FormState>();
  FocusNode myFocusNode = new FocusNode();

  Map<String, dynamic> body;

  signIn() async {
    bool res = false;
    setBusy();
    final locale = AppLocalizations.of(context);
    res = await auth.signIn(context, body: form.value);
    if (res) {
      if (Preference.getString(PrefKeys.fcmToken) == null) {
        await Provider.of<NotificationService>(context, listen: false)
            .init(context);
      }
      var res = await api.sendFcmToken(
          context, Preference.getString(PrefKeys.fcmToken), auth.user.user.id);

      var user = auth.user.user;
      if (res != null) {
        user.fcmToken = res;
      }

      // if (form.control('rememberMe').value == true) {
      // save user id to sharedPrefrences

      await Preference.setString(PrefKeys.USER_TOKEN, auth.user.token);
      await Preference.setString(PrefKeys.USER_ID, auth.user.user.id);
      // }

      // check if selected team in sharedPreferences
      if (Preference.getString(PrefKeys.TEAM_ID) != null) {
        UI.pushReplaceAll(context, Routes.homePage);
      } else {
        // check if invitedTeams.length > 0 && has no teams
        if (user.invitedTeams.length > 0 && user.teams.length == 0) {
          // goto create or join
          UI.pushReplaceAll(
            context,
            Routes.selectFromInvitations,
          );
        } else {
          // check if invitedTeams.length = 0 && has a team
          if (user.invitedTeams.length == 0 && user.teams.length != 0) {
            // goto Select Teams
            UI.pushReplaceAll(context, Routes.selectTeam(isInvited: false));
          } else if (user.invitedTeams.length == 0 && user.teams.length == 0) {
            UI.pushReplaceAll(context, Routes.createTeam);
          } else if (user.invitedTeams.length != 0 && user.teams.length != 0) {
            UI.pushReplaceAll(context, Routes.selectFromInvitations);
          }
        }
      }

      // UI.push(context, Routes.homePage, replace: true);
    } else {
      UI.toast(locale.get("Username or password is not correct") ??
          "Username or password is not correct");
      setError();
    }
  }
}

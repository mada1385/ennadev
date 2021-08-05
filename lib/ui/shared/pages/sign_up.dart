import 'dart:io';

import 'package:enna/core/services/localization/localization.dart';
import 'package:enna/core/services/preference/preference.dart';
import 'package:enna/core/utils/constants.dart';
import 'package:enna/ui/shared/routes/route.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/api/api.dart';
import '../../../core/services/api/http_api.dart';
import '../../../core/services/auth/authentication_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:enna/ui/shared/styles/colors.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return SafeArea(
      child: FocusWidget(
        child: BaseWidget<SignUpPageModel>(
            //initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.initializeProfileData()),
            model: SignUpPageModel(
                api: Provider.of<Api>(context),
                auth: Provider.of(context),
                context: context),
            builder: (context, model, child) {
              return Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 25,
                      ),
                      // appBar
                      buildAppBar(context, model),

                      // Logo
                      buildLogo(),

                      // image
                      buildImage(model, context),

                      // signUpform
                      buildSignUpForm(context, model),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  buildAppBar(BuildContext context, SignUpPageModel model) {
    final locale = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 5, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios)),
          Row(
            children: [
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
                          Provider.of<AppLanguageModel>(context, listen: false)
                              .changeLanguage(Locale(index == 0 ? 'en' : 'ar'));
                          model.setState();
                          // Preference.setBool(PrefKeys.firstLaunch, false);
                          // UI.push(context, Routes.home);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  buildLogo() {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, bottom: 25),
      child: Container(
        height: ScreenUtil.screenHeightDp / 15,
        child: Center(child: SvgPicture.asset('assets/images/Enna.svg')),
      ),
    );
  }

  buildSignUpForm(BuildContext context, SignUpPageModel model) {
    final locale = AppLocalizations.of(context);
    return ReactiveForm(
      formGroup: model.form,
      child: Padding(
        padding: const EdgeInsets.only(left: 50.0, right: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${locale.get("Create your account") ?? "Create your account"}",
                style: GoogleFonts.cairo(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildReactiveTextField(
                  controllerName: 'name',
                  hint: "${locale.get("Name") ?? "Name"}",
                  validationMessages: {
                    'minLength':
                        locale.get('Name must be at least 3 characters') ??
                            "Name must be at least 3 characters",
                    'required':
                        locale.get('Name is required') ?? "Name is required"
                  },
                  keyboard: TextInputType.emailAddress),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildReactiveTextField(
                  controllerName: 'email',
                  hint: "${locale.get("Email") ?? "Email"}",
                  validationMessages: {
                    'pattern': locale.get('Email must be valid') ??
                        "Email must be valid",
                    'required': locale.get('Required') ?? "Required"
                  },
                  keyboard: TextInputType.emailAddress),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildReactiveTextField(
                  controllerName: 'mobile',
                  validationMessages: {
                    'pattern': 'Phone must be valid',
                    'required': 'Required'
                  },
                  hint: "${locale.get("Phone Number") ?? "Phone Number"}",
                  keyboard: TextInputType.phone),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildReactiveTextField(
                  controllerName: 'password',
                  hint: "${locale.get("Password") ?? "Password"}",
                  validationMessages: {
                    'required': locale.get('Required') ?? "Required",
                    'minLength':
                        locale.get('Password must be at least 8 characters') ??
                            "Password must be at least 8 characters",
                    'mustMatch': locale.get("Passwords doesn't match") ??
                        "Passwords doesn't match"
                  },
                  keyboard: TextInputType.emailAddress,
                  secure: true),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildReactiveTextField(
                  controllerName: 'confirmPassword',
                  validationMessages: {
                    'required': locale.get('Required') ?? "Required",
                    'minLength':
                        locale.get('Password must be at least 8 characters') ??
                            "Password must be at least 8 characters",
                    'mustMatch': locale.get("Passwords doesn't match") ??
                        "Passwords doesn't match"
                  },
                  hint:
                      "${locale.get("Confirm Password") ?? "Confirm Password"}",
                  keyboard: TextInputType.emailAddress,
                  secure: true),
            ),
            model.busy
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Container(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator()),
                    ),
                  )
                : Center(child: buildSignUpButton(context, model))
          ],
        ),
      ),
    );
  }

  Widget buildReactiveTextField(
      {String controllerName,
      String hint,
      TextInputType keyboard,
      Map<String, String> validationMessages,
      bool secure = false}) {
    return ReactiveTextField(
      formControlName: controllerName,
      obscureText: secure,
      keyboardType: keyboard,
      maxLines: 1,
      validationMessages: (controllerName) => validationMessages,
      decoration: new InputDecoration(
        // labelStyle: TextStyle(color: Colors.blue),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(color: AppColors.primaryText, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        labelText: hint,
        // fillColor: Colors.grey,
        labelStyle:
            GoogleFonts.cairo(textStyle: TextStyle(color: Colors.black)),
        // fillColor: Colors.white,
      ),
    );
  }

  buildSignUpButton(BuildContext context, SignUpPageModel model) {
    final locale = AppLocalizations.of(context);
    return ReactiveFormConsumer(builder: (context, formGroup, child) {
      return GestureDetector(
        onTap: formGroup.valid
            ? () {
                model.signUp();
              }
            : null,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          width: 257,
          height: 43,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: formGroup.valid ? Colors.blue[800] : Colors.grey,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text("${locale.get("Sign up") ?? "Sign up"}",
              style: GoogleFonts.cairo(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              )),
        ),
      );
    });
  }

  buildImage(SignUpPageModel model, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            model.uploadPhoto();
            // model.uploadImage();
          },
          child: model.uploading
              ? Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: model.choosedImage == null
                          ? Colors.blue[900]
                          : Colors.transparent,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: model.busy
                            ? Center(child: CircularProgressIndicator())
                            : model.choosedImage == null
                                ? Container(
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  )
                                : Container(
                                    width: 40,
                                    height: 40,
                                    child: Image.file(
                                      model.choosedImage,
                                      width: 40,
                                      height: 40,
                                    ),
                                  ),
                      ),
                    ),
                    Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(50)),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            )))
                  ],
                ),
        ),
      ],
    );
  }
}

class SignUpPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  int selectedLanguage = 0;
  AppLocalizations locale;

  SignUpPageModel({NotifierState state, this.api, this.auth, this.context})
      : super(state: state) {
    locale = AppLocalizations.of(context);
    selectedLanguage = locale.locale.languageCode == 'en' ? 1 : 0;
  }

  final form = FormGroup({
    'defaultLang': FormControl(value: 'en'),
    'name':
        FormControl(validators: [Validators.required, Validators.minLength(3)]),
    'email': FormControl(validators: [
      Validators.required,
      Validators.pattern(Constants.emailOrPhoneRegEx)
    ]),
    'password':
        FormControl(validators: [Validators.required, Validators.minLength(8)]),
    'confirmPassword':
        FormControl(validators: [Validators.required, Validators.minLength(8)]),
    'mobile': FormControl(validators: [
      Validators.required,
      // Validators.pattern(Constants.emailOrPhoneRegEx)
    ]),
    "fcmToken": FormControl(value: Preference.getString(PrefKeys.fcmToken)),
    "image": FormControl(value: ''),
  }, validators: [
    Validators.mustMatch('password', 'confirmPassword')
  ]);

  File choosedImage;

  String path;

  bool uploading = false;

  signUp() async {
    final locale = AppLocalizations.of(context);
    bool res = false;

    setBusy();

    form.control('defaultLang').updateValue(locale.locale.languageCode);
    form.control('image').updateValue(path ?? "");

    res = await auth.signUp(context, body: form.value);
    res ? UI.pushReplaceAll(context, Routes.creatOrJoinTeam) : setError();
  }

  uploadPhoto() async {
    uploading = true;
    setState();

    final locale = AppLocalizations.of(context);

    try {
      final imageFile =
          await ImagePicker().getImage(source: ImageSource.gallery);

      // FilePickerCross imageFile = await FilePickerCross.importFromStorage();

      if (imageFile != null) {
        choosedImage = File(imageFile.path);

        // upload image
        path = await api.uploadImage(context, imageFile);
        if (path != null) {
          setIdle();
        } else {
          UI.toast(locale.get("Error in uploading image") ??
              "Error in uploading image");
          choosedImage = null;
          setError();
        }

        setIdle();
      } else {
        UI.toast(
            locale.get("You must choose image") ?? "You must choose image");
        setIdle();
      }
    } catch (e) {
      print(e.toString());
      setIdle();
      return;
    }
    if (choosedImage == null) {
      UI.toast(locale.get(locale.get('canceled') ?? "canceled"));
    }

    uploading = false;
    setIdle();
  }
}

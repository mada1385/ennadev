import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/core/services/localization/localization.dart';
import 'package:enna/ui/shared/widgets/app_bar.dart';
import 'package:enna/ui/shared/widgets/drawer.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ui_utils/ui_utils.dart';
import '../styles/colors.dart';
import 'package:enna/ui/shared/widgets/main_reactive_field.dart';
import 'package:enna/ui/shared/widgets/main_button.dart';
import 'package:enna/ui/shared/widgets/error_dialog.dart';

class ChangePasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FocusWidget(
      child: BaseWidget<ChangePasswordPageModel>(
          //initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.initializeProfileData()),
          model: ChangePasswordPageModel(
            context: context,
            locale: locale,
          ),
          builder: (context, model, child) {
            return Scaffold(
              key: model.key,
              appBar: AppBarWidget(
                openDrawer: () => model.key.currentState.openDrawer(),
              ),
              drawer: AppDrawer(ctx: context),
              body: ReactiveForm(
                formGroup: model.form,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10),
                      MainReactiveField(
                        controllerName: model.formOldPassword,
                        label:
                            model.locale.get('Old password') ?? 'Old password',
                        obsecureText: model.isObsecure,
                        suffixIcon: IconButton(
                          icon: model.isObsecure
                              ? Icon(
                                  Icons.visibility_off_outlined,
                                  color: AppColors.primaryColor,
                                )
                              : Icon(
                                  Icons.visibility_outlined,
                                  color: AppColors.primaryColor,
                                ),
                          onPressed: model.toogleObsecure,
                        ),
                      ),
                      MainReactiveField(
                        controllerName: model.formNewPassword,
                        label:
                            model.locale.get('New Password') ?? 'New Password',
                        obsecureText: model.isObsecure,
                        suffixIcon: IconButton(
                          icon: model.isObsecure
                              ? Icon(
                                  Icons.visibility_off_outlined,
                                  color: AppColors.primaryColor,
                                )
                              : Icon(
                                  Icons.visibility_outlined,
                                  color: AppColors.primaryColor,
                                ),
                          onPressed: model.toogleObsecure,
                        ),
                      ),
                      MainReactiveField(
                        controllerName: model.formConfirmPassword,
                        label: model.locale.get('Confirm Password') ??
                            'Confirm Password',
                        obsecureText: model.isObsecure,
                        suffixIcon: IconButton(
                          icon: model.isObsecure
                              ? Icon(
                                  Icons.visibility_off_outlined,
                                  color: AppColors.primaryColor,
                                )
                              : Icon(
                                  Icons.visibility_outlined,
                                  color: AppColors.primaryColor,
                                ),
                          onPressed: model.toogleObsecure,
                        ),
                      ),
                      SizedBox(
                          height:
                              MediaQuery.of(model.context).size.height * 0.2),
                      model.busy
                          ? Center(child: CircularProgressIndicator())
                          : MainButton(
                              height: 50,
                              text: model.locale.get('Save') ?? 'Save',
                              onTap: () {
                                model.changePassword();
                              },
                            ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget textFormField(controller, keyboardType,
      {bool secure = false, bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 10),
      child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: secure,
          enabled: enabled,
          decoration: new InputDecoration(
            hintStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            //labelText: "Enter name of organisation or company",
            labelStyle: TextStyle(color: Colors.grey),
            focusedBorder: new OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.blue[700]),
            ),
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(5.0),
              borderSide: new BorderSide(color: Colors.black),
            ),
          )),
    );
  }
}

class ChangePasswordPageModel extends BaseNotifier {
  String formEmail = 'email';
  String formOldPassword = 'oldPassword';
  String formNewPassword = 'password';
  String formConfirmPassword = 'confirmPassword ';
  final BuildContext context;
  final AppLocalizations locale;
  AuthenticationService auth;
  HttpApi api;
  bool isObsecure = true;
  FormGroup form;
  final key = GlobalKey<ScaffoldState>();

  ChangePasswordPageModel({@required this.context, this.locale}) {
    auth = Provider.of<AuthenticationService>(context);
    api = Provider.of<Api>(context);
    form = FormGroup({
      formEmail: FormControl(value: auth?.user?.user?.email ?? ""),
      formOldPassword: FormControl(validators: [Validators.minLength(8)]),
      formNewPassword: FormControl(validators: [Validators.minLength(8)]),
      formConfirmPassword: FormControl(),
    }, validators: [
      Validators.mustMatch(formNewPassword, formConfirmPassword)
    ]);
  }

  void toogleObsecure() {
    isObsecure = !isObsecure;
    setState();
  }

  void changePassword() async {
    if (form.valid) {
      setBusy();
      final res = await api.changeUserPassword(context, body: form.value);
      // res.fold((e) => errorDialog(context, error: e.toString()), (data) {
      if (res != null) {
        UI.toast(
        locale.get("Password changed successfully.") ??
              "Password changed successfully.",
        );
        setIdle();
        Navigator.of(context).pop();
        Navigator.of(context).pop();

      }
      // });
    } else {
      form.markAllAsTouched();
    }
  }
}

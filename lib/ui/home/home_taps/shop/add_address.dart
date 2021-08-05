import 'package:enna/core/services/localization/localization.dart';
import 'package:enna/ui/shared/styles/colors.dart';
import 'package:enna/ui/shared/widgets/app_bar.dart';
import 'package:enna/ui/shared/widgets/drawer.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ui_utils/ui_utils.dart';

class AddAdderssPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return FocusWidget(
      child: BaseWidget<AddAdderssPageModel>(
          //initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.initializeProfileData()),
          model: AddAdderssPageModel(
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
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Column(
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
                        height: 30,
                      ),
                      Text(
                        "${locale.get("Add Address") ?? "Add Address"}",
                        style: TextStyle(
                            color: AppColors.blackText,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      buildForm(context, model)
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  buildForm(BuildContext context, AddAdderssPageModel model) {
    final locale = AppLocalizations.of(context);

    return ReactiveForm(
      formGroup: model.addressForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${locale.get("Full Name") ?? "Full Name"}",
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.w700)),
          buildReactiveTextField(
              context: context,
              controlName: "fullName",
              keyboardType: TextInputType.text,
              labelText:
                  "${locale.get("Enter full name") ?? "Enter full name"}"),
          Text("${locale.get("Landmark") ?? "Landmark"}",
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.w700)),
          buildReactiveTextField(
              context: context,
              controlName: "landMark",
              keyboardType: TextInputType.text,
              labelText:
                  "${locale.get("Enter landmark of address") ?? "Enter landmark of address"}"),
          Text("${locale.get("Building Number") ?? "Building Number"}",
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.w700)),
          buildReactiveTextField(
              context: context,
              controlName: "buildingNumber",
              keyboardType: TextInputType.streetAddress,
              labelText:
                  "${locale.get("Enter building number") ?? "Enter building number"}"),
          Text("${locale.get("Zone Number") ?? "Zone Number"}",
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.w700)),
          buildReactiveTextField(
              context: context,
              controlName: "zoneNumber",
              keyboardType: TextInputType.streetAddress,
              labelText:
                  "${locale.get("Enter zone number") ?? "Enter zone number"}"),
          Text("${locale.get("Street Number") ?? "Street Number"}",
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.w700)),
          buildReactiveTextField(
              context: context,
              controlName: "streetNumber",
              keyboardType: TextInputType.streetAddress,
              labelText:
                  "${locale.get("Enter street number") ?? "Enter street number"}"),
          Text("${locale.get("Phone Number") ?? "Phone Number"}",
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.w700)),
          buildReactiveTextField(
              context: context,
              controlName: "phoneNumber",
              keyboardType: TextInputType.phone,
              labelText:
                  "+974  |  ${locale.get("Enter phone number") ?? "Enter phone number"}"),
          SizedBox(
            height: 30,
          ),
          ReactiveFormConsumer(
            builder: (context, form, child) {
              return !model.busy
                  ? Container(
                      width: ScreenUtil.screenWidthDp * .8,
                      height: 50,
                      child: Container(
                        height: 50,
                        width: ScreenUtil.screenWidthDp,
                        child: RaisedButton(
                            onPressed: model.addressForm.valid
                                ? () {
                                    model.addAddress();
                                  }
                                : null,
                            textColor: Colors.white,
                            color: Colors.blue[900],
                            child: Text(
                              'Add address',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                            padding: const EdgeInsets.all(0.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(5.0),
                            )),
                      ),
                    )
                  : Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }

  Widget textFormField(controller, hint, keyboardType) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 10),
      child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: new InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13),
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

  buildReactiveTextField(
      {controlName: String,
      keyboardType: TextInputType,
      labelText: String,
      context}) {
    final locale = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: ReactiveTextField(
        autocorrect: true,
        autofocus: true,
        formControlName: controlName,
        validationMessages: (control) => {
          'required': controlName + ' ' + locale.get('Is Required') ??
              'Is Required' + ' ',
        },
        keyboardType: keyboardType,
        decoration: new InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.black54, fontSize: 12),
          focusedBorder: new OutlineInputBorder(
            borderSide: new BorderSide(color: AppColors.ternaryBackground),
          ),
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(5.0),
            borderSide: new BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }
}

class AddAdderssPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  final formKey = GlobalKey<FormState>();
  final key = GlobalKey<ScaffoldState>();

  FormGroup addressForm = fb.group({
    "fullName": FormControl(validators: [Validators.required]),
    "landMark": FormControl(validators: [Validators.required]),
    "buildingNumber": FormControl(validators: [Validators.required]),
    "zoneNumber": FormControl(validators: [Validators.required]),
    "streetNumber": FormControl(validators: [Validators.required]),
    "phoneNumber": FormControl(validators: [Validators.required]),
    "user": FormControl(),
  });
  //

  AddAdderssPageModel({NotifierState state, this.api, this.auth, this.context})
      : super(state: state);

  void addAddress() async {
    bool res = false;
    addressForm.control('user').updateValue(auth.user.user);

    res = await api.addAddress(context, body: addressForm.value);
    res ? Navigator.pop(context, true) : UI.toast("Error in saving address");
  }
}

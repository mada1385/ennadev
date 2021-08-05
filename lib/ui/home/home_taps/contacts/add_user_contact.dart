
import 'package:enna/core/models/contacts.dart';
import 'package:enna/core/models/user.dart';
import 'package:enna/core/services/localization/localization.dart';
import 'package:enna/core/services/preference/preference.dart';
import 'package:enna/core/utils/validators.dart';
import 'package:enna/ui/shared/widgets/buttons/raised_button.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/ui/shared/widgets/app_bar.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:enna/ui/shared/styles/colors.dart';

class AddUserContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return FocusWidget(
      child: BaseWidget<AddUserContactPageModel>(
          initState: (m) => WidgetsBinding.instance
              .addPostFrameCallback((_) => m.getContactsCategory()),
          model: AddUserContactPageModel(
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
                                          color: AppColors.secondaryText,
                                        ),
                                      ),
                                      SizedBox(
                                        width: ScreenUtil.screenWidthDp * 0.1,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Text(
                                      locale.get('Add Contact') ??
                                          'Add Contact',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: AppColors.blackText,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  buildForm(context, model),
                                  model.busy
                                      ? Center(
                                          child: CircularProgressIndicator())
                                      : Center(
                                          child: Button(
                                            color: AppColors.ternaryBackground,
                                            text: locale.get('Add') ?? 'Add',
                                            onClicked: () {
                                              model.addContact();
                                            },
                                          ),
                                        ),
                                ],
                              ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  buildForm(BuildContext context, AddUserContactPageModel model) {
    final locale = AppLocalizations.of(context);
    return Form(
      key: model.formKey,
      //autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${locale.get("Name of Organisation/Company") ?? "Name of Organisation/Company"}",
            style: TextStyle(color: AppColors.secondaryText),
          ),
          buildTextFormField(
              validator: (value) => model.namelValidator(value, context),
              controller: model.orgnizationNameController,
              hint:
                  "${locale.get("Enter name of organisation or company") ?? "Enter name of organisation or company"}",
              keyboard: TextInputType.text),
          Text("${locale.get("Category") ?? "Category"}"),
          model.fetchingCategories
              ? Center(child: CircularProgressIndicator())
              : model.hasError
                  ? Center(child: Text("Error in fetching categories"))
                  : categoryDropDown(context, model),
          Text("${locale.get("Name of contact") ?? "Name of contact"}"),
          buildTextFormField(
              validator: (value) => model.namelValidator(value, context),
              controller: model.contactNameController,
              hint:
                  "${locale.get("Enter name of contacting person") ?? "Enter name of contacting person"}",
              keyboard: TextInputType.text),
          Text("${locale.get("Landline number") ?? "Landline number"}"),
          buildTextFormField(
            validator: (value) => model.phoneValidator(value, context),
            controller: model.landLineController,
            hint:
                "${locale.get("Enter landline number") ?? "Enter landline number"}",
            keyboard: TextInputType.number,
          ),
          Text("${locale.get("Mobile number") ?? "Mobile number"}"),
          buildTextFormField(
            validator: (value) => model.phoneValidator(value, context),
            controller: model.phoneController,
            hint:
                "${locale.get("Enter mobile number") ?? "Enter mobile number"}",
            keyboard: TextInputType.number,
          ),
          Text("${locale.get("Email") ?? "Email"}"),
          buildTextFormField(
            validator: (value) => model.emailValidator(value, context),
            controller: model.emailController,
            hint:
                "${locale.get("Enter email address") ?? "Enter email address"}",
            keyboard: TextInputType.emailAddress,
          ),
          Text("${locale.get("Website") ?? "Website"}"),
          buildTextFormField(
            // validator: (value) => model.passwordValidator(value, context),
            controller: model.webSiteController,
            hint:
                "${locale.get("Enter website address") ?? "Enter website address"}",
            keyboard: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }

  categoryDropDown(BuildContext context, AddUserContactPageModel model) {
    final locale = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Container(
        height: 70,
        width: ScreenUtil.screenWidthDp,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton(
              isExpanded: true,
              underline: SizedBox(),
              items: model.contactCategories
                  .map(
                    (category) => DropdownMenuItem<ContactsCateoryModel>(
                      child: Text(category.name.localized(context)),
                      value: category,
                    ),
                  )
                  .toList(),
              hint: model.selectedContactCategory != null
                  ? Container(
                      width: ScreenUtil.screenWidthDp * 0.75,
                      child: Text(model.selectedContactCategory.name
                          .localized(context)))
                  : Container(
                      width: ScreenUtil.screenWidthDp * 0.75,
                      child: Text(
                        locale.get('Choose Category') ?? 'Choose Category',
                        style: TextStyle(color: AppColors.hintText),
                      )),
              onChanged: (ContactsCateoryModel value) {
                model.selectedContactCategory = value;
                model.setState();
              }),
        ),
      ),
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
              color: AppColors.ternaryBackground,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: AppColors.border,
              width: .5,
            ),
          ),
          // labelText: hint,
          // fillColor: Colors.grey,
          hintText: hint,
          hintStyle: TextStyle(fontSize: 15, color: AppColors.hintText),
          //       labelStyle: TextStyle(color: Colors.black),
          // fillColor: Colors.white,
        ),
      ),
    );
  }
}

class AddUserContactPageModel extends BaseNotifier with Validator {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  final formKey = GlobalKey<FormState>();
  final key = GlobalKey<ScaffoldState>();

  TextEditingController orgnizationNameController = TextEditingController();
  TextEditingController contactNameController = TextEditingController();
  TextEditingController landLineController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController webSiteController = TextEditingController();

  List<String> people;

  Teams team;

  bool fetchingCategories = false;
  List<ContactsCateoryModel> contactCategories;
  ContactsCateoryModel selectedContactCategory;

  AddUserContactPageModel(
      {NotifierState state, this.api, this.auth, this.context})
      : super(state: state) {
    getTeam();
    people = [];
  }

  getTeam() async {
    setBusy();
    team = await api.getTeamByTeamID(context,
        teamID: Preference.getString(PrefKeys.TEAM_ID));

    team != null ? setIdle() : setError();
  }

  getContactsCategory() async {
    fetchingCategories = true;
    setBusy();
    contactCategories = await api.getContactCategories(context);
    if (contactCategories != null) {
      fetchingCategories = false;
      setIdle();
    } else {
      fetchingCategories = false;
      UI.toast("Error in fetching Categories");
      setError();
    }
  }

  void addContact() async {
    bool res = false;

    if (formKey.currentState.validate() && selectedContactCategory != null) {
      setBusy();
      Map<String, dynamic> body = {
        "companyName": orgnizationNameController.text,
        "category": {"id": selectedContactCategory.id},
        "contactName": contactNameController.text,
        "landLine": landLineController.text,
        "mobile": phoneController.text,
        "email": emailController.text,
        "website": webSiteController.text,
        "team": {"id": team.id}
      };
      res = await api.addContact(context, body: body);
      if (res) {
        Navigator.pop(context, true);
      } else {
        setError();
        UI.toast("You can't add Contact now, Please try again");
      }
    }
  }
}

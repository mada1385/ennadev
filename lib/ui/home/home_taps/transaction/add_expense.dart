import 'dart:io';

import 'package:enna/core/models/category.dart';
import 'package:enna/core/models/user.dart';
import 'package:enna/core/services/localization/localization.dart';
import 'package:enna/core/services/preference/preference.dart';
import 'package:enna/ui/shared/routes/route.dart';
import 'package:enna/ui/shared/styles/colors.dart';
import 'package:enna/ui/shared/widgets/app_bar.dart';
import 'package:enna/ui/shared/widgets/drawer.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ui_utils/ui_utils.dart';

class AddExpensePage extends StatelessWidget {
  //TODo: Form array

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return FocusWidget(
      child: BaseWidget<AddExpensePageModel>(
          initState: (m) => WidgetsBinding.instance
              .addPostFrameCallback((_) => m.getExpenseGroup()),
          model: AddExpensePageModel(
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
                                  Text(
                                    "${locale.get("Add Expense") ?? "Add Expense"}",
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
                                            "${locale.get("Amount") ?? "Amount"}",
                                            style: TextStyle(
                                                color: Colors.grey.shade600),
                                          ),
                                          buildAmountReactive(locale),
                                          Text(
                                            "${locale.get("Spent for") ?? "Spent for"}",
                                            style: TextStyle(
                                                color: Colors.grey.shade600),
                                          ),
                                          buildSpentForReactive(context, model),
                                          Text(
                                            "${locale.get("Paid By") ?? "Paid By"}",
                                            style: TextStyle(
                                                color: Colors.grey.shade600),
                                          ),
                                          buildRecievedFromReactive(
                                              context, model),
                                          Text(
                                            "${locale.get("Attach Reciept") ?? "Attach Reciept"}",
                                            style: TextStyle(
                                                color: Colors.grey.shade600),
                                          ),
                                          buildRecieptReactive(
                                              context, locale, model),
                                          Text(
                                            "${locale.get("Notes") ?? "Notes"}",
                                            style: TextStyle(
                                                color: Colors.grey.shade600),
                                          ),
                                          buildNoteReactive(locale),
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
                                                                            .addExpense();
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

  Padding buildRecievedFromReactive(
      BuildContext context, AddExpensePageModel model) {
    final locale = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: Colors.grey[500]),
        ),
        child: ReactiveDropdownField(
          formControlName: 'recevedFrom',
          decoration: InputDecoration(
              hintText: locale.get('Paid By') ?? 'Paid By',
              contentPadding: EdgeInsets.symmetric(horizontal: 10)),
          items: model.team.members
              .map(
                (member) => DropdownMenuItem<Members>(
                  child: Text(member.name),
                  value: member,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget buildSpentForReactive(
      BuildContext context, AddExpensePageModel model) {
    final locale = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: Colors.grey[500]),
        ),
        child: model.fetchingExpenseGroup
            ? Center(child: CircularProgressIndicator())
            : ReactiveDropdownField(
                formControlName: 'spentFor',
                decoration: InputDecoration(
                    hintText: locale.get('Spent for') ?? 'Spent for',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                items: model.expenseGroup
                    .map(
                      (category) => DropdownMenuItem<Category>(
                        child: Text(category.name.localized(context)),
                        value: category,
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }

  Padding buildAmountReactive(AppLocalizations locale) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
      child: Container(
        height: 50,
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
                borderSide: new BorderSide(color: AppColors.secondaryText),
              ),
            )),
      ),
    );
  }

  Padding buildNoteReactive(AppLocalizations locale) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
      child: ReactiveTextField(
          formControlName: 'note',
          minLines: 3,
          maxLines: 3,
          autocorrect: true,
          decoration: new InputDecoration(
            hintText: "${locale.get("Notes") ?? "Notes"}",
            hintStyle: TextStyle(fontSize: 13),
            labelStyle: TextStyle(color: Colors.grey),
            focusedBorder: new OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.blue[700]),
            ),
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(5.0),
              borderSide: new BorderSide(color: AppColors.secondaryText),
            ),
          )),
    );
  }

  Padding buildRecieptReactive(BuildContext context, AppLocalizations locale,
      AddExpensePageModel model) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
      child: model.uploading
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: 50,
              child: ReactiveTextField(
                  readOnly: true,
                  onTap: () => model.openGallary(context),
                  formControlName: 'reciept',
                  decoration: new InputDecoration(
                    hintText: model.link != null
                        ? "Image uploaded successfully"
                        : "${locale.get("Select receipt image/file") ?? "Select receipt image/file"}",
                    hintStyle: model.link != null
                        ? TextStyle(fontSize: 13, fontWeight: FontWeight.bold)
                        : TextStyle(fontSize: 13),
                    labelStyle: TextStyle(color: Colors.grey),
                    focusedBorder: new OutlineInputBorder(
                      borderSide:
                          new BorderSide(color: AppColors.ternaryBackground),
                    ),
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(5.0),
                      borderSide:
                          new BorderSide(color: AppColors.secondaryText),
                    ),
                  )),
            ),
    );
  }
}

class AddExpensePageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  List<Category> expenseGroup;
  Category selectedCategory;
  Members selectedMember;
  Teams team;

  String spentDate;

  File imageFile;
  String link;

  bool uploading = false;
  bool fetchingExpenseGroup = true;

  final key = GlobalKey<ScaffoldState>();

  TextEditingController amountController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  Map<String, dynamic> body;

  AddExpensePageModel({NotifierState state, this.api, this.auth, this.context})
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

  final FormGroup form = fb.group(
    {
      'amount':
          FormControl(validators: [Validators.required, Validators.number]),
      "spentFor": FormControl(validators: [Validators.required]),
      "recevedFrom": FormControl(validators: [Validators.required]),
      "reciept": FormControl(validators: [Validators.required]),
      "note": FormControl(validators: [Validators.maxLength(255)]),
      "team": FormControl(),
    },
    [Validators.required],
  );

  getExpenseGroup() async {
    fetchingExpenseGroup = true;
    expenseGroup = await api.getExpenseGroup(context);
    if (expenseGroup != null) {
      fetchingExpenseGroup = false;
    } else {
      UI.toast("Error in fetching expense group");
      fetchingExpenseGroup = false;
    }
    setState();
  }

  openGallary(BuildContext context) async {
    final imageFile = await ImagePicker().getImage(source: ImageSource.gallery);

    // FilePickerCross imageFile = await FilePickerCross.importFromStorage();

    if (imageFile != null) {
      uploading = true;
      setState();

      link = await api.uploadImage(context, imageFile);

      uploading = false;
      setState();
    } else {
      UI.toast("You must choose image");
    }
  }

  addExpense() async {
    bool res = false;

    setBusy();

    if (link != null) {
      form.control('team').updateValue(team.toJson());
      form.control('reciept').updateValue(link);

      res = await api.addExpense(context, body: form.value);
      if (res) {
        Navigator.pop(context, true);
      } else {
        setIdle();
        UI.toast("Smothing is wrong, please try again");
      }
    } else {
      setIdle();
      UI.toast("Please upload image");
    }
  }
}

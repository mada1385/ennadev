import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/core/services/localization/localization.dart';
import 'package:enna/core/services/preference/preference.dart';
import 'package:enna/ui/shared/routes/route.dart';
import 'package:enna/ui/shared/styles/colors.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ui_utils/ui_utils.dart';

class CampingDatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return BaseWidget<CampingDatePageModel>(
      model: CampingDatePageModel(
        api: Provider.of<Api>(context),
        auth: Provider.of(context),
        context: context,
      ),
      builder: (context, model, child) => Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100,
                ),
                Container(
                  width: ScreenUtil.screenWidthDp / 2.5,
                  height: ScreenUtil.screenHeightDp / 5,
                  child: SvgPicture.asset(
                    'assets/images/date.svg',
                  ),
                ),
                ReactiveForm(
                  formGroup: model.form,
                  child: Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${locale.get("Set start Date and end Date for camping") ?? "Set start Date and end Date for camping"}: ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            locale.get('Start date') ?? 'Start date',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        //Choose Start Date
                        Container(
                            height: 50.0,
                            child: ReactiveTextField(
                              formControlName: 'startDate',
                              readOnly: true,
                              validationMessages: (control) => {
                                'required':
                                    "${locale.get("Start Date") ?? "Start Date"}: "
                              },
                              decoration: InputDecoration(
                                suffixIcon: ReactiveDatePicker(
                                  formControlName: 'startDate',
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                  builder: (context, picker, child) {
                                    return IconButton(
                                      onPressed: picker.showPicker,
                                      icon: Icon(Icons.date_range),
                                    );
                                  },
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 20,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            "${locale.get("End Date") ?? "End Date"}: ",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),

                        Container(
                            height: 50.0,
                            child: ReactiveTextField(
                              formControlName: 'endDate',
                              readOnly: true,
                              validationMessages: (control) => {
                                'required':
                                    "${locale.get("End date is required") ?? "End date is required"}: "
                              },
                              decoration: InputDecoration(
                                fillColor: AppColors.primaryElement,
                                suffixIcon: ReactiveDatePicker(
                                  formControlName: 'endDate',
                                  firstDate:
                                      model.form.control('startDate').value ??
                                          DateTime.now(),
                                  lastDate: DateTime(2100),
                                  initialDatePickerMode: DatePickerMode.day,
                                  locale: locale.locale,
                                  builder: (context, picker, child) {
                                    return IconButton(
                                      onPressed: picker.showPicker,
                                      icon: Icon(Icons.date_range),
                                    );
                                  },
                                ),
                              ),
                            )),

                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: 335,
                          height: 50,
                          child: RaisedButton(
                              onPressed: () {
                                model.gotoSeasonLocation();
                                // print(form.value);
                              },
                              textColor: Colors.white,
                              color: Colors.blue[900],
                              child: Text(
                                "${locale.get("Continue") ?? "Continue"}: ",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              padding: const EdgeInsets.all(0.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CampingDatePageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  Map<String, dynamic> body;

  CampingDatePageModel({NotifierState state, this.api, this.auth, this.context})
      : super(state: state);

  FormGroup form = fb.group(
    {
      'startDate': FormControl<DateTime>(validators: [Validators.required]),
      'endDate': FormControl<DateTime>(validators: [Validators.required])
    },
  );

  gotoSeasonLocation() async {
    body = {
      "startDate":
          //  form.control('startDate').value,
          DateFormat('yyyy-MM-dd').format(form.control('startDate').value),
      "endDate":
          // form.control('endDate').value,
          DateFormat('yyyy-MM-dd').format(form.control('endDate').value),
      "lat": "",
      "lng": "",
      "team": {
        "id": Preference.getString(PrefKeys.TEAM_ID),
      }
    };
    UI.push(context, Routes.seasonLocation(body: body));
  }
}

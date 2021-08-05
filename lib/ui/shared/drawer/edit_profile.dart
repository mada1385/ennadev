import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/core/services/localization/localization.dart';
import 'package:enna/ui/shared/widgets/app_bar.dart';
import 'package:enna/ui/shared/widgets/drawer.dart';
import 'package:enna/ui/shared/widgets/reactive_widgets.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:enna/ui/shared/drawer/change_password_page.dart';

class EditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FocusWidget(
      child: BaseWidget<EditProfilePageModel>(
          //initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.initializeProfileData()),
          model: EditProfilePageModel(
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
                  padding: const EdgeInsets.all(20.0),
                  child: ReactiveForm(
                    formGroup: model.form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 4,
                            ),
                            Text(
                              locale.get('Edit Profile') ?? 'Edit Profile',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Center(
                          child: InkWell(
                            onTap: () => model.changePhoto(),
                            child: model.uploading
                                ? Center(child: CircularProgressIndicator())
                                : CircleAvatar(
                                    backgroundColor:
                                        model.auth.user.user.image != null
                                            ? Colors.transparent
                                            : Colors.blue[900],
                                    maxRadius: 35,
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: model.auth.user.user.image,
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            ClipOval(
                                          child: Container(
                                              color: Colors.blue[900],
                                              alignment: Alignment.center,
                                              height: 45.0,
                                              width: 45.0,
                                              child: Text(
                                                model.auth.user.user.name
                                                    .substring(0, 1)
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              )),
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ReactiveField(
                          type: ReactiveFields.TEXT,
                          controllerName: 'name',
                          context: context,
                          label: locale.get("Name") ?? "Name",
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ReactiveField(
                          type: ReactiveFields.TEXT,
                          controllerName: 'email',
                          context: context,
                          label: locale.get("Email") ?? "Email",
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ReactiveField(
                          type: ReactiveFields.TEXT,
                          controllerName: 'mobile',
                          context: context,
                          label: locale.get("Phone number") ?? "Phone number",
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          locale.get('Password') ?? 'Password',
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                        InkWell(
                          onTap: () {
                            UI.push(context, ChangePasswordPage());
                          },
                          child: textFormField(
                            TextEditingController(text: "*********"),
                            TextInputType.emailAddress,
                            secure: true,
                            enabled: false,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        model.busy
                            ? Center(child: CircularProgressIndicator())
                            : Container(
                                height: 50,
                                width: ScreenUtil.screenWidthDp,
                                child: RaisedButton(
                                    onPressed: () => model.updateProfile(),
                                    textColor: Colors.white,
                                    color: Colors.blue[900],
                                    child: Text(
                                      locale.get('Save changes') ??
                                          'Save changes',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    padding: const EdgeInsets.all(0.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                    )),
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

  Widget textFormField(
    controller,
    keyboardType, {
    bool secure = false,
    bool enabled = true,
  }) {
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

class EditProfilePageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  final key = GlobalKey<ScaffoldState>();

  Map<String, dynamic> body;
  String image;

  bool uploading = false;
  String link;

  FormGroup form;

  EditProfilePageModel({NotifierState state, this.api, this.auth, this.context})
      : super(state: state) {
    body = {};
    final locale = AppLocalizations.of(context);
    form = FormGroup({
      "name": FormControl(value: auth.user.user.name),
      "email": FormControl(value: auth.user.user.email),
      "mobile": FormControl(value: auth.user.user.mobile),
      "image": FormControl(value: auth.user.user.image),
      "defaultLang": FormControl(value: locale.locale.languageCode),
    });
  }

  updateProfile() async {
    final locale = AppLocalizations.of(context);
    bool res = false;
    setBusy();

    res = await auth.updateUserProfile(context, body: form.value);
    if (res) {
      setIdle();
      Navigator.pop(context);
    } else {
      // getOriginalValues();
      setError();
      UI.toast("Error in updating values");
    }
  }

  changePhoto() async {
    final imageFile = await ImagePicker().getImage(source: ImageSource.gallery);

    // FilePickerCross imageFile = await FilePickerCross.importFromStorage();

    if (imageFile != null) {
      uploading = true;
      setState();

      link = await api.uploadImage(context, imageFile);
      if (link != null) {
        auth.user.user.image = link;
        setState();
      }
      uploading = false;
      setState();
    } else {
      UI.toast("You must choose image");
    }
  }
}

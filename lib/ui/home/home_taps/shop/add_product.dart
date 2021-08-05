import 'package:enna/core/models/category.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/localization/localization.dart';
import 'package:enna/ui/shared/styles/colors.dart';
import 'package:enna/ui/shared/widgets/drawer.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/ui/shared/widgets/app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ui_utils/ui_utils.dart';
import 'dart:io';

class AddProductPage extends StatelessWidget {
  List<Category> categories;
  AddProductPage({this.categories});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    // List<Widget> photos = [];

    return FocusWidget(
      child: BaseWidget<AddProductPageModel>(
        model: AddProductPageModel(
          api: Provider.of<Api>(context),
          auth: Provider.of(context),
          categories: categories,
          context: context,
        ),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          height: 25,
                        ),
                        Text(
                          "${locale.get("Add product") ?? "Add product"}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ReactiveForm(
                            formGroup: model.form,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "${locale.get("Product Title") ?? "Product Title"}"),
                                ReactiveForm(
                                  formGroup: model.form.control('name'),
                                  child: Column(children: [
                                    locale.locale.languageCode == 'ar'
                                        ? buildReactiveTextField(locale,
                                            controllerName: 'ar',
                                            hintText:
                                                "Enter product Arabic title",
                                            validationMessages: {
                                                'required': 'Required',
                                                'minLength':
                                                    'Title must exceed 3 characters'
                                              })
                                        : buildReactiveTextField(locale,
                                            controllerName: 'en',
                                            hintText:
                                                "Enter product English title",
                                            validationMessages: {
                                                'required': 'Required',
                                                'minLength':
                                                    'Title must exceed 3 characters'
                                              }),
                                  ]),
                                ),
                                Text(
                                    "${locale.get("Product description") ?? "Product description"}"),
                                ReactiveForm(
                                  formGroup: model.form.control('description'),
                                  child: Column(children: [
                                    locale.locale.languageCode == 'ar'
                                        ? buildReactiveTextField(locale,
                                            controllerName: 'ar',
                                            hintText: "Enter product description arabic",
                                            minLines: 3,
                                            validationMessages: {
                                                'required': 'Required',
                                                'minLength':
                                                    'description must exceed 3 characters'
                                              })
                                        : buildReactiveTextField(locale,
                                            controllerName: 'en',
                                            hintText:
                                                "Enter product description english",
                                            minLines: 3,
                                            validationMessages: {
                                                'required': 'Required',
                                                'minLength':
                                                    'description must exceed 3 characters'
                                              }),
                                  ]),
                                ),
                                Text("${locale.get("Category") ?? "Category"}"),
                                ReactiveDropdownField<Category>(
                                  formControlName: 'category',
                                  hint: Text(
                                    locale.get('Select category') ??
                                        'Select category',
                                  ),
                                  decoration: new InputDecoration(
                                    labelStyle: TextStyle(color: Colors.grey),
                                    focusedBorder: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                          color: AppColors.ternaryBackground),
                                    ),
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                    ),
                                  ),
                                  items: model.categories
                                      .map((e) => DropdownMenuItem<Category>(
                                            value: e,
                                            child:
                                                Text(e.name.localized(context)),
                                          ))
                                      .toList(),
                                ),
                                Text("${locale.get("Price") ?? "Price"}"),
                                buildReactiveTextField(locale,
                                    controllerName: 'price',
                                    hintText: "Product prcie",
                                    keyboardType: TextInputType.number,
                                    validationMessages: {
                                      'required': 'Required',
                                    }),
                                Text(
                                    "${locale.get("Add Product Images") ?? "Add Product Images"}"),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      addProductImage(context, model),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        if (model.addedlinks.value != null &&
                            model.addedlinks.value.isNotEmpty) ...[
                          buildWrapImages(model)
                        ],
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: model.busy
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Container(
                                  height: 50,
                                  width: ScreenUtil.screenWidthDp,
                                  child: RaisedButton(
                                      onPressed: model.uploading
                                          ? null
                                          : () {
                                              model.addProduct();
                                            },
                                      textColor: Colors.white,
                                      color: AppColors.ternaryBackground,
                                      child: Text(
                                        "${locale.get("Add product") ?? "Add product"}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      padding: const EdgeInsets.all(0.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(5.0),
                                      )),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }

  ReactiveTextField buildReactiveTextField(
    AppLocalizations locale, {
    @required String controllerName,
    @required String hintText,
    Map<String, String> validationMessages,
    int minLines,
    TextInputType keyboardType = TextInputType.emailAddress,
  }) {
    return ReactiveTextField(
      formControlName: controllerName,
      validationMessages: (control) => validationMessages,
      keyboardType: keyboardType,
      minLines: minLines ?? 1,
      maxLines: minLines ?? 1,
      decoration: new InputDecoration(
        hintText: "${locale.get(hintText) ?? hintText}",
        hintStyle: TextStyle(fontSize: 13),
        //labelText: "Enter name of organisation or company",
        labelStyle: TextStyle(color: Colors.grey),
        focusedBorder: new OutlineInputBorder(
          borderSide: new BorderSide(color: AppColors.ternaryBackground),
        ),
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(5.0),
          borderSide: new BorderSide(color: Colors.black),
        ),
      ),
    );
  }

  addProductImage(BuildContext context, AddProductPageModel model) {
    return InkWell(
      onTap: model.uploading
          ? null
          : () {
              model.openGallary(context);
            },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            shape: BoxShape.rectangle),
        child: Center(
            child: model.uploading
                ? CircularProgressIndicator()
                : Icon(
                    Icons.add,
                    size: 100,
                    color: Colors.grey[500],
                  )),
      ),
    );
  }

  Wrap buildWrapImages(AddProductPageModel model) {
    return Wrap(
        children: List.generate(
      model.addedlinks.value.length ?? 0,
      (index) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              color: Colors.grey[300],
              border: Border.all(color: AppColors.ternaryBackground),
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
              shape: BoxShape.rectangle),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Center(
                child: CachedNetworkImage(
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              imageUrl: model.addedlinks.value[index],
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => Icon(Icons.broken_image),
            )),
          ),
        ),
      ),
    ));
  }

  List<File> imageFile;

  openCamera(BuildContext context, AddProductPageModel model) async {
    var picture = await ImagePicker().getImage(source: ImageSource.camera);

    // imageFile.add(picture);

    model.setState();

    Navigator.of(context).pop();
  }

  Future<void> showChoiceDialoge(
      BuildContext context, AddProductPageModel model) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Make a Choice! "),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Gallary"),
                    onTap: () {
                      model.openGallary(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(5.0)),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      // _openCamera(context, model);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }
}

class AddProductPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  final List<Category> categories;

  AppLocalizations locale;

  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  FormGroup form;

  FormArray<String> get addedlinks => form.control('images') as FormArray;

  AddProductPageModel(
      {NotifierState state, this.api, this.auth, this.context, this.categories})
      : super(state: state) {
    locale = AppLocalizations.of(context);
    form = FormGroup({
      'name': FormGroup({
        'ar': FormControl(
            validators: [Validators.required, Validators.minLength(3)]),
        'en': FormControl(
            validators: [Validators.required, Validators.minLength(3)]),
      }),
      'description': FormGroup({
        'ar': FormControl(
            validators: [Validators.required, Validators.minLength(3)]),
        'en': FormControl(
            validators: [Validators.required, Validators.minLength(3)]),
      }),
      'category': FormControl<Category>(validators: [Validators.required]),
      'price': FormControl<double>(validators: [Validators.required]),
      'images': FormArray<String>([]),
      'seller': FormControl(value: auth.user.user)
    });
  }

  bool uploading = false;

  // List<UploadedFileModel> apiLinks;

  List<String> links = [];

  // void chooseImage() async {
  //   // List<FilePickerCross> myMultipleFiles =
  //   //     await FilePickerCross.importMultipleFromStorage();

  //   //List<Asset> images = List<Asset>();

  //   if (myMultipleFiles != null) {
  //     uploading = true;
  //     setState();

  //     apiLinks = await api.uploadImages(context, myMultipleFiles);

  //     uploading = false;
  //     setState();
  //     if (apiLinks != null && apiLinks.isNotEmpty) {
  //       apiLinks.forEach((element) => links.add(element.path));
  //     }
  //     form.control('images').value = links;
  //     setState();
  //   }
  // }

  addProduct() async {
    print(form.value);

    bool res = false;
    setBusy();
    res = await api.addProduct(context, body: form.value);
    if (res) {
      Navigator.pop(context, true);
    } else {
      setError();
      UI.toast("Somthing error in uploadig product");
    }
  }

  openGallary(BuildContext context) async {
    var picture = await ImagePicker().getImage(source: ImageSource.gallery);

    if (picture != null) {
      // upload
      uploadImage(context, picture);
    }
  }

  uploadImage(BuildContext context, PickedFile picture) async {
    var res = await api.uploadImage(context, picture);
    if (res != null) {
      // links.add(res);
      addedlinks.add(FormControl(value: res));
      setState();
    }
  }
}

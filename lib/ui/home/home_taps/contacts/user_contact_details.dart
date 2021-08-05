import 'package:enna/core/models/contacts.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/ui/shared/widgets/app_bar.dart';
import 'package:enna/ui/shared/widgets/drawer.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:enna/ui/shared/styles/colors.dart';

import '../../../../core/services/localization/localization.dart';

class UserContactsDetailsPage extends StatelessWidget {
  final ContactsCateoryModel contacts;
  UserContactsDetailsPage({this.contacts});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FocusWidget(
      child: BaseWidget<UserContactsDetailsPageModel>(
          //initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.initializeProfileData()),
          model: UserContactsDetailsPageModel(
              api: Provider.of<Api>(context),
              auth: Provider.of(context),
              contacts: contacts,
              context: context),
          builder: (context, model, child) {
            return Scaffold(
              key: model.key,
              appBar: AppBarWidget(
                openDrawer: () => model.key.currentState.openDrawer(),
              ),
              drawer: AppDrawer(
                ctx: context,
              ),
              body: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          contacts.name.localized(context),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: AppColors.blackText),
                        ),
                      ),
                      model.contacts.contacts.isNotEmpty
                          ? Column(
                              children: [
                                ...List.generate(
                                    model.contacts.contacts.length,
                                    (index) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          child: Card(
                                            elevation: 2,
                                            color: Colors.grey[100],
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Text(
                                                      model
                                                          .contacts
                                                          .contacts[index]
                                                          .companyName,
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .blackText,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                  ),
                                                  // Row(
                                                  //   mainAxisAlignment:
                                                  //       MainAxisAlignment
                                                  //           .spaceBetween,
                                                  //   children: [
                                                  //     Text(
                                                  //       model.contacts.contacts[index].,
                                                  //       style: TextStyle(
                                                  //           color: Colors.grey),
                                                  //     ),
                                                  //     Row(
                                                  //       children: [
                                                  //         Text('Added by',
                                                  //             style: TextStyle(
                                                  //                 color: Colors
                                                  //                     .grey)),
                                                  //         Padding(
                                                  //           padding:
                                                  //               const EdgeInsets
                                                  //                   .all(8.0),
                                                  //           child: CircleAvatar(
                                                  //             radius: 20,
                                                  //             child: SvgPicture
                                                  //                 .asset(
                                                  //                     "assets/images/contactsIcon.svg"),
                                                  //           ),
                                                  //         ),
                                                  //       ],
                                                  //     )
                                                  //   ],
                                                  // ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.person,
                                                              color: AppColors
                                                                  .hintText,
                                                              size: 18,
                                                            ),
                                                            SizedBox(
                                                              width: 3,
                                                            ),
                                                            Container(
                                                              width: ScreenUtil
                                                                      .screenWidthDp *
                                                                  .2,
                                                              child: Text(
                                                                model
                                                                    .contacts
                                                                    .contacts[
                                                                        index]
                                                                    .contactName,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: AppColors
                                                                        .hintText),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.phone,
                                                              color: AppColors
                                                                  .hintText,
                                                              size: 18,
                                                            ),
                                                            SizedBox(
                                                              width: 3,
                                                            ),
                                                            Container(
                                                              width: ScreenUtil
                                                                      .screenWidthDp *
                                                                  .2,
                                                              child: Text(
                                                                model
                                                                    .contacts
                                                                    .contacts[
                                                                        index]
                                                                    .landLine,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: AppColors
                                                                        .hintText),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .phone_android,
                                                              color: AppColors
                                                                  .hintText,
                                                              size: 18,
                                                            ),
                                                            SizedBox(
                                                              width: 3,
                                                            ),
                                                            Container(
                                                              width: ScreenUtil
                                                                      .screenWidthDp *
                                                                  .2,
                                                              child: Text(
                                                                model
                                                                    .contacts
                                                                    .contacts[
                                                                        index]
                                                                    .mobile,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: AppColors
                                                                        .hintText),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.email,
                                                                  color: AppColors
                                                                      .hintText,
                                                                  size: 18,
                                                                ),
                                                                SizedBox(
                                                                  width: 3,
                                                                ),
                                                                Container(
                                                                  width: ScreenUtil
                                                                          .screenWidthDp *
                                                                      .5,
                                                                  child: Text(
                                                                    model
                                                                        .contacts
                                                                        .contacts[
                                                                            index]
                                                                        .email,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: AppColors
                                                                            .hintText),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .language,
                                                                  color: AppColors
                                                                      .hintText,
                                                                  size: 18,
                                                                ),
                                                                SizedBox(
                                                                  width: 3,
                                                                ),
                                                                Container(
                                                                  width: ScreenUtil
                                                                          .screenWidthDp *
                                                                      .53,
                                                                  child: Text(
                                                                    model
                                                                            .contacts
                                                                            .contacts[index]
                                                                            .website ??
                                                                        "",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: AppColors
                                                                            .hintText),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical:
                                                                      20.0),
                                                          child: Container(
                                                            height: 40,
                                                            width: 80,
                                                            child: RaisedButton(
                                                                onPressed: () {
                                                                  launch(
                                                                      "tel://${model.contacts.contacts[index].mobile}");
                                                                },
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                color: AppColors
                                                                    .ternaryBackground,
                                                                child: Center(
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            5),
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .call,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              18,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              3,
                                                                        ),
                                                                        Text(
                                                                          locale.get('Call') ??
                                                                              'Call',
                                                                          style: TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        0.0),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      new BorderRadius
                                                                              .circular(
                                                                          5.0),
                                                                )),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )))
                              ],
                            )
                          : Center(
                              child: Text(
                              locale.get('Empty') ?? 'Empty',
                            ))
                    ]),
              ),
            );
          }),
    );
  }
}

class UserContactsDetailsPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  final ContactsCateoryModel contacts;

  final key = GlobalKey<ScaffoldState>();

  UserContactsDetailsPageModel(
      {NotifierState state, this.api, this.auth, this.contacts, this.context})
      : super(state: state);
}

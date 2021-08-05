import 'package:enna/core/models/balance.dart';
import 'package:enna/core/models/last_cash_transaction.dart';
import 'package:enna/core/models/last_expense_transaction.dart';
import 'package:enna/core/models/user.dart';
import 'package:enna/core/services/preference/preference.dart';
import 'package:enna/ui/shared/styles/colors.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/core/services/localization/localization.dart';
import 'package:enna/ui/shared/routes/route.dart';
import 'package:ui_utils/ui_utils.dart';

class TransactionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return FocusWidget(
      child: Scaffold(
        body: BaseWidget<TransactionPageModel>(
            model: TransactionPageModel(
                api: Provider.of<Api>(context),
                auth: Provider.of(context),
                context: context),
            builder: (context, model, child) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, left: 20, bottom: 15),
                      child: Container(
                          child: Text(
                        "${locale.get("Transaction Summary") ?? "Transaction Summary"}",
                        style: TextStyle(
                            color: AppColors.blackText,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    model.busy
                        ? Center(child: CircularProgressIndicator())
                        : model.hasError
                            ? Center(
                                child: Text(
                                locale.get('Error') ?? 'Error',
                              ))
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        buildInkMoneyRecieverContainer(
                                            model, locale),
                                        SizedBox(width: 10),
                                        buildInkExpenseContainer(model, locale),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "${locale.get("Cash Balance") ?? "Cash Balance"} : ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              Text(
                                                "${locale.get("QR") ?? "QR"} ${model?.balance?.cashBalance ?? ""}",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color:
                                                        AppColors.primaryText,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                          if (model.auth.user.user.id ==
                                              model.team.creator.id) ...[
                                            FlatButton.icon(
                                                onPressed: () {
                                                  if (model.selection == 1) {
                                                    UI
                                                        .push(context,
                                                            Routes.addcash)
                                                        .then((value) {
                                                      if (value is bool &&
                                                          value) {
                                                        model.getBalanace(
                                                            context);
                                                        model
                                                            .getLastCashByTeamID(
                                                                context);
                                                      }
                                                    });
                                                  } else {
                                                    UI
                                                        .push(context,
                                                            Routes.addexpense)
                                                        .then((value) {
                                                      if (value is bool &&
                                                          value) {
                                                        model.getBalanace(
                                                            context);

                                                        model
                                                            .getLastExpenseByTeamID(
                                                                context);
                                                      }
                                                    });
                                                  }
                                                },
                                                icon: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        color:
                                                            Colors.blue[900]),
                                                    child: Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                    )),
                                                label: Text(
                                                  model.selection == 1
                                                      ? "${locale.get("Add Cash") ?? "Add Cash"}"
                                                      : "${locale.get("Add Expense") ?? "Add Expense"}",
                                                  style: TextStyle(
                                                      color: Colors.blue[900],
                                                      fontSize: 12),
                                                ))
                                          ]
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    Container(
                                      color: Colors.grey,
                                      height: 0.2,
                                      width: ScreenUtil.screenWidthDp / 0.7,
                                    ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    iftrans(context, model),
                                  ],
                                ),
                              ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  InkWell buildInkExpenseContainer(
      TransactionPageModel model, AppLocalizations locale) {
    return InkWell(
      onTap: () {
        model.changeSelection(2);
      },
      child: Container(
        height: 120,
        width: 170,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          color: model.selection == 2 ? Colors.blue[900] : Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${locale.get("Money Spent") ?? "Money Spent"}",
                style: TextStyle(
                    color: model.selection == 2
                        ? Colors.grey[200]
                        : Color.fromARGB(255, 97, 97, 97),
                    fontSize: 12),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "${locale.get("QR") ?? "QR"} ${model?.balance?.expenseBalance ?? ""}",
                style: TextStyle(
                    color: model.selection == 2
                        ? Colors.white
                        : Color.fromARGB(255, 255, 111, 111),
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 30,
                  // width: 50,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: model?.lastExpenses?.length ?? 0,
                      itemBuilder: (context, index) {
                        return CircleAvatar(
                          radius: 20,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              imageUrl:
                                  model.lastExpenses[index].recevedFrom.image,
                              // height: double.infinity,
                              // width: double.infinity,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  CircleAvatar(
                                radius: double.infinity,
                                child: SvgPicture.asset(
                                  "assets/images/contactsIcon.svg",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  InkWell buildInkMoneyRecieverContainer(
      TransactionPageModel model, AppLocalizations locale) {
    return InkWell(
      onTap: () {
        model.changeSelection(1);
      },
      child: Container(
        height: 120,
        width: 170,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          color: model.selection == 1 ? Colors.blue[900] : Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${locale.get("Money Received") ?? "Money Received"}",
                style: TextStyle(
                    color: model.selection == 2
                        ? Color.fromARGB(255, 97, 97, 97)
                        : Colors.grey[200],
                    fontSize: 12),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "${locale.get("QR") ?? "QR"} ${model?.balance?.recieved ?? ""}",
                style: TextStyle(
                    color: model.selection == 2
                        ? Color.fromARGB(255, 51, 219, 62)
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 30,
                  // width: 50,
                  child: Stack(
                      // fit: StackFit.expand,
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: model?.lastCash?.length ?? 0,
                            itemBuilder: (context, index) {
                              return CircleAvatar(
                                radius: 20,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator()),
                                    imageUrl:
                                        model.lastCash[index].recevedFrom.image,
                                    // height: double.infinity,
                                    // width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        CircleAvatar(
                                      radius: 25,
                                      child: SvgPicture.asset(
                                        "assets/images/contactsIcon.svg",
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            })
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  iftrans(BuildContext context, TransactionPageModel model) {
    if (model.selection == 1) {
      return lastTransaction(context, model);
    }
    return lastExpense(context, model);
  }

  Widget lastTransaction(BuildContext context, TransactionPageModel model) {
    final locale = AppLocalizations.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${locale.get("Last Transactions") ?? "Last Transactions"}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              FlatButton(
                  onPressed: () {
                    UI.push(context, Routes.viewAllTransaction);
                  },
                  child: Text(
                    locale.get("View all") ?? "View all",
                    style: TextStyle(color: Colors.blue[900]),
                  ))
            ],
          ),
        ),
        model.busy
            ? CircularProgressIndicator()
            : Container(
                height: ScreenUtil.screenHeightDp / 2.8,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: model?.lastCash?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(150),
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator()),
                                      imageUrl: model
                                          .lastCash[index].recevedFrom.image,
                                      height: double.infinity,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          CircleAvatar(
                                        radius: 25,
                                        child: SvgPicture.asset(
                                          "assets/images/contactsIcon.svg",
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: ScreenUtil.screenWidthDp * .5,
                                      child: Text(
                                        "${model.selection == 1 ? model.lastCash[index].recevedFrom.name : model.lastExpenses[index].recevedFrom.name}",
                                      ),
                                    ),
                                    Text(
                                        "${model.selection == 1 ? model.lastCash[index].receivedDate.substring(0, 10) : model.lastExpenses[index].updatedAt.substring(0, 1)}")
                                  ],
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("QR ${model.lastCash[index].amount}",
                                    style: TextStyle(color: Colors.green)),
                                Text(
                                  locale.get("Recieved") ?? "Recieved",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    }),
              )
      ],
    );
  }

  Widget lastExpense(BuildContext context, TransactionPageModel model) {
    final locale = AppLocalizations.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${locale.get("Last Expenses") ?? "Last Expenses"}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              FlatButton(
                  onPressed: () {
                    UI.push(
                      context,
                      Routes.allexpenses,
                    );
                  },
                  child: Text(
                    locale.get("View all") ?? "View all",
                    style: TextStyle(color: Colors.blue[900]),
                  ))
            ],
          ),
        ),
        model.busy
            ? CircularProgressIndicator()
            : Container(
                height: ScreenUtil.screenHeightDp / 2.8,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: model.lastExpenses.length,
                    itemBuilder: (context, index) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(150),
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator()),
                                      imageUrl: model.lastExpenses[index]
                                          .recevedFrom.image,
                                      height: double.infinity,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          CircleAvatar(
                                        radius: 25,
                                        child: SvgPicture.asset(
                                          "assets/images/contactsIcon.svg",
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: ScreenUtil.screenWidthDp * .45,
                                      child: Text(
                                        "${model.lastExpenses[index].recevedFrom.name}",
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "${model.lastExpenses[index].createdAt.substring(0, 10)}",
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                              height: 30.0,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                    style: BorderStyle.solid,
                                                    width: 1.5,
                                                  ),
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 4.0),
                                                      child: Text(
                                                        "${model.lastExpenses[index].spentFor.name.ar}",
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          // letterSpacing: 1,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                        "QR ${model.lastExpenses[index].amount}",
                                        style: TextStyle(color: Colors.red)),
                                    Text(
                                      locale.get('Spent') ?? 'Spent',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) => Dialog(
                                              child: Container(
                                                  height: ScreenUtil
                                                          .screenHeightDp *
                                                      .7,
                                                  child: Center(
                                                    child: CachedNetworkImage(
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Center(
                                                              child: Text(
                                                                  "Error in loading image")),
                                                      placeholder: (context,
                                                              url) =>
                                                          Center(
                                                              child:
                                                                  CircularProgressIndicator()),
                                                      imageUrl: model
                                                          .lastExpenses[index]
                                                          .reciept,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )),
                                            ));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.receipt,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
              )
      ],
    );
  }
}

class TransactionPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  Teams team;

  List<LastExpensesTransaction> lastExpenses;
  List<LastCashTransaction> lastCash;

  Balance balance;

  int selection = 1;

  TransactionPageModel({
    NotifierState state,
    this.api,
    this.auth,
    this.context,
  }) : super(state: state) {
    getTeam();
  }

  getTeam() async {
    setBusy();
    team = Preference.getString(PrefKeys.TEAM_ID) == null
        ? UI.pushReplaceAll(context, Routes.creatOrJoinTeam)
        : await api.getTeamByTeamID(context,
            teamID: Preference.getString(PrefKeys.TEAM_ID));

    if (team != null) {
      getBalanace(context);
      getLastCashByTeamID(context);
      getLastExpenseByTeamID(context);
    }
  }

  void changeSelection(int i) {
    selection = i;
    // if (i == 1) {
    //   getLastCashByTeamID();
    // } else if (i == 2) {
    //   getLastExpenseByTeamID();
    // }

    setState();
  }

  getLastExpenseByTeamID(BuildContext context) async {
    setBusy();
    lastExpenses = await api.getLastExpenseByTeamID(context, teamId: team.id);
    lastExpenses != null ? setIdle() : setError();

    Logger().v(lastExpenses);
  }

  getLastCashByTeamID(BuildContext context) async {
    setBusy();
    lastCash = await api.getLastCashByTeamID(context, teamId: team.id);
    lastCash != null ? setIdle() : setError();

    Logger().v(lastCash);
  }

  void getBalanace(BuildContext context) async {
    setBusy();
    balance = await api.getBalance(context, teamId: team.id);
    balance != null ? setIdle() : setError();
  }
}

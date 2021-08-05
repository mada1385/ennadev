import 'package:enna/core/models/all_expenses_model.dart';
import 'package:enna/core/models/user.dart';
import 'package:enna/core/services/preference/preference.dart';
import 'package:enna/ui/shared/routes/route.dart';
import 'package:enna/ui/shared/widgets/drawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:enna/core/services/localization/localization.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:provider/provider.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/ui/shared/widgets/app_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ui_utils/ui_utils.dart';

//#TODO: Check model.hasError

class AllExpensesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FocusWidget(
      child: BaseWidget<AllExpensesPageModel>(
          // initState: (m) => WidgetsBinding.instance
          //     .addPostFrameCallback((_) => m.getExpenses()),
          model: AllExpensesPageModel(
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
              body: Container(
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
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          locale.get('sort by') ?? 'sort by',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: dropDown(context, model),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  locale.get('All Expenses') ?? 'All Expenses',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                model.busy
                                    ? Center(child: CircularProgressIndicator())
                                    : model.hasError
                                        ? Center(
                                            child: Text(
                                            locale.get('Error') ?? 'Error',
                                          ))
                                        : buildList(model, locale)
                              ],
                            ),
                ),
              ),
            );
          }),
    );
  }

  Widget buildList(AllExpensesPageModel model, AppLocalizations locale) {
    return Expanded(
      child: SmartRefresher(
        controller: model.refreshController,
        onLoading: () => model.onLoading(),
        onRefresh: () => model.onRefresh(),
        enablePullUp: true,
        enablePullDown: true,
        child: buildListOfItems(model, locale),
      ),
    );
  }

  ListView buildListOfItems(
      AllExpensesPageModel model, AppLocalizations locale) {
    return ListView.builder(
        // shrinkWrap: true,
        itemCount: model.expenses.items.length,
        itemBuilder: (ctx, index) => buildItem(ctx, model, index, locale));
  }

  Padding buildItem(BuildContext context, AllExpensesPageModel model, int index,
      AppLocalizations locale) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(150),
                child: CachedNetworkImage(
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  imageUrl: model.expenses.items[index].recevedFrom.image,
                  height: 65,
                  fit: BoxFit.scaleDown,
                  errorWidget: (context, url, error) => CircleAvatar(
                    radius: 25,
                    child: SvgPicture.asset(
                      "assets/images/contactsIcon.svg",
                      color: Colors.white,
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
                      width: ScreenUtil.screenWidthDp * 0.4,
                      child: Text(
                        "${model.expenses.items[index].recevedFrom.name}",
                      )),
                  Row(
                    children: [
                      Text(
                        "${model.expenses.items[index].createdAt.substring(0, 10)}",
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            height: 20.0,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey[500],
                                  style: BorderStyle.solid,
                                  width: 1.0,
                                ),
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      "${model.expenses.items[index].spentFor.name.en}",
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1,
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
                  Text("QR${model.expenses.items[index].amount}",
                      style: TextStyle(color: Colors.red)),
                  Text(
                    locale.get('Spent') ?? 'Spent',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
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
                      builder:(_)=> Dialog(
                        child: Container(
                            height: ScreenUtil.screenHeightDp * .7,
                            child: CachedNetworkImage(
                              errorWidget: (context, url, error) =>
                                  Center(child: Text("Error in loading image")),
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              imageUrl: model.expenses.items[index].reciept,
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
      ),
    );
  }

  Widget dropDown(BuildContext context, AllExpensesPageModel model) {
    final locale = AppLocalizations.of(context);

    return Container(
      height: 40,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButtonHideUnderline(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton(
              hint: model.dropVal != null
                  ? Text(locale.get(model.dropVal) ?? model.dropVal)
                  : Text(locale.get("Sort") ?? "Sort"),
              items: [
                DropdownMenuItem(
                  child: Text(
                    locale.get('Date') ?? 'Date',
                  ),
                  value: "date",
                ),
                DropdownMenuItem(
                  child: Text(
                    locale.get('Amount') ?? 'Amount',
                  ),
                  value: 'amount',
                ),
              ],
              onChanged: (value) {
                model.dropVal = value;
                model.param['sort'] = value;
                model.getExpenses();
              }),
        ),
      ),
    );
  }
}

class AllExpensesPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  AllExpensesModel expenses;

  Map<String, dynamic> param = {};

  final key = GlobalKey<ScaffoldState>();

  // var team = Teams.fromJson(jsonDecode(Preference.getString(PrefKeys.TEAM_ID)));

  Teams team;

  AllExpensesPageModel(
      {NotifierState state, this.api, this.auth, this.context, this.expenses})
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
      param = {'page': 1, 'teamId': team.id, 'sort': ''};
      await getExpenses();
    } else {
      setError();
    }
  }

  String dropVal;

  RefreshController refreshController = RefreshController();

  getExpenses() async {
    setBusy();
    expenses = await api.getAllExpenses(context: context, param: param);

    if (expenses != null) {
      setIdle();
    } else {
      setError();
    }
  }

  onRefresh() async {
    param['page'] = 1;
    setBusy();
    AllExpensesModel temp =
        await api.getAllExpenses(context: context, param: param);

    if (temp != null && temp.items.isNotEmpty) {
      expenses = temp;
      setIdle();
    } else {
      setError();
    }

    refreshController.refreshCompleted();
  }

  onLoading() async {
    param['page'] = param['page'] + 1;

    var temp = await api.getAllExpenses(context: context, param: param);
    expenses.items.addAll(temp.items);
    refreshController.loadComplete();
  }
}

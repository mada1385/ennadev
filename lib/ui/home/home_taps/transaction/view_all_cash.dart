import 'package:enna/core/models/all_cash_model.dart';
import 'package:enna/core/services/preference/preference.dart';
import 'package:enna/ui/shared/routes/route.dart';
import 'package:enna/ui/shared/widgets/drawer.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:enna/core/services/localization/localization.dart';
import 'package:provider/provider.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/ui/shared/widgets/app_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ui_utils/ui_utils.dart';

class AllTransactionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FocusWidget(
      child: BaseWidget<AllTransactionPageModel>(
          // initState: (m) => WidgetsBinding.instance
          //     .addPostFrameCallback((_) => m.getAllCash()),
          model: AllTransactionPageModel(
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
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
                                            locale.get('Sort by') ?? 'Sort by',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          dropDown(context, model),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    locale.get('All Transactions') ??
                                        'All Transactions',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                model.busy
                                    ? Center(child: CircularProgressIndicator())
                                    : buildListOfItems(context, model)
                              ],
                            ),
                ),
              ),
            );
          }),
    );
  }

  Widget buildListOfItems(BuildContext context, AllTransactionPageModel model) {
    final locale = AppLocalizations.of(context);
    return Expanded(
      child: SmartRefresher(
        onLoading: () => model.onLoading(),
        onRefresh: () => model.onRefresh(),
        controller: model.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: model.cash.items.length,
            itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              imageUrl:
                                  model.cash.items[index].recevedFrom.image,
                              height: 65,
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
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: ScreenUtil.screenWidthDp * .5,
                                child: Text(
                                    "${model.cash.items[index].recevedFrom.name}"),
                              ),
                              Text(
                                  "${model.cash.items[index].receivedDate.substring(1, 10)}")
                            ],
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("QR ${model.cash.items[index].amount}",
                              style: TextStyle(color: Colors.green)),
                          Text(
                            locale.get("Recieved") ?? "Recieved",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          )
                        ],
                      )
                    ],
                  ),
                )),
      ),
    );
  }

  Widget dropDown(BuildContext context, AllTransactionPageModel model) {
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
                model.getAllCash();
              }),
        ),
      ),
    );
  }
}

class AllTransactionPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  AllCash cash;

  Map<String, dynamic> param;

  var team;

  final key = GlobalKey<ScaffoldState>();

  String dropVal;

  AllTransactionPageModel(
      {NotifierState state, this.api, this.auth, this.context})
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
      await getAllCash();
    } else {
      setError();
    }
  }

  RefreshController refreshController = RefreshController();

  onRefresh() async {
    param['page'] = 1;
    setBusy();
    AllCash temp = await api.getAllCash(context: context, param: param);

    if (temp != null && temp.items.isNotEmpty) {
      cash = temp;
      setIdle();
    } else {
      setError();
    }

    refreshController.refreshCompleted();
  }

  onLoading() async {
    param['page'] = param['page'] + 1;
    var temp = await api.getAllCash(context: context, param: param);
    cash.items.addAll(temp.items);
    refreshController.loadComplete();
  }

  getAllCash() async {
    setBusy();

    cash = await api.getAllCash(context: context, param: param);

    if (cash != null) {
      setIdle();
    } else {
      setError();
    }
  }
}

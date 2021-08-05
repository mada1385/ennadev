import 'package:enna/core/models/my_orders.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/ui/shared/styles/colors.dart';
import 'package:enna/ui/shared/widgets/app_bar.dart';
import 'package:enna/ui/shared/widgets/drawer.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

import '../../../core/services/localization/localization.dart';

class MyOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FocusWidget(
      child: BaseWidget<MyOrdersPageModel>(
          initState: (m) => WidgetsBinding.instance
              .addPostFrameCallback((_) => m.getOrders()),
          model: MyOrdersPageModel(
              api: Provider.of<Api>(context),
              auth: Provider.of(context),
              context: context),
          builder: (ctx, model, child) {
            return Scaffold(
              key: model.key,
              appBar: AppBarWidget(
                openDrawer: () => model.key.currentState.openDrawer(),
              ),
              drawer: AppDrawer(
                ctx: ctx,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
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
                          SizedBox(width: ScreenUtil.screenWidthDp / 3),
                          Text(
                            locale.get('My Orders') ?? 'My Orders',
                          ),
                        ],
                      ),
                      model.busy
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : model.hasError
                              ? Center(
                                  child: Text(
                                    locale.get('Error') ?? 'Error',
                                  ),
                                )
                              : model.orders != null
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 30),
                                      child: Column(
                                        children: [
                                          ...List.generate(
                                            model.orders.length,
                                            (ind) => Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Image.network(
                                                        model
                                                            .orders[ind]
                                                            .lines[0]
                                                            .product
                                                            .images[0],
                                                        width: 70,
                                                        height: 70,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              model
                                                                          .orders[
                                                                              ind]
                                                                          .lines[
                                                                              0]
                                                                          .product
                                                                          .name
                                                                          .en !=
                                                                      null
                                                                  ? Text(
                                                                      model
                                                                          .orders[
                                                                              ind]
                                                                          .lines[
                                                                              0]
                                                                          .product
                                                                          .name
                                                                          .en,
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    )
                                                                  : Text(
                                                                      model
                                                                          .orders[
                                                                              ind]
                                                                          .lines[
                                                                              0]
                                                                          .product
                                                                          .name
                                                                          .ar,
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                            ],
                                                          ),
                                                          Text(
                                                            "${locale.get('status') ?? 'status'} : ${model.orders[ind].status}",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        10),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "${model.orders[ind].lines[0].product.price} \QR +",
                                                                  style: TextStyle(
                                                                      color: AppColors
                                                                          .ternaryBackground,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                Text(
                                                                  " Arrived ${model.orders[ind].createdAt.substring(0, 8)}07",
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xFFBCBCBC),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  // IconButton(icon: Icon(Icons.more_horiz), onPressed: onPress)
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 10),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            color: Color.fromRGBO(
                                                188, 188, 188, 0.17),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                // Text(
                                                //   "Order no. #${myOrder.lines[index].id}",
                                                //   style: TextStyle(fontWeight: FontWeight.bold),
                                                // ),
                                                // Padding(
                                                //   padding: const EdgeInsets.symmetric(
                                                //       vertical: 10.0),
                                                //   child: Text(
                                                //     " Arrived monday 20/1/2020",
                                                //     style: TextStyle(
                                                //         color: Color(0xFFBCBCBC),
                                                //         fontWeight: FontWeight.bold),
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : Center(
                                      child: Text("You Don't have Orders")),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class MyOrdersPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  final key = GlobalKey<ScaffoldState>();

  List<MyOrders> orders;

  MyOrdersPageModel({NotifierState state, this.api, this.auth, this.context})
      : super(state: state);

  getOrders() async {
    setBusy();
    orders =
        await api.getUserOrders(context, param: {'userId': auth.user.user.id});
    orders != null ? setIdle() : setError();
  }
}

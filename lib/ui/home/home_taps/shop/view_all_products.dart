import 'package:enna/core/models/product_items.dart';
import 'package:enna/core/models/products_with_items.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/localization/localization.dart';
import 'package:enna/ui/shared/routes/route.dart';
import 'package:enna/ui/shared/widgets/app_bar.dart';
import 'package:enna/ui/shared/widgets/drawer.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ui_utils/ui_utils.dart';

class ViewAllProductsPage extends StatelessWidget {
  final ProductsWithItems category;
  final bool isUser;
  ViewAllProductsPage({this.category, this.isUser});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return BaseWidget<ViewAllProductsPageModel>(
        model: ViewAllProductsPageModel(
            api: Provider.of<Api>(context),
            auth: Provider.of(context),
            category: category,
            isUser: isUser,
            context: context),
        initState: (model) => WidgetsBinding.instance.addPostFrameCallback((_) {
              model.getItemsForCategory();
            }),
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBarWidget(
              openDrawer: () => model.key.currentState.openDrawer(),
            ),
            drawer: AppDrawer(
              ctx: context,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            "${locale.get("Sort by") ?? "Sort by"}",
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
                  model.busy
                      ? Expanded(
                          child: Center(
                          child: CircularProgressIndicator(),
                        ))
                      : model.hasError
                          ? Expanded(
                              child: Center(
                              child: Text(
                                locale.get('Error') ?? 'Error',
                              ),
                            ))
                          : body(context, model),
                ],
              ),
            ),
          );
        });
  }

  Widget body(BuildContext context, ViewAllProductsPageModel model) {
    return Expanded(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          model.category.name.localized(context),
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: SmartRefresher(
            controller: model.refreshController,
            onLoading: () => model.onLoading(),
            onRefresh: () => model.onRefresh(),
            enablePullDown: true,
            enablePullUp: true,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: model?.products?.length ?? 0,
                itemBuilder: (ctx, index) => InkWell(
                      onTap: () => UI.push(context,
                          Routes.product(product: model.products[index])),
                      child: Container(
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13.0)),
                          elevation: 5,
                          color: Colors.grey[100],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.grey[300]),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      shape: BoxShape.rectangle),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: model.products[index].images ==
                                                null ||
                                            model.products[index].images.isEmpty
                                        ? Icon(
                                            Icons.broken_image_sharp,
                                            size: 30,
                                            color: Colors.redAccent,
                                          )
                                        : CachedNetworkImage(
                                            imageUrl:
                                                model.products[index].images[0],
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                            Colors.red,
                                                            BlendMode
                                                                .colorBurn)),
                                              ),
                                            ),
                                            placeholder: (context, url) => Center(
                                                child:
                                                    CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          child: model.products[index].name
                                                      .en !=
                                                  null
                                              ? Text(
                                                  model.products[index].name.en,
                                                  maxLines: 3,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15),
                                                  textAlign: TextAlign.justify,
                                                )
                                              : Text(
                                                  model.products[index].name.ar,
                                                  maxLines: 3,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15),
                                                  textAlign: TextAlign.justify,
                                                ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'QR ${model.products[index].price}',
                                              style: TextStyle(
                                                  color: Colors.blue[900],
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            decoration: new BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.green[400]),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                shape: BoxShape.rectangle),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    model
                                                        .products[index].cRating
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.green[400]),
                                                  ),
                                                  Icon(
                                                    Icons.star_border,
                                                    color: Colors.green[400],
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )),
          ),
        ),
      ]),
    );
  }

  Widget dropDown(BuildContext context, ViewAllProductsPageModel model) {
    final locale = AppLocalizations.of(context);

    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: Colors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
                /* 
              popularity, priceLTH, priceHTL, seller */
                value: model.param['sort'],
                items: [
                  DropdownMenuItem(
                    child: Text(
                      locale.get('Popularity') ?? 'Popularity',
                    ),
                    value: "popularity",
                  ),
                  DropdownMenuItem(
                      child: Text(
                        locale.get('Price low to high') ?? 'Price low to high',
                      ),
                      value: "priceLTH"),
                  DropdownMenuItem(
                      child: Text(
                        locale.get('Price high to low') ?? 'Price high to low',
                      ),
                      value: "priceHTL"),
                  DropdownMenuItem(child: Text("Seller"), value: "seller")
                ],
                onChanged: (value) {
                  model.onRadioChange(value);
                }),
          ),
        ),
      ),
    );
  }
}

class ViewAllProductsPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  final key = GlobalKey<ScaffoldState>();

  final bool isUser;

  ProductsWithItems category;
  List<Products> products;

  Map<String, dynamic> param;

  RefreshController refreshController = RefreshController();

  ViewAllProductsPageModel(
      {NotifierState state,
      this.api,
      this.auth,
      this.context,
      this.category,
      this.isUser})
      : super(state: state) {
    param = {'page': 1, 'categoryId': category.id, 'sort': 'popularity'};
  }

  getItemsForCategory() async {
    setBusy();
    products = isUser
        ? await api.getUserProducts(param: param)
        : await api.getCompanyProducts(context, param: param);
    products != null ? setIdle() : setError();
  }

  onLoading() async {
    param['page'] = param['page'] + 1;
    products.addAll(isUser
        ? await api.getUserProducts(param: param)
        : await api.getCompanyProducts(context, param: param) ?? []);

    setIdle();
    refreshController.loadComplete();
  }

  onRefresh() async {
    param['page'] = 1;
    await getItemsForCategory();
    refreshController.refreshCompleted();
  }

  onRadioChange(String val) async {
    param['sort'] = val;
    setBusy();
    List<Products> temp = isUser
        ? await api.getUserProducts(param: param)
        : await api.getCompanyProducts(context, param: param);

    if (temp != null) {
      products = temp;
      setIdle();
    } else {
      UI.toast("Error");
      setError();
    }
  }
}

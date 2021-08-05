import 'package:enna/core/models/category.dart';
import 'package:enna/core/models/products_with_items.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/core/services/localization/localization.dart';
import 'package:enna/ui/shared/routes/route.dart';
import 'package:enna/ui/shared/styles/colors.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

class UserProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FocusWidget(
      child: Scaffold(
        body: BaseWidget<UserProductsPageModel>(
            initState: (m) =>
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  await m.getCategories();
                  await m.getUserCategoriesWithItems();
                }),
            model: UserProductsPageModel(
                api: Provider.of<Api>(context),
                auth: Provider.of(context),
                context: context),
            builder: (context, model, child) {
              final locale = AppLocalizations.of(context);
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${locale.get("Categories") ?? "Categories"}",
                            style: TextStyle(
                                fontSize: 20,
                                color: AppColors.blackText,
                                fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: () {
                              UI
                                  .push(
                                      context,
                                      Routes.addProduct(
                                          categories: model.categories))
                                  .then((value) {
                                if (value != null && value is bool) {
                                  model.getCategories();
                                  model.getUserCategoriesWithItems();
                                }
                              });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add_circle,
                                  color: AppColors.ternaryBackground,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${locale.get("Add product") ?? "Add product"}",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.ternaryBackground),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    model.busy
                        ? Center(child: CircularProgressIndicator())
                        : model.hasError
                            ? Center(
                                child: Text(
                                  locale.get('Error') ?? 'Error',
                                ),
                              )
                            : buildCategories(context, model),
                    Container(
                      width: double.infinity,
                      height: 0.2,
                      color: Colors.black,
                    ),
                    if (model.categories != null &&
                        model.categories.isNotEmpty &&
                        model.items != null &&
                        model.items.isNotEmpty) ...[
                      buildCategoriesWithItems(context, model),
                    ]
                  ],
                ),
              );
            }),
      ),
    );
  }

  Widget buildCategories(BuildContext context, UserProductsPageModel model) {
    final locale = AppLocalizations.of(context);

    return model.categories != null
        ? Container(
            margin: EdgeInsets.symmetric(
              vertical: 20.0,
            ),
            height: 50.0,
            child: model.categories.isEmpty
                ? Center(
                    child: Text(
                    locale.get('There are no categories') ??
                        'There are no categories',
                  ))
                : new ListView.builder(
                    shrinkWrap: true,
                    itemCount: model.categories.length,
                    // addSemanticIndexes: true,

                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, index) =>
                        buildCateogry(ctx, index, model),
                  ))
        : Container(
            height: 50,
          );
  }

  Widget buildCateogry(
      BuildContext context, int index, UserProductsPageModel model) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          ProductsWithItems temp = ProductsWithItems(
              id: model.categories[index].id,
              name: model.categories[index].name);
          UI.push(
              context, Routes.viewAllProducts(category: temp, isUser: true));
        },
        child: Container(
            decoration: new BoxDecoration(
                border: Border.all(color: Colors.blue[800], width: 1.5),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                shape: BoxShape.rectangle),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(model.categories[index].name.localized(context)),
            ))),
      ),
    );
  }

  Widget buildCategoriesWithItems(
      BuildContext context, UserProductsPageModel model) {
    final locale = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: model.items.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, ind) => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    model.items[ind].name.localized(ctx).toString(),
                    style: TextStyle(
                        color: AppColors.blackText,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                  InkWell(
                    onTap: () {
                      UI.push(
                          context,
                          Routes.viewAllProducts(
                              category: model.items[ind], isUser: true));
                    },
                    child: Text(
                      "${locale.get("View all") ?? "View all"}",
                      style: TextStyle(
                          color: AppColors.ternaryBackground,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  )
                ],
              ),
              if (model.items != null) ...[
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: model.items[ind].products.length,
                    itemBuilder: (ctx, index) {
                      var item = model.items[ind].products[index];
                      return Padding(
                          padding: const EdgeInsets.only(left: 12.0, right: 12),
                          child: InkWell(
                            onTap: () {
                              UI.push(context, Routes.product(product: item));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13.0)),
                              elevation: 2,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 0.4,
                                              color: AppColors.hintText),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          shape: BoxShape.rectangle),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: item.images == null || item.images.isEmpty
                                            ? Icon(
                                              Icons.broken_image_sharp,
                                              size: 30,
                                              color: Colors.redAccent,
                                            )
                                            : CachedNetworkImage(
                                                imageUrl: item.images[0],
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    Center(
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
                                              child: Text(
                                                item.name.localized(context) ??
                                                    item.id,
                                                maxLines: 3,
                                                style: TextStyle(
                                                    color: AppColors.blackText,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "${locale.get("QR") ?? "QR"} ${item.price} ",
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .ternaryBackground,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Container(
                                                decoration: new BoxDecoration(
                                                    border: Border.all(
                                                        color: AppColors.green),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    shape: BoxShape.rectangle),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        item.cRating.toString(),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: AppColors
                                                                .green),
                                                      ),
                                                      Icon(
                                                        Icons.star,
                                                        color: AppColors.green,
                                                        size: 20,
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
                          ));
                    })
              ]
            ],
          ),
        ),
      ]),
    );
  }
}

class UserProductsPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  List<Category> categories;
  List<ProductsWithItems> items;

  UserProductsPageModel(
      {NotifierState state, this.api, this.auth, this.context})
      : super(state: state);

  getCategories() async {
    setBusy();
    categories = await api.getCategories(context);
    categories != null ? setIdle() : setError();
  }

  getUserCategoriesWithItems() async {
    setBusy();
    items = await api.getUserCategoriesWithItems(context);
    items != null ? setIdle() : setBusy();
  }
}

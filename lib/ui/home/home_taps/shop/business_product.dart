// import 'package:enna/core/services/api/http_api.dart';
// import 'package:enna/core/services/auth/authentication_service.dart';
// import 'package:base_notifier/base_notifier.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:ui_utils/ui_utils.dart';

// class BusinessProductsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return FocusWidget(
//       child: Scaffold(
//         body: BaseWidget<BusinessProductsPageModel>(
//             //initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.initializeProfileData()),
//             model: BusinessProductsPageModel(
//                 api: Provider.of(context),
//                 auth: Provider.of(context),
//                 context: context),
//             builder: (context, model, child) {
//               return SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "${locale.get("View all") ?? "View all"}",
//                         style: TextStyle(
//                             fontSize: 20,
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       buildCategories(context, model),
//                       Container(
//                         width: double.infinity,
//                         height: 0.2,
//                         color: Colors.black,
//                       ),
//                       buildCategoriesWithItems(context, model),
//                     ],
//                   ),
//                 ),
//               );
//             }),
//       ),
//     );
//   }

// Widget buildCategories(BuildContext context, ShopPageModel model) {
//   return model.categories != null
//       ? Container(
//           margin: EdgeInsets.symmetric(vertical: 20.0),
//           height: 50.0,
//           child: model.categories.isEmpty
//               ? Center(child: Text("There is no categories"))
//               : new ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: model.categories.length,
//                   // addSemanticIndexes: true,

//                   scrollDirection: Axis.horizontal,
//                   itemBuilder: (ctx, index) =>
//                       buildCateogry(ctx, index, model),
//                 ))
//       : Container(
//           height: 50,
//         );
// }

// Widget buildCateogry(BuildContext context, int index, ShopPageModel model) {
//   return InkWell(
//     onTap: () {
//       model.getProducts(categoryId: model.categories[index].id);
//     },
//     child: Container(
//         decoration: new BoxDecoration(
//             border: Border.all(color: Colors.blue[800], width: 1.5),
//             borderRadius: BorderRadius.all(Radius.circular(20)),
//             shape: BoxShape.rectangle),
//         child: Center(
//             child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(model.categories[index].name.localized(context)),
//         ))),
//   );
// }

// Widget buildCategoriesWithItems(BuildContext context, ShopPageModel model) {
//   final locale = AppLocalizations.of(context);

//   return Column(children: [
//     ListView.builder(
//       itemCount: model.items.length,
//       itemBuilder: (ctx, ind) => Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   model.categories[ind].name.localized(ctx),
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 22),
//                 ),
//                 InkWell(
//                   onTap: () {
//                     UI.push(context, Routes.viewAllProducts);
//                   },
//                   child: Text(
//                     "${locale.get("View all") ?? "View all"}",
//                     style: TextStyle(
//                         color: Colors.blue[900],
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           if (model.items != null) ...[
//             ListView.builder(
//                 itemCount: model.items.length,
//                 itemBuilder: (ctx, index) => Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Container(
//                         child: InkWell(
//                           onTap: () {
//                             UI.push(context, Routes.product);
//                           },
//                           child: Card(
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(13.0)),
//                             elevation: 5,
//                             color: Colors.grey[100],
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     width: 100,
//                                     height: 100,
//                                     decoration: BoxDecoration(
//                                         border: Border.all(
//                                             color: Colors.grey[300]),
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(5)),
//                                         shape: BoxShape.rectangle),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(2.0),
//                                       child: CachedNetworkImage(
//                                         imageUrl:
//                                             "https://wonderfulengineering.com/wp-content/uploads/2016/01/10-EssentiaL-Camping-tools-3.jpg",
//                                         imageBuilder:
//                                             (context, imageProvider) =>
//                                                 Container(
//                                           decoration: BoxDecoration(
//                                             image: DecorationImage(
//                                                 image: imageProvider,
//                                                 fit: BoxFit.cover,
//                                                 colorFilter: ColorFilter.mode(
//                                                     Colors.red,
//                                                     BlendMode.colorBurn)),
//                                           ),
//                                         ),
//                                         placeholder: (context, url) =>
//                                             CircularProgressIndicator(),
//                                         errorWidget: (context, url, error) =>
//                                             Icon(Icons.error),
//                                       ),
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Container(
//                                             child: Text(
//                                               'Dhuwan Kalan Store (10x5 ft) With Niwar Camping Nev',
//                                               maxLines: 3,
//                                               style: TextStyle(
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: 15),
//                                               textAlign: TextAlign.justify,
//                                             ),
//                                           ),
//                                         ),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: Text(
//                                                 'QR 99',
//                                                 style: TextStyle(
//                                                     color: Colors.blue[900],
//                                                     fontSize: 15,
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               ),
//                                             ),
//                                             Container(
//                                               decoration: new BoxDecoration(
//                                                   border: Border.all(
//                                                       color:
//                                                           Colors.green[400]),
//                                                   borderRadius:
//                                                       BorderRadius.all(
//                                                           Radius.circular(5)),
//                                                   shape: BoxShape.rectangle),
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(5.0),
//                                                 child: Row(
//                                                   children: [
//                                                     Text(
//                                                       '4.5',
//                                                       style: TextStyle(
//                                                           fontWeight:
//                                                               FontWeight.bold,
//                                                           color: Colors
//                                                               .green[400]),
//                                                     ),
//                                                     Icon(
//                                                       Icons.star_border,
//                                                       color:
//                                                           Colors.green[400],
//                                                     )
//                                                   ],
//                                                 ),
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ))),
//           ]
//         ],
//       ),
//     ),
//   ]);
// }
// }

// class BusinessProductsPageModel extends BaseNotifier {
//   final HttpApi api;
//   final AuthenticationService auth;
//   final BuildContext context;
//   BusinessProductsPageModel(
//       {NotifierState state, this.api, this.auth, this.context})
//       : super(state: state);
// }

import 'package:enna/core/models/category.dart';
import 'package:enna/core/models/products_with_items.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/core/services/localization/localization.dart';
import 'package:enna/ui/shared/routes/route.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:enna/ui/shared/styles/colors.dart';

class BusinessProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FocusWidget(
      child: Scaffold(
        body: BaseWidget<BusinessProductsPageModel>(
            initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) {
                  m.getCategories();
                  m.getBusinessCategoriesWithItems();
                }),
            model: BusinessProductsPageModel(
                api: Provider.of<Api>(context),
                auth: Provider.of(context),
                context: context),
            builder: (context, model, child) {
              final locale = AppLocalizations.of(context);
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(12.0),
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
                          // InkWell(
                          //   onTap: () {
                          //     UI.push(
                          //         context,
                          //         Routes.addProduct(
                          //             categories: model.categories));
                          //   },
                          //   child: Row(
                          //     children: [
                          //       Icon(
                          //         Icons.add_circle,
                          //         color: Colors.blue[900],
                          //       ),
                          //       SizedBox(
                          //         width: 5,
                          //       ),
                          //       Text(
                          //         "${locale.get("Add product") ?? "Add product"}",
                          //         style: TextStyle(
                          //             fontSize: 15,
                          //             fontWeight: FontWeight.bold,
                          //             color: Colors.blue[900]),
                          //       ),
                          //     ],
                          //   ),
                          // ),
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

  Widget buildCategories(
      BuildContext context, BusinessProductsPageModel model) {
    final locale = AppLocalizations.of(context);

    return model.categories != null
        ? Container(
            margin: EdgeInsets.symmetric(vertical: 20.0),
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
      BuildContext context, int index, BusinessProductsPageModel model) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          ProductsWithItems temp = ProductsWithItems(
              id: model.categories[index].id,
              name: model.categories[index].name);
          UI.push(
              context, Routes.viewAllProducts(category: temp, isUser: false));
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
      BuildContext context, BusinessProductsPageModel model) {
    final locale = AppLocalizations.of(context);
    return Column(children: [
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: model.items.length,
        itemBuilder: (ctx, ind) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      model.items[ind].name.localized(ctx),
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                    InkWell(
                      onTap: () {
                        UI.push(
                            context,
                            Routes.viewAllProducts(
                                category: model.items[ind], isUser: false));
                      },
                      child: Text(
                        "${locale.get("View all") ?? "View all"}",
                        style: TextStyle(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    )
                  ],
                ),
              ),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        shape: BoxShape.rectangle),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: CachedNetworkImage(
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
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
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
                                              item.name.localized(context),
                                              maxLines: 3,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "QR " + item.price.toString(),
                                                style: TextStyle(
                                                    color: Colors.blue[900],
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Container(
                                              decoration: new BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.green[400]),
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
                                                          color: Colors
                                                              .green[400]),
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
                        ));
                  })
            ]
          ],
        ),
      ),
    ]);
  }
}

class BusinessProductsPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  List<Category> categories;
  List<ProductsWithItems> items;

  BusinessProductsPageModel(
      {NotifierState state, this.api, this.auth, this.context})
      : super(state: state);

  getCategories() async {
    setBusy();
    categories = await api.getCategories(context);
    categories != null ? setIdle() : setError();
  }

  getBusinessCategoriesWithItems() async {
    setBusy();
    items = await api.getBusinessCategoriesWithItems(context);
    items != null ? setIdle() : setBusy();
  }
}

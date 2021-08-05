import 'package:enna/core/models/category.dart';
import 'package:enna/core/models/product_items.dart';
import 'package:enna/core/services/localization/localization.dart';
import 'package:enna/ui/home/home_taps/shop/business_product.dart';
import 'package:enna/ui/home/home_taps/shop/user_products.dart';
import 'package:enna/ui/shared/styles/colors.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:ui_utils/ui_utils.dart';

class ShopePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return BaseWidget<ShopPageModel>(
      // initState: (model) => WidgetsBinding.instance.addPostFrameCallback((_) {
      //   model.getCategories();
      // }),
      model: ShopPageModel(
          api: Provider.of<Api>(context),
          auth: Provider.of(context),
          context: context,
          state: NotifierState.busy),
      builder: (context, model, child) => FocusWidget(
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(ScreenUtil.screenHeightDp / 13),
              child: AppBar(
                backgroundColor: AppColors.ternaryBackground,
                bottom: TabBar(
                  // onTap: (value) {
                  //   model.changeTapSelection(value);
                  //   model.categories != null && model.categories.isNotEmpty
                  //       ? model.getProducts(categoryId: model.categories[0].id)
                  //       : null;
                  // },
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  physics: NeverScrollableScrollPhysics(),
                  tabs: [
                    Tab(
                      text: "${locale.get("USER PRODUCTS") ?? "USER PRODUCTS"}",
                    ),
                    Tab(
                        text:
                            "${locale.get("BUSINESS PRODUCTS") ?? "BUSINESS PRODUCTS"}"),
                  ],
                ),
              ),
            ),
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                UserProductsPage(),
                BusinessProductsPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget userProducts(BuildContext context, ShopPageModel model) {
  //   final locale = AppLocalizations.of(context);

  //   return SingleChildScrollView(
  //     child: Column(
  //       children: [
  // Padding(
  //   padding: const EdgeInsets.all(12.0),
  //   child: Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Text(
  //         "${locale.get("Categories") ?? "Categories"}",
  //         style: TextStyle(
  //             fontSize: 20,
  //             color: Colors.black,
  //             fontWeight: FontWeight.bold),
  //       ),
  //       InkWell(
  //         onTap: () {
  //           UI.push(context, Routes.addProduct);
  //         },
  //         child: Row(
  //           children: [
  //             Icon(
  //               Icons.add_circle,
  //               color: Colors.blue[900],
  //             ),
  //             SizedBox(
  //               width: 5,
  //             ),
  //             Text(
  //               "${locale.get("Add product") ?? "Add product"}",
  //               style: TextStyle(
  //                   fontSize: 15,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.blue[900]),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   ),
  // ),
  // model.busy
  //     ? Center(child: CircularProgressIndicator())
  //     : model.hasError
  //         ? Center(
  //             child: Text("There is an error"),
  //           )
  //         : buildCategories(context, model),
  // Container(
  //   width: double.infinity,
  //   height: 0.2,
  //   color: Colors.black,
  // ),
  // if (model.categories != null &&
  //     model.categories.isNotEmpty &&
  //     model.items != null &&
  //     model.items.isNotEmpty) ...[
  //   buildCategoriesWithItems(context, model),
  // ]
  //       ],
  //     ),
  //   );
  // }

  // Widget index(BuildContext context) {
  //   return ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       itemBuilder: (context, index) {
  //         return Text(index.toString());
  //       });
  // }

  // Widget businessProducts(BuildContext context, ShopPageModel model) {
  //   final locale = AppLocalizations.of(context);

  //   return SingleChildScrollView(
  //     child: Padding(
  //       padding: const EdgeInsets.all(12.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             "${locale.get("View all") ?? "View all"}",
  //             style: TextStyle(
  //                 fontSize: 20,
  //                 color: Colors.black,
  //                 fontWeight: FontWeight.bold),
  //           ),
  //           buildCategories(context, model),
  //           Container(
  //             width: double.infinity,
  //             height: 0.2,
  //             color: Colors.black,
  //           ),
  //           buildCategoriesWithItems(context, model),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

class ShopPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  int tapSelection = 1;

  Map<String, dynamic> param;

  ShopPageModel({NotifierState state, this.api, this.auth, this.context})
      : super(state: state) {
    // param = {"categoryId": "", "page": 1};
  }

  List<Category> categories;
  List<Products> items;

  void changeTapSelection(int value) async {
    tapSelection = value;
    setState();

    // switch (tapSelection) {
    //   case 1:
    //     getUserProducts(categoryId: "1");
    //     break;
    //   case 2:
    //     getCompanyProducts(categoryId: "1");
    //     break;
    // }
  }

  // getCategories() async {
  //   setBusy();
  //   categories = await api.getCategories(context);
  //   categories != null ? setIdle() : setError();
  // }

  // void getProducts({String categoryId}) async {
  //   setBusy();
  //   param['categoryId'] = categoryId;
  //   items = tapSelection == 1
  //       ? await api.getUserProducts(param: param)
  //       : await api.getCompanyProducts(param: param);
  //   items != null ? setIdle() : setError();
  // }
}

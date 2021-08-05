import 'package:enna/core/models/product_items.dart';
import 'package:enna/core/services/localization/localization.dart';
import 'package:enna/ui/shared/styles/colors.dart';
import 'package:enna/ui/shared/widgets/drawer.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/ui/shared/routes/route.dart';
import 'package:enna/ui/shared/widgets/app_bar.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// ignore: must_be_immutable
class ProductPage extends StatelessWidget {
  final Products product;
  ProductPage({this.product});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return FocusWidget(
      child: BaseWidget<ProductPageModel>(
        //initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.initializeProfileData()),
        model: ProductPageModel(
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
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: images(context, model),
                    ),
                    Text(
                      product.name.localized(context),
                      maxLines: 3,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: AppColors.blackText),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${locale.get("QR") ?? "QR"} ${product.price.toString()}",
                          style: TextStyle(
                              color: AppColors.ternaryBackground,
                              fontSize: 20,
                              fontWeight: FontWeight.w900),
                        ),
                        Container(
                          decoration: new BoxDecoration(
                              border: Border.all(color: AppColors.green),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              shape: BoxShape.rectangle),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            child: Row(
                              children: [
                                Text(
                                  product.cRating.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.green),
                                ),
                                Icon(
                                  Icons.star,
                                  color: AppColors.green,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      product.description.localized(context),
                      style: TextStyle(
                          color: AppColors.secondaryText,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 50,
                      width: ScreenUtil.screenWidthDp,
                      child: RaisedButton(
                        padding: const EdgeInsets.all(0.0),
                        textColor: Colors.white,
                        color: AppColors.ternaryBackground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        onPressed: () {
                          UI.push(
                              context, Routes.shopAddress(product: product));
                        },
                        child: Text(
                          "${locale.get("BUY NOW") ?? "BUY NOW"}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  int indx = 0;

  Widget images(BuildContext context, ProductPageModel model) {
    return Expanded(
      child: SizedBox(
        height: ScreenUtil.screenHeightDp / 2,
        child: new StaggeredGridView.countBuilder(
          crossAxisCount: 4,
          itemCount: product.images.length < 4 ? product.images.length : 4,
          itemBuilder: (BuildContext context, int index) {
            return productImage(product.images[index], index, model);
          },
          staggeredTileBuilder: (int index) =>
              new StaggeredTile.count(2, index.isEven ? 3 : 2),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        ),
      ),
    );
    // return Row(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: [
    //     Container(
    //         width: ScreenUtil.screenWidthDp / 1.7,
    //         height: ScreenUtil.screenHeightDp / 2.2,
    //         child: productImage(product.images[indx], indx, model)),
    //     Container(
    //       height: ScreenUtil.screenHeightDp / 2,
    //       child: Center(
    //         child: SingleChildScrollView(
    //           child: Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: List.generate(
    //                 product.images.length ?? 0,
    //                 (index) =>
    //                     productImage(product.images[index], index, model),
    //               )),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }

  productImage(String imageUrl, int ind, ProductPageModel model) {
    return Card(
      elevation: 5,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              matchTextDirection: true,
              fit: BoxFit.fill,
            ),
          ),
        ),
        placeholder: (context, url) =>
            Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }
}

class ProductPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  ProductPageModel({NotifierState state, this.api, this.auth, this.context})
      : super(state: state);

  final key = GlobalKey<ScaffoldState>();
}

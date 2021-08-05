import 'package:enna/core/models/address.dart';
import 'package:enna/core/models/product_items.dart';
import 'package:enna/core/services/localization/localization.dart';
import 'package:enna/ui/shared/styles/colors.dart';
import 'package:enna/ui/shared/widgets/app_bar.dart';
import 'package:enna/ui/shared/widgets/drawer.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/ui/shared/routes/route.dart';
import 'package:ui_utils/ui_utils.dart';

class ShopAddressPage extends StatelessWidget {
  final Products product;
  ShopAddressPage({this.product});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return FocusWidget(
      child: BaseWidget<ShopAddressPageModel>(
          initState: (m) => WidgetsBinding.instance
              .addPostFrameCallback((_) => m.getAddressForUser()),
          model: ShopAddressPageModel(
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
                height: ScreenUtil.screenHeightDp,
                // color: Colors.red,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 25, top: 30),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back_ios,
                                color: AppColors.secondaryText),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 30, horizontal: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              productImage(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Text(
                                      product.name.localized(context),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15),
                                    ),
                                  ),
                                  Text(
                                    'QR ${product.price}',
                                    style: TextStyle(
                                        color: Colors.blue[900],
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Center(
                            child: Container(
                          width: ScreenUtil.screenWidthDp / 1.2,
                          height: 0.4,
                          color: Colors.grey,
                        )),
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: Text(
                            "${locale.get("Billing Address") ?? "Billing Address"}",
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Container(
                            height: 200,
                            child: model.fetchingAddress
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : model.addresses != null
                                    ? model.addresses.isNotEmpty
                                        ? horizontalList(context, model)
                                        : Center(
                                            child: Text(
                                              locale.get(
                                                      'You don\'t have addresses, please add one to complete payment') ??
                                                  'You don\'t have addresses, please add one to complete payment',
                                            ),
                                          )
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                            child: Text(
                                          locale.get(
                                                  'Error in getting user addresses, please try again') ??
                                              'Error in getting user addresses, please try again',
                                        )),
                                      ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            // color: Colors.blue,
                            height: ScreenUtil.screenHeightDp / 2.5,
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Container(
                                      width: 257,
                                      height: 43,
                                      child: GestureDetector(
                                          onTap: () {
                                            UI
                                                .push(
                                                    context, Routes.addAddress)
                                                .then((value) {
                                              if (value != null &&
                                                  value is bool) {
                                                model.getAddressForUser();
                                              }
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: AppColors.hintText,
                                                style: BorderStyle.solid,
                                                width: 1.0,
                                              ),
                                              color: Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "${locale.get("Add address") ?? "Add address"}",
                                                style: TextStyle(
                                                  color: AppColors.hintText,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w800,
                                                  letterSpacing: 1,
                                                ),
                                              ),
                                            ),
                                          ))),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  width: 257,
                                  height: 43,
                                  child: RaisedButton(
                                      onPressed: model.fetchingAddress ||
                                              model.selectedAddress == null
                                          ? null
                                          : () {
                                              UI.push(
                                                  context,
                                                  Routes.payment(
                                                      product: product,
                                                      selectedAddress: model
                                                          .selectedAddress));
                                            },
                                      textColor: Colors.white,
                                      color: AppColors.ternaryBackground,
                                      child: Text(
                                        "${locale.get("Continue to payment") ?? "Continue to payment"}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      padding: const EdgeInsets.all(0.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(5.0),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget horizontalList(BuildContext context, ShopAddressPageModel model) {
    return Container(
        width: ScreenUtil.screenWidthDp,
        // height: 100.0,
        child: new ListView.builder(
          shrinkWrap: true,
          itemCount: model.addresses.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: item(context, index, model),
            );
          },
        ));
  }

  Widget item(BuildContext context, int index, ShopAddressPageModel model) {
    var address = model.addresses[index];
    return InkWell(
      onTap: () {
        model.selectedAddress = address;
        model.selection = index;
        model.setState();
      },
      child: Container(
          width: MediaQuery.of(context).size.width / 1.5,
          decoration: new BoxDecoration(
              border: Border.all(
                  color: model.selection == index
                      ? AppColors.ternaryBackground
                      : AppColors.border,
                  width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              shape: BoxShape.rectangle),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address.fullName,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  address.landMark +
                      ":" +
                      address.buildingNumber +
                      " - " +
                      address.zoneNumber +
                      " - " +
                      address.streetNumber +
                      " - ",
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.normal,
                      fontSize: 12),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Ph: ${address.phoneNumber}',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ],
            ),
          )),
    );
  }

  productImage() {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Card(
        elevation: 7,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.ternaryBackground),
            borderRadius: BorderRadius.circular(5),
          ),
          width: 100,
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CachedNetworkImage(
                imageUrl: product.images[0],
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ShopAddressPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  List<AddressModel> addresses;

  bool fetchingAddress = false;

  int selection = -1;
  final key = GlobalKey<ScaffoldState>();

  AddressModel selectedAddress;

  ShopAddressPageModel(
      {NotifierState state, this.api, this.auth, this.context});

  getAddressForUser() async {
    fetchingAddress = true;
    setState();
    addresses = await api.getUserAddresses(context, userId: auth.user.user.id);
    if (addresses != null) {
      fetchingAddress = false;
      setState();
    } else {
      fetchingAddress = false;
      setError();
    }
  }
}

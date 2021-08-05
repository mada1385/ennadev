import 'package:enna/core/models/address.dart';
import 'package:enna/core/models/product_items.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/core/services/localization/localization.dart';
import 'package:enna/ui/home/home_taps/shop/payment_web_view.dart';
import 'package:enna/ui/shared/styles/colors.dart';
import 'package:enna/ui/shared/widgets/app_bar.dart';
import 'package:enna/ui/shared/widgets/buttons/raised_button.dart';
import 'package:enna/ui/shared/widgets/drawer.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ui_utils/ui_utils.dart';

class PaymentPage extends StatelessWidget {
  final AddressModel selectedAddress;
  final Products product;
  PaymentPage({this.selectedAddress, this.product});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return FocusWidget(
      child: BaseWidget<PaymentPageModel>(
          //initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.initializeProfileData()),
          model: PaymentPageModel(
              api: Provider.of<Api>(context),
              auth: Provider.of(context),
              selectedAddress: selectedAddress,
              product: product,
              context: context),
          builder: (context, model, child) {
            return Scaffold(
              appBar: AppBarWidget(
                openDrawer: () => model.key.currentState.openDrawer(),
              ),
              drawer: AppDrawer(
                ctx: context,
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 16),
                      child: Row(
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
                          Text(
                            "${locale.get("Payment") ?? "Payment"}",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              locale.get("Choose payment method") ??
                                  "Choose payment method",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              locale.get(
                                      "You are about to pay ${locale.get("QR") ?? "QR"} ${product.price} ") ??
                                  "You are about to pay ${locale.get("QR") ?? "QR"} ${product.price} ",
                              style:
                                  TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Divider(),
                          ),
                          Container(
                            height: ScreenUtil.screenHeightDp / 2,
                            child: ReactiveForm(
                                formGroup: model.form,
                                child: Column(children: [
                                  ReactiveRadioListTile(
                                    value: 1,
                                    title: Text(
                                      locale.get('Cash on delivery') ??
                                          'Cash on delivery',
                                    ),
                                    formControlName: 'paymentMethod',
                                  ),
                                  ReactiveRadioListTile(
                                    value: 2,
                                    title: Text(
                                      locale.get('Credit Card') ??
                                          'Credit Card',
                                    ),
                                    formControlName: 'paymentMethod',
                                  ),
                                ])),
                          ),
                          Center(
                            child: Container(
                              child: Button(
                                  color: AppColors.ternaryBackground,
                                  text:
                                      "Pay ${locale.get("QR") ?? "QR"} ${product.price}",
                                  onClicked: () {
                                    if (model.form
                                            .control('paymentMethod')
                                            .value ==
                                        1) {
                                      model.payWithCashOnDelivery();
                                    } else {
                                      model.payWithCreditCard();
                                    }
                                  }),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class PaymentPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  final AddressModel selectedAddress;
  final Products product;

  final key = GlobalKey<ScaffoldState>();

  PaymentPageModel(
      {NotifierState state,
      this.api,
      this.auth,
      this.product,
      this.selectedAddress,
      this.context})
      : super(state: state);

  final form = FormGroup({
    'paymentMethod': FormControl(validators: [Validators.required])
  });

  payWithCashOnDelivery() async {
    setBusy();
    bool res = false;
    Map<String, dynamic> body = {
      "address": {"id": selectedAddress.id},
      "paymentMethod": "cash",
      "lines": [
        {
          "product": {"id": product.id},
          "qty": 1
        }
      ]
    };

    print(body);

    res = await api.checkOut(context, body: body);
    res != null ? Navigator.pop(context) : setError();
  }

  payWithCreditCard() async {
    setBusy();
    var res;
    Map<String, dynamic> body = {
      "address": {"id": selectedAddress.id},
      "paymentMethod": "card",
      "lines": [
        {
          "product": {"id": product.id},
          "qty": 1
        }
      ]
    };

    print(body);

    res = await api.checkOutCard(context, body: body);
    res != null
        ? UI.push(
            context,
            PaymentWebViewPage(
              paymentLink: res,
            ))
        : setError();
  }
}

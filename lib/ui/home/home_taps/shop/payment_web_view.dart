import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/ui/shared/routes/route.dart';
import 'package:enna/ui/shared/widgets/app_bar.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

class PaymentWebViewPage extends StatelessWidget {
  final String paymentLink;
  PaymentWebViewPage({this.paymentLink});

  @override
  Widget build(BuildContext context) {
    return FocusWidget(
      child: BaseWidget<PaymentWebViewPageModel>(
          initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) {
                final flutterWebviewPlugin = new FlutterWebviewPlugin();
                flutterWebviewPlugin.onUrlChanged.listen((String url) {
                  if (url.contains("server.overrideeg"))
                    UI.pushReplaceAll(context, Routes.homePage);
                });
                // if (Platform.isAndroid)
                //   WebView.platform = SurfaceAndroidWebView();
              }),
          model: PaymentWebViewPageModel(
              api: Provider.of<Api>(context),
              auth: Provider.of(context),
              context: context),
          builder: (context, model, child) {
            return Scaffold(
              body: WebviewScaffold(
                url: paymentLink,
                appBar: AppBarWidget(
                  openDrawer: () => Navigator.pop(context),
                ),
                withZoom: true,
                withLocalStorage: true,
                hidden: true,
                initialChild: Container(
                  color: Colors.white,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class PaymentWebViewPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  final key = GlobalKey<ScaffoldState>();

  PaymentWebViewPageModel(
      {NotifierState state, this.api, this.auth, this.context})
      : super(state: state);
}

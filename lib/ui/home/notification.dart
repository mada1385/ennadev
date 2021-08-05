import 'package:enna/core/models/notification.dart';
import 'package:enna/ui/shared/widgets/app_bar.dart';
import 'package:enna/ui/shared/widgets/drawer.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:intl/intl.dart';
import 'package:enna/ui/shared/styles/colors.dart';

import '../../core/services/localization/localization.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FocusWidget(
      child: BaseWidget<NotificationPageModel>(
          // initState: (m) => WidgetsBinding.instance
          //     .addPostFrameCallback((_) => m.getUserNotification()),
          model: NotificationPageModel(
              api: Provider.of<Api>(context),
              auth: Provider.of(context),
              context: context),
          builder: (context, model, child) {
            return Scaffold(
              key: model.key,
              drawer: AppDrawer(ctx: context),
              appBar: AppBarWidget(
                openDrawer: () => model.key.currentState.openDrawer(),
                showNotification: false,
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: model.busy
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Center(child: CircularProgressIndicator())],
                      )
                    : model.hasError
                        ? Center(
                            child: Text(
                            locale.get('Error') ?? 'Error',
                          ))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Icon(
                                        Icons.arrow_back_ios,
                                        color: AppColors.secondaryText,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: ScreenUtil.screenWidthDp * .1)
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  locale.get('Notifications') ??
                                      'Notifications',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors.blackText,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              model.busy
                                  ? Expanded(
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : model.hasError
                                      ? Expanded(
                                          child: Center(
                                            child: Text(
                                              locale.get(
                                                      'Error in fetching notifications') ??
                                                  'Error in fetching notifications',
                                            ),
                                          ),
                                        )
                                      : buildItems(context, model),
                            ],
                          ),
              ),
            );
          }),
    );
  }

  buildItems(BuildContext context, NotificationPageModel model) {
    return Expanded(
      child: SingleChildScrollView(
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: model?.notifications?.length,
          itemBuilder: (context, index) {
            var notification = model.notifications[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(150),
                        child: CachedNetworkImage(
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          imageUrl: notification?.sender?.image ?? "",
                          height: 65,
                          fit: BoxFit.scaleDown,
                          errorWidget: (context, url, error) => CircleAvatar(
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
                            width: ScreenUtil.screenWidthDp * 0.4,
                            child: Text(
                              notification?.sender?.name ?? " ",
                              // overflow: TextOverflow.ellipsis,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          ),
                          Container(
                            width: ScreenUtil.screenWidthDp * .4,
                            child: Text(
                              notification?.title ?? " ",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  color: AppColors.secondaryText,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: ScreenUtil.screenWidthDp * .4,
                            child: Text(
                              notification?.description ?? "",
                              // overflow: TextOverflow.ellipsis,
                              // maxLines: 1,
                              style: TextStyle(
                                  color: AppColors.secondaryText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    DateFormat("yyyy-MM-dd")
                        .format(DateTime.tryParse(notification.updatedAt)),
                    style: TextStyle(color: AppColors.secondaryText),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class NotificationPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  final key = GlobalKey<ScaffoldState>();

  List<NotificationModel> notifications;

  NotificationPageModel(
      {NotifierState state, this.api, this.auth, this.context}) {
    getUserNotification();
  }

  getUserNotification() async {
    setBusy();
    notifications =
        await api.getUserNotification(context, userId: auth.user.user.id);

    notifications != null ? setIdle() : setError();
  }
}

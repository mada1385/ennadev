import 'package:enna/ui/shared/routes/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:ui_utils/ui_utils.dart';

import '../../../core/services/localization/localization.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final Function openDrawer;
  final bool showNotification;

  AppBarWidget({this.openDrawer, this.showNotification = true})
      : preferredSize = Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize;
  @override
  _AppBarWidgetState createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return AppBar(
      backgroundColor: Colors.white,
      // title: SvgPicture.asset(
      //   'assets/images/Enna.svg',
      //   height: 40,
      //   width: 120,
      // ),
      title: Image.asset(
        locale.locale.languageCode == "en"
            ? "assets/images/logo_en.png"
            : "assets/images/logo_ar.png",
        width: 80,
        height: 40,
      ),
      centerTitle: true,
      leading: InkWell(
        onTap: widget.openDrawer == null ? () {} : widget.openDrawer,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Icon(
            Icons.clear_all,
            color: Colors.grey,
            size: 40,
          ),
        ),
      ),
      actions: [
        if (widget.showNotification) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: InkWell(
              onTap: () => UI.push(context, Routes.notification),
              child: Icon(
                Icons.notifications,
                color: Colors.grey,
              ),
            ),
          )
        ]
      ],
    );
  }
}

// buildAppBar(BuildContext context, model) {
//   return AppBar(
//     backgroundColor: Colors.white,
//     title: SvgPicture.asset(
//       'assets/images/Enna.svg',
//       height: 35,
//     ),
//     centerTitle: true,
//     leading: InkWell(
//       onTap: () {
//         model.homeScaffoldKey.currentState.openDrawer();
//       },
//       child: Icon(
//         Icons.clear_all,
//         color: Colors.grey,
//         size: 40,
//       ),
//     ),
//     actions: [
//       Padding(
//         padding: const EdgeInsets.only(right: 8.0),
//         child: InkWell(
//           onTap: () {
//             UI.push(context, Routes.notification);
//           },
//           child: Icon(
//             Icons.notifications,
//             color: Colors.grey,
//           ),
//         ),
//       )
//     ],
//   );
// }

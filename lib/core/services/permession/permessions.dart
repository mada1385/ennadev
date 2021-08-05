import 'package:enna/core/services/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class Permessions {
  static Future<PermissionStatus> getLocationPerm(BuildContext context) async {
    final permession = await Permission.location.request();

    if (!permession.isGranted && !permession.isPermanentlyDenied) {
      final locale = AppLocalizations.of(context);

      final action = await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return Dialog(
              child: Container(
                padding: EdgeInsets.all(4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(locale.get("permission denied") ?? "permission denied",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey)),
                    Text(locale.get("permission denied") ?? "permission denied",
                        maxLines: 2, style: TextStyle(fontSize: 12)),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0)),
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(
                            locale.get('cancel') ?? "cancel",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0)),
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text(
                            locale.get('try again') ?? "try again",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          });

      if (action) return await getLocationPerm(context) ?? false;
    }
    return permession;
  }

  // //get cam per shows dialog if rejected!!
  // static Future<bool> getCamPerm(BuildContext context) async {
  //   await PermissionHandler().requestPermissions([PermissionGroup.camera]);
  //   final permissionStatus =
  //       await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);

  //   if (permissionStatus.value != 2) {
  //     final locale = AppLocalizations.of(context);

  //     final action = await UI.dialog(
  //             context: context,
  //             child: Icon(Icons.camera, size: 44),
  //             title: locale.tr("permission denied"),
  //             accept: true,
  //             msg: locale.tr("camera denied"),
  //             cancelMsg: locale.tr('cancel'),
  //             acceptMsg: locale.tr('try again')) ??
  //         false;
  //     if (action) return getCamPerm(context) ?? false;
  //     return false;
  //   }
  //   return true;
  // }

  // static Future<bool> getStoragePerm(BuildContext context) async {
  //   await PermissionHandler().requestPermissions(
  //       [PermissionGroup.storage, PermissionGroup.mediaLibrary]);
  //   final permissionStatus1 = await PermissionHandler()
  //       .checkPermissionStatus(PermissionGroup.storage);
  //   final permissionStatus2 = await PermissionHandler()
  //       .checkPermissionStatus(PermissionGroup.mediaLibrary);

  //   if (permissionStatus2.value != 2 || permissionStatus1.value != 2) {
  //     final locale = AppLocalizations.of(context);

  //     final action = await UI.dialog(
  //             context: context,
  //             child: Icon(Icons.storage, size: 44),
  //             title: locale.tr("permission denied"),
  //             accept: true,
  //             // msg: locale.tr("camera denied"),
  //             cancelMsg: locale.tr('cancel'),
  //             acceptMsg: locale.tr('try again')) ??
  //         false;
  //     if (action) return getStoragePerm(context) ?? false;
  //     return false;
  //   }
  //   return true;
  // }
}

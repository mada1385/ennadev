import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import '../styles/colors.dart';

class ErrorDialog extends StatelessWidget {
  final String title, error, positiveBtnText, negativeBtnText;
  final GestureTapCallback positiveBtnPressed;
  final IconData icon;

  ErrorDialog(
      {this.title,
      @required this.error,
      this.positiveBtnText,
      this.negativeBtnText,
      this.positiveBtnPressed,
      this.icon = Icons.warning});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: <Widget>[
      Container(
        // Bottom rectangular box
        width: double.infinity,
        height: ScreenUtil.screenHeightDp * .2,
        margin:
            EdgeInsets.only(top: 40), // to push the box half way below circle
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.only(
            top: ScreenUtil.screenHeightDp / 11,
            left: 20,
            right: 20), // spacing inside the box
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (title != null) ...[
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(
                  height: 16,
                ),
              ],
              Text(
                error,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.center,
              ),
              positiveBtnPressed == null
                  ? SizedBox()
                  : ButtonBar(
                      buttonMinWidth: 100,
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        TextButton(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              negativeBtnText,
                              style: TextStyle(color: AppColors.primaryColor),
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        TextButton(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              positiveBtnText,
                              style: TextStyle(color: AppColors.primaryColor),
                            ),
                          ),
                          onPressed: positiveBtnPressed,
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
      CircleAvatar(
        // Top Circle with icon
        maxRadius: ScreenUtil.screenWidthDp * .1,
        backgroundColor: AppColors.primaryColor,
        child: Icon(
          icon,
          size: ScreenUtil.screenWidthDp * .1,
          color: Colors.white,
        ),
      ),
    ]);
  }
}

Future errorDialog(BuildContext context, {@required String error}) async {
  print("$error");
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    pageBuilder: (context, animation, secondaryAnimation) {
      return null;
    },
    transitionBuilder: (context, anim1, anim2, child) => Transform.scale(
      scale: anim1.value,
      child: Opacity(
        opacity: anim1.value,
        child: ErrorDialog(
          error: error ?? "",
        ),
      ),
    ),
  );
}


import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class Notify extends StatelessWidget {
  final String title;
  final String body;
  final Map<dynamic, dynamic> data;

  Notify({Key key, this.title, this.body, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final grad = Gradients.secandaryGradient;
    final textColor = Color(0xff5C6470);

    return SafeArea(
        child: GestureDetector(
      onHorizontalDragEnd: (_) => OverlaySupportEntry.of(context).dismiss(),
      child: Card(
        margin: EdgeInsets.all(7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
          ),
          child: ListTile(
            leading: SizedBox(
                width: 35,
                height: 35,
                child: Icon(Icons.notification_important)),
            onTap: () {
              OverlaySupportEntry.of(context).dismiss();
            },
            title: Text(title ?? 'test',
                style: TextStyle(fontSize: 15, color: textColor)),
            subtitle: Text(body ?? 'test',
                style: TextStyle(fontSize: 10, color: textColor)),
            trailing: IconButton(
                color: textColor,
                icon: Icon(Icons.close),
                onPressed: () => OverlaySupportEntry.of(context).dismiss()),
          ),
        ),
      ),
    ));
  }
}

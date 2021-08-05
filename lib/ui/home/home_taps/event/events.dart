import 'package:enna/core/models/event.dart';
import 'package:enna/core/models/user.dart';
import 'package:enna/core/services/localization/localization.dart';
import 'package:enna/core/services/preference/preference.dart';
import 'package:enna/ui/home/home_taps/event/remider_dialog.dart';
import 'package:enna/ui/shared/routes/route.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:intl/intl.dart';
import 'package:enna/ui/shared/styles/colors.dart';

class EventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FocusWidget(
      child: Scaffold(
        body: BaseWidget<EventsPageModel>(
            //initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.initializeProfileData()),
            model: EventsPageModel(
                api: Provider.of<Api>(context),
                auth: Provider.of(context),
                context: context),
            builder: (context, model, child) {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${locale.get("Events") ?? "Events"}",
                            style: TextStyle(
                                color: AppColors.blackText,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          FlatButton.icon(
                              onPressed: () {
                                print(model.events.length);

                                UI.push(context, Routes.addEvent);
                              },
                              icon: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: AppColors.ternaryBackground),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  )),
                              label: Text(
                                "${locale.get("Add event") ?? "Add event"}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.ternaryBackground),
                              ))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 0.8),
                      child: Container(
                        height: 0.2,
                        width: double.infinity,
                        color: Colors.grey,
                      ),
                    ),
                    calendar(context, model, locale),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 0.8),
                      child: Container(
                        height: 0.2,
                        width: double.infinity,
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${locale.get("My Plans") ?? "My Plans"}",
                            style: TextStyle(
                                color: AppColors.blackText,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            DateFormat("yyyy-MM-dd")
                                .format(model?.formattedDate ?? DateTime.now()),
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    model.busy
                        ? Center(child: CircularProgressIndicator())
                        : model.hasError
                            ? Center(
                                child: Text(
                                locale.get('Error') ?? 'Error',
                              ))
                            : model.events.isEmpty
                                ? Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    height: ScreenUtil.screenHeightDp / 7,
                                    width: ScreenUtil.screenHeightDp / 2.0,
                                    child: Card(
                                      elevation: 5,
                                      color: Colors.grey[100],
                                      child: Center(
                                          child: Text(
                                        "${locale.get("No plans on this day") ?? "No plans on this day"}",
                                        style: TextStyle(color: Colors.grey),
                                      )),
                                    ),
                                  )
                                : Container(
                                    height: ScreenUtil.screenHeightDp / 3,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: model?.events?.length ?? 0,
                                        itemBuilder: (ctx, index) =>
                                            buildEventCard(
                                                ctx, model, index, locale)),
                                  )
                  ],
                ),
              );
            }),
      ),
    );
  }

  Widget buildEventCard(BuildContext context, EventsPageModel model, int index,
      AppLocalizations locale) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15)),
            ),
            child: Card(
              elevation: 2,
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                    color: AppColors.ternaryBackground,
                                    borderRadius: BorderRadius.circular(50)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  model.events[index].title,
                                  style: TextStyle(color: Colors.blue[700]),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "${locale.get(model.events[index].repeat) ?? model.events[index].repeat}",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'On',
                                ),
                                buildEventMembers(model, index),
                              ],
                            ),
                            InkWell(
                              onTap: () => showDialog(
                                  context: context,
                                  builder: (ctx) => EventRemiderDialog(
                                      ctx: ctx, event: model.events[index])),
                              child: Icon(
                                Icons.alarm,
                                color: Colors.grey,
                              ),
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
        ));
  }

  Widget buildEventMembers(EventsPageModel model, int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Center(
        child: Container(
          width: ScreenUtil.screenWidthDp * .6,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: model.events[index]?.members?.length ?? 0,
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx, idx) => Padding(
              padding: const EdgeInsets.all(5.0),
              child: CircleAvatar(
                radius: 20,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: CachedNetworkImage(
                    imageUrl: model.events[index].members[idx].image,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget calendar(
      BuildContext context, EventsPageModel model, AppLocalizations locale) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: CalendarCarousel<Event>(
        onDayPressed: (day, _) {
          print("$day");
          model.formattedDate = day;
          model.setState();
          model.getEventsByTeamId();
        },
        weekendTextStyle: TextStyle(
          color: Colors.black,
        ),
        thisMonthDayBorderColor: Colors.grey,
        weekFormat: true,
        markedDatesMap: null,
        isScrollable: false,
        selectedDayTextStyle: TextStyle(),
        height: ScreenUtil.screenHeightDp / 4,
        selectedDateTime: model.formattedDate,
        daysHaveCircularBorder: true,
        weekdayTextStyle: TextStyle(color: AppColors.blackText),
        selectedDayBorderColor: AppColors.ternaryBackground,
        selectedDayButtonColor: AppColors.ternaryBackground,
      ),
    );
  }
}

class EventsPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  Teams team;

  DateTime formattedDate = DateTime.now();

  List<oEvent> events;

  EventsPageModel({NotifierState state, this.api, this.auth, this.context})
      : super(state: state) {
    getTeam();
  }

  getTeam() async {
    setBusy();
    team = Preference.getString(PrefKeys.TEAM_ID) == null
        ? UI.pushReplaceAll(context, Routes.creatOrJoinTeam)
        : await api.getTeamByTeamID(context,
            teamID: Preference.getString(PrefKeys.TEAM_ID));

    if (team != null) {
      await getEventsByTeamId();
    } else {
      setError();
    }
  }

  getEventsByTeamId() async {
    // var date = formattedDate != null
    //     ? formattedDate
    //     : DateFormat('yyyy-MM-dd').format(DateTime.now());

    setBusy();
    events = await api.getEventsByTeamId(context,
        teamId: team.id, eventDate: formattedDate.millisecondsSinceEpoch);
    events != null ? setIdle() : setError();

    Logger().v(events);
  }
}

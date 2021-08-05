import 'package:enna/core/models/user.dart';
import 'package:enna/core/services/localization/localization.dart';
import 'package:enna/core/services/preference/preference.dart';
import 'package:enna/ui/home/reminder_dialog.dart';
import 'package:enna/ui/shared/routes/route.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:social_share/social_share.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:enna/ui/shared/styles/colors.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FocusWidget(
      child: Scaffold(
        body: BaseWidget<HomePageModel>(
            // initState: (m) => WidgetsBinding.instance
            //     .addPostFrameCallback((_) => m.getTeamById()),
            model: HomePageModel(
                api: Provider.of<Api>(context),
                auth: Provider.of(context),
                context: context),
            builder: (context, model, child) {
              return SingleChildScrollView(
                child: model.busy
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                        children: <Widget>[
                          Container(
                            height: ScreenUtil.screenHeightDp / 4,
                            child: GoogleMap(
                              zoomGesturesEnabled: true,
                              liteModeEnabled: false,
                              compassEnabled: true,
                              myLocationEnabled: true,
                              scrollGesturesEnabled: true,
                              indoorViewEnabled: true,
                              mapType: MapType.terrain,
                              initialCameraPosition:
                                  CameraPosition(zoom: 11, target: model.pos),
                              zoomControlsEnabled: false,
                              onMapCreated: (controller) {
                                controller.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                            target: model.pos, zoom: 13)));
                                model.setState();
                              },
                              markers: <Marker>[
                                Marker(
                                  markerId:
                                      MarkerId(model.selectedTeam.season.id),
                                  position: model.pos,
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueAzure),
                                )
                              ].toSet(),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 10),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            locale.get('Share your location') ??
                                                'Share your location',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  SocialShare.shareWhatsapp(
                                                          'https://www.google.com/maps/search/?api=1&query=${model.pos.latitude},${model.pos.longitude}')
                                                      .catchError((_) {
                                                    UI.toast("Error");
                                                  });
                                                },
                                                child: SvgPicture.asset(
                                                    'assets/images/whatsapp.svg'),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  SocialShare.shareOptions(
                                                          'https://www.google.com/maps/search/?api=1&query=${model.pos.latitude},${model.pos.longitude}')
                                                      .catchError((_) {
                                                    UI.toast("Error");
                                                  });
                                                },
                                                child: SvgPicture.asset(
                                                    'assets/images/more.svg'),
                                              ),
                                            ],
                                          ),
                                        ]),
                                  ),
                                  Divider(),
                                  SizedBox(
                                    height: 14,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          locale.get('Current Team : ') ??
                                              'Current Team : ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        model.auth.user.user.teams.isNotEmpty
                                            ? Container(
                                                width: 150,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    border: Border.all(
                                                        color:
                                                            AppColors.border)),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20),
                                                  child: DropdownButton(
                                                    isExpanded: true,
                                                    underline: Container(),
                                                    items: model
                                                        .auth.user.user.teams
                                                        .map((item) {
                                                      return DropdownMenuItem<
                                                              Teams>(
                                                          value: item,
                                                          child: FittedBox(
                                                            fit: BoxFit.contain,
                                                            child: Text(
                                                                "${item.name.localied(context)}"),
                                                          ));
                                                    }).toList(),

                                                    hint: model.selectedTeam ==
                                                            null
                                                        ? Text(
                                                            locale.get(
                                                                    'Team') ??
                                                                'Team',
                                                          )
                                                        : FittedBox(
                                                            fit: BoxFit.contain,
                                                            child: Text(
                                                              "${model.selectedTeam.name.localied(context)}",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                    // style: TextStyle(),
                                                    onChanged: (val) async {
                                                      model.selectedTeam = val;

                                                      await Preference
                                                          .setString(
                                                              PrefKeys.TEAM_ID,
                                                              model.selectedTeam
                                                                  .id);

                                                      print(
                                                          "Selected team : ${model.selectedTeam}");
                                                      model.checkSelectedTeam();
                                                      model.setState();
                                                    },
                                                  ),
                                                ),
                                              )
                                            : Text(
                                                locale.get(
                                                        'You havn\'t joined any teams yet') ??
                                                    'You havn\'t joined any teams yet',
                                              )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  buildItems(context, model),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              );
            }),
      ),
    );
  }

  buildItems(BuildContext context, HomePageModel model) {
    final locale = AppLocalizations.of(context);
    int teamIndex;
    if (model.selectedTeam != null) {
      teamIndex = model.auth.user.user.teams
          .indexWhere((element) => element.id == model?.selectedTeam?.id);
    }
    return SingleChildScrollView(
      child: model.selectedTeam == null
          ? Center(
              child: Text(
                  "${locale.get("You haven't selected any teams") ?? "You haven't selected any teams"}"),
            )
          : teamIndex == -1
              ? Center(
                  child: Text(
                  locale.get('This team has no members') ??
                      'This team has no members',
                ))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:
                        model.auth.user.user.teams[teamIndex].members.length,
                    itemBuilder: (ctx, index) {
                      final member =
                          model.auth.user.user.teams[teamIndex].members[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 1, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: member.image != null
                                      ? Colors.transparent
                                      : AppColors.ternaryBackground,
                                  radius: 20,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: CachedNetworkImage(
                                      imageUrl: member.image,
                                      width: double.infinity,
                                      height: double.infinity,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                              color: Colors.blue[900],
                                              alignment: Alignment.center,
                                              height: 45.0,
                                              width: 45.0,
                                              child: Text(
                                                member.name
                                                    .substring(0, 1)
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              )),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: ScreenUtil.screenWidthDp * .5,
                                  child: Text("${member.name}",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                            member.id != model.auth.user.user.id
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            launch("tel://${member.mobile}");
                                          },
                                          child: Icon(Icons.call,
                                              color: Colors.grey[600])),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: InkWell(
                                          onTap: () {
                                            reminderDialoge(context, member.id,
                                                model.auth.user.user.id);
                                          },
                                          child: Icon(
                                            Icons.alarm,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox()
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  reminderDialoge(BuildContext context, String senderId, String userId) {
    return showDialog(
        context: context,
        builder: (BuildContext ctx) => ReminderDialog(
              senderId: senderId,
              userId: userId,
              ctx: ctx,
            ));
  }
}

class HomePageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  bool reminding = false;

  Teams selectedTeam;

  LatLng pos;

  double lat;
  double lng;

  HomePageModel({NotifierState state, this.api, this.auth, this.context})
      : super(state: state) {
    checkSelectedTeam();
  }

  void checkSelectedTeam() async {
    setBusy();
    selectedTeam = Preference.getString(PrefKeys.TEAM_ID) == null
        ? UI.pushReplaceAll(context, Routes.selectTeam(isInvited: false))
        : await getTeamByTeamID();

    if (selectedTeam != null) {
      lat = double.tryParse(selectedTeam.season.lat) ?? 25.430873;
      lng = double.tryParse(selectedTeam.season.lng) ?? 51.175701;
      pos = new LatLng(lat, lng);
    }
    setState();
  }

  Future<Teams> getTeamByTeamID() async {
    var t = Preference.getString(PrefKeys.TEAM_ID);
    Teams tempTeam;
    tempTeam = await api.getTeamByTeamID(context,
        teamID: Preference.getString(PrefKeys.TEAM_ID));

    if (tempTeam != null) {
      if (tempTeam.season != null) {
        setIdle();
        return tempTeam;
      } else {
        UI.pushReplaceAll(context, Routes.createSeason);
      }
    } else {
      UI.toast("error in getting team");
      setError();
      UI.pushReplaceAll(context, Routes.creatOrJoinTeam);
      return null;
    }
  }
}

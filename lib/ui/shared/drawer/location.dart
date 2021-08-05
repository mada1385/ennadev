import 'package:enna/core/models/user.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/core/services/preference/preference.dart';
import 'package:enna/ui/shared/routes/route.dart';
import 'package:enna/ui/shared/widgets/app_bar.dart';
import 'package:enna/ui/shared/widgets/drawer.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

import '../../../core/services/localization/localization.dart';
import '../styles/colors.dart';

class LocationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FocusWidget(
      child: BaseWidget<LocationPageModel>(
          //initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.initializeProfileData()),
          model: LocationPageModel(
              api: Provider.of<Api>(context),
              auth: Provider.of(context),
              context: context),
          builder: (ctx, model, child) {
            return Scaffold(
              key: model.key,
              appBar: AppBarWidget(
                openDrawer: () => model.key.currentState.openDrawer(),
              ),
              drawer: AppDrawer(ctx: context),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 30),
                      child: Row(
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
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 4,
                          ),
                          Text(
                            locale.get('Location') ?? 'Location',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        width: double.infinity,
                        height: ScreenUtil.screenHeightDp / 2,
                        child: model.position != null
                            ? GoogleMap(
                                zoomGesturesEnabled: true,
                                liteModeEnabled: false,
                                compassEnabled: true,
                                myLocationEnabled: true,
                                scrollGesturesEnabled: true,
                                mapType: MapType.terrain,
                                onTap: (newPosition) {
                                  print(
                                      "new position: ${newPosition.latitude} - ${newPosition.longitude}");
                                  model.mapOnTap(newPosition);
                                  model.selectedLocation = newPosition;
                                },
                                initialCameraPosition: CameraPosition(
                                    zoom: 11,
                                    target: LatLng(model.position.latitude,
                                        model.position.longitude)),
                                zoomControlsEnabled: false,
                                onMapCreated: (GoogleMapController controller) {
                                  model.mapsController = controller;
                                },
                                markers: <Marker>[
                                  Marker(
                                      markerId:
                                          // MarkerId(model.auth.user.user.id),
                                          MarkerId("markerId"),
                                      position: LatLng(model.position.latitude,
                                          model.position.longitude),
                                      icon:
                                          BitmapDescriptor.defaultMarkerWithHue(
                                              BitmapDescriptor.hueAzure),
                                      draggable: true,
                                      zIndex: 10)
                                ].toSet(),
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              )),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            locale.get('Your Location') ?? 'Your Location',
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ),
                          textFormField(
                              null,
                              model.currentAddress != null
                                  ? model.currentAddress
                                  : "Getting location",
                              TextInputType.name),
                          // Center(
                          //   child: Padding(
                          //     padding: const EdgeInsets.only(top: 10.0),
                          //     child: Container(
                          //       width: MediaQuery.of(context).size.width / 2,
                          //       height: 50.0,
                          //       child: GestureDetector(
                          //         onTap: () {
                          //           model.changeLocation();
                          //         },
                          //         child: Container(
                          //           decoration: BoxDecoration(
                          //             border: Border.all(
                          //               color: Colors.blue[900],
                          //               style: BorderStyle.solid,
                          //               width: 1.0,
                          //             ),
                          //             color: Colors.transparent,
                          //             borderRadius: BorderRadius.circular(5.0),
                          //           ),
                          //           child: Center(
                          //             child: Text(
                          //               locale.get('Change location') ??
                          //                   'Change location',
                          //               style: TextStyle(
                          //                 color: Colors.blue[900],
                          //                 fontSize: 20,
                          //                 fontWeight: FontWeight.w800,
                          //                 letterSpacing: 1,
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          Center(
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width / 2,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                      color: model.selectedLocation == null
                                          ? Colors.grey
                                          : AppColors.primaryColor,
                                      style: BorderStyle.solid,
                                      width: 2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: Text(
                                  locale.get('Change location') ??
                                      'Change location',
                                  style: TextStyle(
                                    color: model.selectedLocation == null
                                        ? Colors.grey
                                        : AppColors.primaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1,
                                  ),
                                ),
                                onPressed: model.selectedLocation == null
                                    ? null
                                    : () {
                                        model.changeLocation();
                                      },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget textFormField(controller, hint, keyboardType) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 10),
      child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: new InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            //labelText: "Enter name of organisation or company",
            labelStyle: TextStyle(color: Colors.grey),
            focusedBorder: new OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.blue[700]),
            ),
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(5.0),
              borderSide: new BorderSide(color: Colors.black),
            ),
          )),
    );
  }
}

class LocationPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  LatLng selectedLocation;

  final geolocator =
      Geolocator.getCurrentPosition(forceAndroidLocationManager: true);
  final key = GlobalKey<ScaffoldState>();

  Teams team;
  Position position;
  GoogleMapController mapsController;

  LocationPageModel({NotifierState state, this.api, this.auth, this.context})
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
      position = Position(
          latitude: double.tryParse(team.season.lat),
          longitude: double.tryParse(team.season.lng));
      getAddressFromLatLng();
      setIdle();
    } else {
      setError();
    }
  }

  String currentAddress;

  getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          double.tryParse(team.season.lat), double.tryParse(team.season.lng));

      Placemark place = p[0];
      currentAddress = "${place.locality}, ${place.country}";

      setState();
    } catch (e) {
      print(e);
    }
  }

  mapOnTap(LatLng newPosition) {
    position = Position(
        accuracy: null,
        altitude: null,
        floor: null,
        heading: null,
        isMocked: null,
        speed: null,
        speedAccuracy: null,
        timestamp: null,
        latitude: newPosition.latitude,
        longitude: newPosition.longitude);
    mapsController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 13)));
    setState();
  }

  void changeLocation() async {
    setBusy();
    var res = await api.updateSeason(context, seasonId: team.season.id, body: {
      "lat": selectedLocation.latitude,
      "lng": selectedLocation.latitude
    });
    if (res != null) {
      UI.toast("Location successfully updated");
      Navigator.of(context).pop();
    } else {
      setError();
    }
    setIdle();
    //#TODO: save location
    UI.push(context, Routes.homePage, replace: true);
  }
}

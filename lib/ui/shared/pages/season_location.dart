import 'package:enna/core/models/user.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/core/services/localization/localization.dart';
import 'package:enna/core/services/permession/permessions.dart';
import 'package:enna/ui/shared/routes/route.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ui_utils/ui_utils.dart';

class SeasonLocationPage extends StatelessWidget {
  final Map<String, dynamic> body;
  SeasonLocationPage({this.body});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return BaseWidget<SeasonLocationPageModel>(
      model: SeasonLocationPageModel(
          api: Provider.of<Api>(context),
          auth: Provider.of(context),
          context: context,
          body: body),
      builder: (context, model, child) => Scaffold(
          body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                //Map Container
                Container(
                    height: 400,
                    width: double.infinity,
                    // color: Colors.green,
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
                                  "current position: ${model.position.latitude} - ${model.position.longitude}");
                              print(
                                  "new position: ${newPosition.latitude} - ${newPosition.longitude}");
                              model.mapOnTap(newPosition);

                              print(
                                  "current position: ${model.position.latitude} - ${model.position.longitude}");
                              print(
                                  "new position: ${newPosition.latitude} - ${newPosition.longitude}");
                            },
                            initialCameraPosition: CameraPosition(
                                zoom: 13,
                                target: LatLng(model.position.latitude,
                                    model.position.longitude)),
                            zoomControlsEnabled: false,
                            onMapCreated: (GoogleMapController controller) {
                              model.mapsController = controller;
                              model.mapsController.animateCamera(
                                  CameraUpdate.newCameraPosition(CameraPosition(
                                      target: LatLng(model.position.latitude,
                                          model.position.longitude),
                                      zoom: 13)));
                              model.setState();
                            },
                            markers: <Marker>[
                              Marker(
                                markerId: MarkerId(model.auth.user.user.id),
                                position: LatLng(model.position.latitude,
                                    model.position.longitude),
                                icon: BitmapDescriptor.defaultMarkerWithHue(
                                    BitmapDescriptor.hueAzure),
                              )
                            ].toSet(),
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          )),
                Column(
                  children: [
                    //Search Text Field
                    SizedBox(
                      height: ScreenUtil.screenHeightDp / 2.15,
                    ),
                    //Choose Current location Button
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: ScreenUtil.screenHeightDp / 2.5,
                        height: 50,
                        child: RaisedButton(
                            onPressed: () {
                              model.position = model.currentLocation;
                              model.mapsController.animateCamera(
                                  CameraUpdate.newCameraPosition(CameraPosition(
                                      target: LatLng(model.position.latitude,
                                          model.position.longitude),
                                      zoom: 13)));
                              model.setState();
                            },
                            textColor: Colors.white,
                            color: Colors.blue[900],
                            child: Text(
                              locale.get('Choose Current location') ??
                                  'Choose Current location',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            padding: const EdgeInsets.all(0.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(5.0),
                            )),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            //Two Text
            Padding(
              padding: const EdgeInsets.only(top: 50.0, right: 50, left: 50),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "${locale.get("Select your location from map or choose current location to find services near you") ?? "Select your location from map or choose current location to find services near you"}: ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, right: 50, left: 50, bottom: 30),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "${locale.get("Location will be fixed for a year. You can change it later from your profile.") ?? "Location will be fixed for a year. You can change it later from your profile."}: ",
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ),
            ),
            //Set Location Button
            model.busy
                ? Center(child: CircularProgressIndicator())
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: ScreenUtil.screenHeightDp / 2.5,
                      height: 50,
                      child: RaisedButton(
                          onPressed: () {
                            model.position != null
                                ? model.createSeason()
                                : UI.toast(locale.get(
                                    "please Select location" ??
                                        "please Select location"));
                          },
                          textColor: Colors.white,
                          color: model.position != null
                              ? Colors.blue[900]
                              : Colors.grey,
                          child: Text(
                            "${locale.get("Set location") ?? "Set location"}",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          padding: const EdgeInsets.all(0.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                          )),
                    ),
                  ),
          ],
        ),
      )),
    );
  }
}

class SeasonLocationPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  final Map<String, dynamic> body;

  // final location = Location();
  Position currentLocation;

  Position position;

  GoogleMapController mapsController;

  SeasonLocationPageModel(
      {NotifierState state, this.api, this.auth, this.context, this.body})
      : super(state: state) {
    checkLocation();
  }

  checkLocation() async {
    final res = await Permessions.getLocationPerm(context);

    if (res.isGranted) {
      // currentLocation = await location.getLocation();
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (position != null &&
          position.latitude != null &&
          position.longitude != null) {
        currentLocation = position;
        setState();
      } else {
        Position temp = Position(
          timestamp: null,
          accuracy: null,
          altitude: null,
          floor: null,
          speed: null,
          heading: null,
          speedAccuracy: null,
          latitude: 25.430873,
          longitude: 51.175701,
        );
        position = temp;
      }
    }
  }

  mapOnTap(LatLng newPosition) {
    position = Position(
      timestamp: null,
      accuracy: null,
      altitude: null,
      floor: null,
      speed: null,
      heading: null,
      speedAccuracy: null,
      latitude: newPosition.latitude,
      longitude: newPosition.longitude,
    );

    mapsController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 13)));
    setState();
  }

  createSeason() async {
    Season res;
    setBusy();
    body['lat'] = position.latitude.toString();
    body['lng'] = position.longitude.toString();

    res = await api.createSeason(context, body: body);
    if (res != null) {
      UI.pushReplaceAll(
        context,
        Routes.homePage,
      );
    } else {
      // UI.toast("Error");
      setError();
    }
  }
}

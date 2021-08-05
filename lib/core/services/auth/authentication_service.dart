import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:enna/core/models/user.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/ui/shared/routes/route.dart';
import 'package:ui_utils/ui_utils.dart';

import '../preference/preference.dart';

class AuthenticationService {
  final Api api;

  User _user;
  User get user => _user;

  AuthenticationService({this.api}) {
    // loadUser;
  }

  signIn(BuildContext context, {Map<String, dynamic> body}) async {
    try {
      _user = await api.signIn(context, body: body);
      if (_user != null) {
        saveUser(user: _user);
        Logger().i(_user.toJson());

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> signUp(BuildContext context, {Map<String, dynamic> body}) async {
    try {
      _user = await api.signUp(context, body: body);
      if (_user != null) {
        saveUser(user: _user);
        Logger().i(_user.toJson());

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateUserProfile(BuildContext context,
      {@required Map<String, dynamic> body}) async {
    UserInfo tempUser;

    tempUser =
        await api.updateUserProfile(context, userId: _user.user.id, body: body);

    if (tempUser != null) {
      _user.user.name = tempUser.name;
      _user.user.email = tempUser.email;
      _user.user.mobile = tempUser.mobile;
      saveUser(user: _user);
      Logger().i(_user.toJson());

      return true;
    } else {
      return false;
    }
  }

  /*
   *check if user is authenticated 
   */
  bool get userLoged => Preference.getBool(PrefKeys.userLogged) ?? false;

  saveUser({User user}) {
    Preference.setBool(PrefKeys.userLogged, true);
    Preference.setString(PrefKeys.userData, json.encode(user.toJson()));
    // _user = user;
  }

  setUser({User user}) {
    _user = user;
  }

  saveUserToken({String token}) {
    Preference.setString(PrefKeys.token, token);
  }

  /*
   * load the user info from shared prefrence if existed to be used in the service   
   */
  Future<void> get loadUser async {
    if (userLoged) {
      _user =
          User.fromJson(json.decode(Preference.getString(PrefKeys.userData)));
      Logger().i(_user.toJson());
      print('\n\n\n');
    }
  }

  Future<void> get signOut async {
    await Preference.remove(PrefKeys.userData);
    await Preference.remove(PrefKeys.USER);
    await Preference.remove(PrefKeys.userLogged);
    await Preference.remove(PrefKeys.fcmToken);
    await Preference.remove(PrefKeys.token);
    await Preference.remove(PrefKeys.TEAM_ID);

    _user = null;
  }

  static handleAuthExpired({@required BuildContext context}) async {
    if (context != null) {
      try {
        await Preference.clear();

        UI.pushReplaceAll(context, Routes.splash);

        Logger().i('🦄session destroyed🦄');
      } catch (e) {
        Logger().v('🦄error while destroying session $e🦄');
      }
    }
  }

  sendFCMToken(BuildContext context, {String fcm}) async {
    String res = await api.sendFcmToken(context, fcm, user.user.id);
    if (res != null) {
      _user.user.fcmToken = res;
      saveUser(user: _user);
      Logger().i(user.toJson());
      await Preference.setString(PrefKeys.fcmToken, user.user.fcmToken);
      return true;
    } else {
      return false;
    }
  }
}

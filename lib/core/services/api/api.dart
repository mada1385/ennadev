import 'package:enna/core/models/user.dart';
import 'package:flutter/material.dart';

import '../preference/preference.dart';

class RequestType {
  static const String Get = 'get';
  static const String Post = 'post';
  static const String Put = 'put';
  static const String Delete = 'delete';
}

class Header {
  static Map<String, dynamic> get clientAuth {
    return {
      'Authorization': 'Bearer Y29tLm92ZXJyaWRlZWcud2Viem9uZS5hcHBzLmVubmE='
    };
  }

  static Map<String, dynamic> get userAuth =>
      {'Authorization': 'Bearer ${Preference.getString(PrefKeys.token)}'};
}

class EndPoint {
  static const String REGISTER = 'auth/register';
  static const String REFRESH_TOKEN = 'auth/refreshToken';
  static const String UPLOAD_IMAGE = 'File/upload';
  static const String LOGIN = 'auth/login';
  static const String TOKEN = 'auth/token';
  static const String CHANGE_PASSWORD = 'auth/changePassword';
  static const String SEASON = 'Season';
  static const String FCMTOKEN = 'User/updateFcm/';
  static const String UPDATE_USER_PROFILE = 'User/';
  static const String POST = 'post';
  static const String COMMENT = 'comment';
  static const String REPLY = 'reply';
  static const String event = 'Event/byTeam';
  static const String CREATE_EVENT = 'Event';
  static const String LAST_CASH = 'Cash/last';
  static const String LAST_EXPENSES = 'Expense/last';
  static const String ALL_EXPENSES = 'Expense/all';
  static const String ADD_CASH = 'Cash';
  static const String ALL_CASH = 'Cash/all';
  static const String ADD_EXPENSE = 'Expense';
  static const String CREATE_SEASON = 'Season/create';
  static const String JOIN_TEAM = 'Team/joinTeam';
  static const String CREATE_TEAM = 'Team/createTeam';
  static const String PRODUCT_CATEGORY = 'ProductCategory/all';
  static const String USER_PRODUCTS = 'Product/user';
  static const String COMPANY_PRODUCTS = 'Product/business';
  static const String SEND_REMINDER = 'Notification/reminder';
  static const String EXPENSE_GROUP = 'ExpenseGroup/all';
  static const String USER_CONTACTS = 'contact/all';
  static const String COMPANY_CONTACTS = 'contact/business';
  static const String INVITE_TEAM = 'Team/invite';
  static const String EXIT_TEAM = 'Team/exitTeam/';
  static const String CONTACT_CATEGORIES = 'ContactCategory/all';
  static const String ADD_USER_CONTACT = 'contact/add';
  static const String USER_NOTIFICATION = 'Notification/';
  static const String USER_PRODUCT_CATEGORY = 'ProductCategory/all/user';
  static const String BUSINESS_PRODUCT_CATEGORY =
      'ProductCategory/all/business';
  static const String GET_USER_ADDRESS = 'Address/byUser';
  static const String GET_TEAM_BALANCE = 'Money/balance';
  static const String UPLOAD_MULTI_FILES = 'File/UploadMultiple';
  static const String UPLOAD_PRODUCT = 'Product';
  static const String ORDER_CHECK_OUT = 'order/checkout';
  static const String ADD_ADDRESS = 'Address';
  static const String GET_USER_ORDERS = 'order/my';

  static const String GET_TEAM_BY_ID = 'Team/';
  static const String GET_USER_BY_ID = 'User/mobile/';
  static const String REMIND = 'Event/notify';
}

abstract class Api {
  // Future<LoginResponse> login({String username, String password});

  // Future<User> getUser(int userId);

  // Future<List<Post>> getPostsForUser(int userId);

  // Future<List<Comment>> getCommentsForPost(int postId);

  Future<User> signIn(BuildContext context, {Map<String, dynamic> body});
  Future<User> signUp(BuildContext context, {Map<String, dynamic> body});

  sendFcmToken(BuildContext context, String fcm, String id);

  updateUserProfile(BuildContext context,
      {String userId, Map<String, dynamic> body});

  getUserByID(BuildContext context, {String userId});

  // getUserByID(BuildContext context, {String userId}) {}
}

import 'package:enna/core/models/address.dart';
import 'package:enna/core/models/all_cash_model.dart';
import 'package:enna/core/models/all_expenses_model.dart';
import 'package:enna/core/models/balance.dart';
import 'package:enna/core/models/category.dart';
import 'package:enna/core/models/contacts.dart';
import 'package:enna/core/models/event.dart';
import 'package:enna/core/models/last_cash_transaction.dart';
import 'package:enna/core/models/last_expense_transaction.dart';
import 'package:enna/core/models/my_orders.dart';
import 'package:enna/core/models/notification.dart';
import 'package:enna/core/models/product_items.dart';
import 'package:enna/core/models/products_with_items.dart';
import 'package:enna/core/models/uploaded_file_model.dart';
import 'package:enna/core/models/user.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/ui/shared/routes/route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../preference/preference.dart';
import 'api.dart';
import 'dart:convert';
import 'package:ui_utils/ui_utils.dart';

class HttpApi implements Api {
  // String baseUrl = 'http://192.168.1.15:3052/api/';
  // String baseUrl = 'http://server.overrideeg.net:3052/api/';

  Future<dynamic> request(String endPoint,
      {body,
      String baseUrl = 'http://169.50.226.4:3052/api/',
      // String baseUrl = 'http://192.168.1.5:3052/api/',
      Function onSendProgress,
      BuildContext context,
      Map<String, dynamic> headers,
      String type = RequestType.Get,
      Map<String, dynamic> queryParameters,
      String contentType = Headers.jsonContentType,
      bool retry = false,
      ResponseType responseType = ResponseType.json}) async {
    Response response;

    final dio = Dio(BaseOptions(connectTimeout: 60000, receiveTimeout: 60000));
    final options = Options(
        headers: headers,
        contentType: Headers.jsonContentType,
        responseType: responseType);

    if (onSendProgress == null) {
      onSendProgress = (int sent, int total) {
        print('$endPoint\n sent: $sent total: $total\n');
      };
    }
    if (body == null) body = {};
    Logger().i('>> request $type $baseUrl$endPoint $headers');

    try {
      switch (type) {
        case RequestType.Get:
          {
            response = await dio.get(baseUrl + endPoint,
                queryParameters: queryParameters, options: options);
          }
          break;
        case RequestType.Post:
          {
            response = await dio.post(baseUrl + endPoint,
                queryParameters: queryParameters,
                onSendProgress: onSendProgress,
                data: body,
                options: options);
          }
          break;
        case RequestType.Put:
          {
            response = await dio.put(baseUrl + endPoint,
                queryParameters: queryParameters, data: body, options: options);
          }
          break;
        case RequestType.Delete:
          {
            response = await dio.delete(baseUrl + endPoint,
                queryParameters: queryParameters, data: body, options: options);
          }
          break;
        default:
          break;
      }

      Logger().w(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // print('$type $endPoint\n$headers\nstatusCode:${response.statusCode}\n');
        /// 🦄map of string dynamic...
        return response.data;
      } else {
        Logger().e('🌐🌐ERROR in http $type for $baseUrl:🌐🌐\n' +
            '${response.statusCode}: ${response.statusMessage} ${response.data}');

        await checkSessionExpired(context: context, response: response);
      }
    } on DioError catch (e) {
      Logger().e('🌐🌐DIO ERROR in http $type for $baseUrl:🌐🌐\n' +
          '${e.response.statusCode}: ${e.response.statusMessage} ${e.response.data}\n' +
          e.toString());
      UI.toast(e.response.data['message']);

      if (e.response.statusCode == 401 && !retry && context != null) {
        // sending Refresh token;
        Logger().w('Try to send refresh token');
        if (await refreshToken(context)) {
          return await request(endPoint,
              body: body,
              queryParameters: queryParameters,
              headers: Header.userAuth,
              context: context,
              type: type,
              contentType: contentType,
              responseType: responseType,
              retry: true);
        }
      } else if (e.response.statusCode == 401 && retry && context != null) {
        Logger().w("Checking session expired");
        await checkSessionExpired(context: context, response: e.response);
      }
    }
  }

  checkSessionExpired({Response response, BuildContext context}) async {
    if (context != null &&
        (response.statusCode == 401 || response.statusCode == 500)) {
      final expiredMsg = response.data['message'];
      final authExpired = expiredMsg != null && expiredMsg == 'Unauthorized';

      if (authExpired) {
        await AuthenticationService.handleAuthExpired(context: context);
      }
    }
  }

  // Future<bool> refreshToken(BuildContext context) async {
  //   String email = Provider.of<AuthenticationService>(context, listen: false)
  //       .user
  //       .user
  //       .email;

  //   String oldToken =
  //       Provider.of<AuthenticationService>(context, listen: false).user.token;

  //   final body = {"oldtoken": oldToken, "email": email};
  //   print(body);
  //   var tokenResponse;
  //   tokenResponse = await request(EndPoint.REFRESH_TOKEN,
  //       type: RequestType.Put,
  //       body: body,
  //       headers: Header.clientAuth,
  //       context: context);

  //   print(tokenResponse);

  //   User user;

  //   if (tokenResponse != null && tokenResponse['token'] != null) {
  //     user = User.fromJson(tokenResponse);

  //     User oldUser =
  //         Provider.of<AuthenticationService>(context, listen: false).user;

  //     oldUser.token = user.token;
  //     Provider.of<AuthenticationService>(context, listen: false)
  //         .saveUser(user: oldUser);
  //   }

  //   final token = tokenResponse["token"];

  //   final tokenRefreshed = token != null;

  //   if (tokenRefreshed) {
  //     await Preference.setString(PrefKeys.token, token);
  //   }
  //   return tokenRefreshed;
  // }

  Future<bool> refreshToken(BuildContext context) async {
    // String oldToken =
    //     Provider.of<AuthenticationService>(context, listen: false).user.token;
    if (Preference.getString(PrefKeys.userData) != null) {
      var res =
          User.fromJson(jsonDecode(Preference.getString(PrefKeys.userData)));

      // String oldToken = res.token;
      String oldToken = Preference.getString(PrefKeys.token);

      final body = {"oldtoken": oldToken, "email": res.user.email};
      print(body);
      var tokenResponse;
      tokenResponse = await request(EndPoint.REFRESH_TOKEN,
          type: RequestType.Put,
          body: body,
          headers: Header.clientAuth,
          context: context);

      if (tokenResponse != null) {
        print("New token : ${tokenResponse["token"]}");
        User user;
        final token = tokenResponse["token"];

        if (tokenResponse != null && tokenResponse['token'] != null) {
          user = User.fromJson(tokenResponse);
          user.token = token;
          Provider.of<AuthenticationService>(context, listen: false)
              .saveUser(user: user);
        }

        final tokenRefreshed = token != null;

        if (tokenRefreshed) {
          await Preference.setString(PrefKeys.token, token);
          print("token saved");
        }
        return tokenRefreshed;
      } else {
        UI.toast("Error in token");
      }
    } else {
      await Preference.clear();
      UI.pushReplaceAll(context, Routes.signIn);
    }
  }

  @override
  Future<User> signIn(BuildContext context, {Map<String, dynamic> body}) async {
    User user;
    final res = await request(EndPoint.LOGIN,
        context: context,
        headers: Header.clientAuth,
        type: RequestType.Post,
        body: body);

    if (res != null && res['user'] != null) {
      user = User.fromJson(res);
      if (user != null) {
        final token = user.token;

        if (token == null) {
          return null;
        }

        await Preference.setString(PrefKeys.token, token);
        return user;
      }
    }
    return null;
  }

  @override
  Future<User> signUp(BuildContext context, {Map<String, dynamic> body}) async {
    User user;
    final res = await request(EndPoint.REGISTER,
        context: context,
        headers: Header.clientAuth,
        type: RequestType.Post,
        body: body);

    if (res != null && res['user'] != null) {
      user = User.fromJson(res);
      if (user != null) {
        final token = user.token;

        if (token == null) {
          return null;
        }

        await Preference.setString(PrefKeys.token, token);
        return user;
      }
    }
    return null;
  }

  @override
  updateUserProfile(BuildContext context,
      {String userId, Map<String, dynamic> body}) async {
    final res = await request(EndPoint.UPDATE_USER_PROFILE + "$userId",
        context: context,
        headers: Header.userAuth,
        body: body,
        type: RequestType.Put);

    return res != null ? UserInfo.fromJson(res) : null;
  }

  getLastExpenseByTeamID(BuildContext context, {String teamId}) async {
    final res = await request(EndPoint.LAST_EXPENSES,
        context: context,
        headers: Header.userAuth,
        queryParameters: {"teamId": teamId});

    return res != null
        ? res
            .map<LastExpensesTransaction>(
                (item) => LastExpensesTransaction.fromJson(item))
            .toList()
        : null;
  }

  getLastCashByTeamID(BuildContext context, {String teamId}) async {
    final res = await request(EndPoint.LAST_CASH,
        context: context,
        headers: Header.userAuth,
        queryParameters: {"teamId": teamId});

    return res != null
        ? res
            .map<LastCashTransaction>(
                (item) => LastCashTransaction.fromJson(item))
            .toList()
        : null;
  }

  Future<List<oEvent>> getEventsByTeamId(BuildContext context,
      {String teamId, int eventDate}) async {
    final res = await request(EndPoint.event,
        headers: Header.userAuth,
        context: context,
        queryParameters: {"teamId": teamId, "date": eventDate});

    return res != null
        ? res.map<oEvent>((item) => oEvent.fromJson(item)).toList()
        : null;
  }

  Future<AllExpensesModel> getAllExpenses(
      {BuildContext context, Map<String, dynamic> param}) async {
    final res = await request(EndPoint.ALL_EXPENSES,
        context: context, headers: Header.userAuth, queryParameters: param);

    return res != null ? AllExpensesModel.fromJson(res) : null;
  }

  createSeason(BuildContext context, {Map<String, dynamic> body}) async {
    final res = await request(EndPoint.CREATE_SEASON,
        context: context,
        headers: Header.userAuth,
        body: body,
        type: RequestType.Post);

    return res != null && res['id'] != null ? Season.fromJson(res) : null;
  }

  joinTeam(BuildContext context, {String teamId}) async {
    final res = await request(
      EndPoint.JOIN_TEAM + "/$teamId",
      type: RequestType.Post,
      context: context,
      headers: Header.userAuth,
    );

    return res != null ? true : false;
  }

  createTeam(BuildContext context, {Map<String, dynamic> body}) async {
    final res = await request(EndPoint.CREATE_TEAM,
        context: context,
        type: RequestType.Post,
        headers: Header.userAuth,
        body: body);

    return res != null && res['id'] != null ? Teams.fromJson(res) : null;
  }

  getCategories(BuildContext context) async {
    final res = await request(EndPoint.PRODUCT_CATEGORY,
        context: context, headers: Header.userAuth);

    return res != null
        ? res.map<Category>((item) => Category.fromJson(item)).toList()
        : null;
  }

  getUserProducts({Map<String, dynamic> param}) async {
    final res = await request(EndPoint.USER_PRODUCTS,
        headers: Header.userAuth, queryParameters: param);

    return res != null
        ? res.map<Products>((item) => Products.fromJson(item)).toList()
        : null;
  }

  getCompanyProducts(BuildContext context, {Map<String, dynamic> param}) async {
    final res = await request(EndPoint.COMPANY_PRODUCTS,
        context: context, headers: Header.userAuth, queryParameters: param);

    return res != null
        ? res.map<Products>((item) => Products.fromJson(item)).toList()
        : null;
  }

  sendReminder(BuildContext context, {Map<String, dynamic> body}) async {
    final res = await request(EndPoint.SEND_REMINDER,
        context: context,
        type: RequestType.Post,
        headers: Header.userAuth,
        body: body);

    return res != null && res['id'] != null ? true : false;
  }

  uploadImage(BuildContext context, PickedFile choosedImage) async {
    final res = await request(
      EndPoint.UPLOAD_IMAGE,
      type: RequestType.Post,
      context: context,
      // contentType:,
      headers: Header.clientAuth,
      body: FormData.fromMap(
          {"file": await MultipartFile.fromFile(choosedImage.path)}),
    );

    return res != null && res['path'] != null ? res['path'] : null;
  }

  @override
  sendFcmToken(BuildContext context, String fcm, String id) async {
    final response = await request(EndPoint.FCMTOKEN + id,
        headers: Header.userAuth,
        type: RequestType.Put,
        context: context,
        body: {"fcmToken": fcm});

    return response != null && response['fcm'] != null ? response['fcm'] : null;
  }

  addCash(BuildContext context, {Map<String, dynamic> body}) async {
    final res = await request(EndPoint.ADD_CASH,
        context: context,
        type: RequestType.Post,
        headers: Header.userAuth,
        body: body);

    return res != null ? true : false;
  }

  getAllCash({BuildContext context, Map<String, dynamic> param}) async {
    final res = await request(EndPoint.ALL_CASH,
        context: context, headers: Header.userAuth, queryParameters: param);

    return res != null ? AllCash.fromJson(res) : null;
  }

  addExpense(BuildContext context, {Map<String, dynamic> body}) async {
    final res = await request(EndPoint.ADD_EXPENSE,
        context: context,
        type: RequestType.Post,
        headers: Header.userAuth,
        body: body);

    return res != null ? true : false;
  }

  getExpenseGroup(BuildContext context) async {
    final res = await request(EndPoint.EXPENSE_GROUP,
        context: context, headers: Header.userAuth);

    return res != null
        ? res.map<Category>((item) => Category.fromJson(item)).toList()
        : null;
  }

  createEvent(BuildContext context, {Map<String, dynamic> body}) async {
    final res = await request(EndPoint.CREATE_EVENT,
        context: context,
        headers: Header.userAuth,
        body: body,
        type: RequestType.Post);

    return res != null ? true : false;
  }

  getUSerContacts(BuildContext context, {Map<String, dynamic> param}) async {
    final res = await request(EndPoint.USER_CONTACTS,
        context: context, headers: Header.userAuth, queryParameters: param);

    return res != null
        ? res
            .map<ContactsCateoryModel>(
                (item) => ContactsCateoryModel.fromJson(item))
            .toList()
        : null;
  }

  getCompanyContacts(BuildContext context, {Map<String, dynamic> param}) async {
    final res = await request(EndPoint.COMPANY_CONTACTS,
        context: context, headers: Header.userAuth, queryParameters: param);

    return res != null
        ? res
            .map<ContactsCateoryModel>(
                (item) => ContactsCateoryModel.fromJson(item))
            .toList()
        : null;
  }

  exitTeam(BuildContext context, {String teamId}) async {
    final res = await request(EndPoint.EXIT_TEAM + "$teamId",
        context: context, headers: Header.userAuth, type: RequestType.Post);

    return res != null && res['id'] != null ? true : false;
  }

  addMember(BuildContext context,
      {Map<String, dynamic> body, Map<String, dynamic> param}) async {
    final res = await request(EndPoint.INVITE_TEAM,
        headers: Header.userAuth,
        type: RequestType.Post,
        context: context,
        body: body,
        queryParameters: param);

    return res != null ? true : false;
  }

  getContactCategories(BuildContext context) async {
    final res = await request(EndPoint.CONTACT_CATEGORIES,
        context: context, headers: Header.userAuth, type: RequestType.Get);

    return res != null
        ? res
            .map<ContactsCateoryModel>(
                (item) => ContactsCateoryModel.fromJson(item))
            .toList()
        : null;
  }

  addContact(BuildContext context, {Map<String, dynamic> body}) async {
    final res = await request(EndPoint.ADD_USER_CONTACT,
        context: context,
        headers: Header.userAuth,
        type: RequestType.Post,
        body: body);

    return res != null ? true : false;
  }

  getUserNotification(BuildContext context, {String userId}) async {
    final res = await request(EndPoint.USER_NOTIFICATION + "$userId",
        context: context, headers: Header.userAuth, type: RequestType.Get);

    return res != null
        ? res
            .map<NotificationModel>((item) => NotificationModel.fromJson(item))
            .toList()
        : null;
  }

  getUserCategoriesWithItems(BuildContext context) async {
    final res = await request(EndPoint.USER_PRODUCT_CATEGORY,
        context: context, headers: Header.userAuth, type: RequestType.Get);

    return res != null
        ? res
            .map<ProductsWithItems>((item) => ProductsWithItems.fromJson(item))
            .toList()
        : null;
  }

  getBusinessCategoriesWithItems(BuildContext context) async {
    final res = await request(EndPoint.BUSINESS_PRODUCT_CATEGORY,
        context: context, headers: Header.userAuth, type: RequestType.Get);

    return res != null
        ? res
            .map<ProductsWithItems>((item) => ProductsWithItems.fromJson(item))
            .toList()
        : null;
  }

  getUserAddresses(BuildContext context, {String userId}) async {
    final res = await request(EndPoint.GET_USER_ADDRESS,
        headers: Header.userAuth,
        type: RequestType.Get,
        context: context,
        queryParameters: {'userId': userId});

    return res != null
        ? res.map<AddressModel>((item) => AddressModel.fromJson(item)).toList()
        : null;
  }

  getBalance(BuildContext context, {String teamId}) async {
    final res = await request(EndPoint.GET_TEAM_BALANCE,
        headers: Header.userAuth,
        type: RequestType.Get,
        context: context,
        queryParameters: {'teamId': teamId});

    return res != null ? Balance.fromJson(res) : null;
  }

  uploadImages(BuildContext context, List<PickedFile> pickedFiles) async {
    // var files = [];
    var formData = FormData();
    pickedFiles.forEach((element) async {
      formData.files.add(
        MapEntry(
          "files",
          MultipartFile.fromFileSync(element.path, filename: element.path),
        ),
      );
    });
    final res = await request(EndPoint.UPLOAD_MULTI_FILES,
        context: context,
        headers: Header.userAuth,
        type: RequestType.Post,
        body: formData);

    return res != null
        ? res
            .map<UploadedFileModel>((item) => UploadedFileModel.fromJson(item))
            .toList()
        : null;
  }

  addProduct(BuildContext context, {Map<String, dynamic> body}) async {
    final res = await request(EndPoint.UPLOAD_PRODUCT,
        context: context,
        headers: Header.userAuth,
        type: RequestType.Post,
        body: body);

    return res != null ? true : false;
  }

  checkOut(BuildContext context, {Map<String, dynamic> body}) async {
    final res = await request(EndPoint.ORDER_CHECK_OUT,
        context: context,
        headers: Header.userAuth,
        type: RequestType.Post,
        body: body);

    return res != null ? true : false;
  }

  checkOutCard(BuildContext context, {Map<String, dynamic> body}) async {
    final res = await request(EndPoint.ORDER_CHECK_OUT,
        context: context,
        headers: Header.userAuth,
        type: RequestType.Post,
        body: body);

    return res != null ? res['result'] : false;
  }

  addAddress(BuildContext context, {Map<String, dynamic> body}) async {
    final res = await request(EndPoint.ADD_ADDRESS,
        context: context,
        headers: Header.userAuth,
        type: RequestType.Post,
        body: body);

    return res != null ? true : false;
  }

  getUserOrders(BuildContext context, {Map<String, dynamic> param}) async {
    final res = await request(EndPoint.GET_USER_ORDERS,
        headers: Header.userAuth,
        type: RequestType.Get,
        context: context,
        queryParameters: param);

    return res != null
        ? res.map<MyOrders>((item) => MyOrders.fromJson(item)).toList()
        : null;
  }

  getTeamByTeamID(BuildContext context, {String teamID}) async {
    final res = await request(
      EndPoint.GET_TEAM_BY_ID + teamID,
      headers: Header.userAuth,
      type: RequestType.Get,
      context: context,
    );

    return res != null ? Teams.fromJson(res) : null;
  }

  @override
  getUserByID(BuildContext context, {String userId}) async {
    final res = await request(
      EndPoint.GET_USER_BY_ID + userId,
      headers: Header.userAuth,
      type: RequestType.Get,
      context: context,
    );

    return res != null ? UserInfo.fromJson(res) : null;
  }

  remind({BuildContext context, Map<String, dynamic> param}) async {
    final res = await request(EndPoint.REMIND,
        headers: Header.userAuth,
        type: RequestType.Post,
        context: context,
        queryParameters: param);

    return res != null ? true : false;
  }

  changeUserPassword(BuildContext context, {Map<String, dynamic> body}) async {
    final res = await request(
      EndPoint.CHANGE_PASSWORD,
      context: context,
      type: RequestType.Post,
      headers: Header.userAuth,
      body: body,
    );
    return res;
  }

  updateSeason(BuildContext context,
      {String seasonId, Map<String, dynamic> body}) async {
    final res = await request(
      EndPoint.SEASON + "/$seasonId",
      context: context,
      type: RequestType.Put,
      headers: Header.userAuth,
      body: body,
    );
    return res;
  }
}

//   Future<User> registerUser({@required User user}) async {
//     final response = await request(EndPoint.REGISTER, type: RequestType.Post, body: user.toJson());
//     return response != null ? User.fromJson(response) : null;
//   }

//   Future<String> refreshToken({@required String username, String password}) async {
//     print(username + " " + password);
//     try {
//       final body = {'username': username, 'password': password, 'grant_type': 'password'};
//       final response = await request(EndPoint.TOKEN, type: RequestType.Post, headers: Header.clientAuth, contentType: Headers.formUrlEncodedContentType, body: body);
//       return response != null ? response['access_token'] : null;
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }

//   Future<String> uploadImage({@required File image}) async {
//     final formData = FormData.fromMap({'file': await MultipartFile.fromFile(image.path, filename: 'image.png')});
//     final response = await request('upload', type: RequestType.Post, contentType: Headers.contentTypeHeader, body: formData);
//     return response['fileURL'] ?? null;
//   }

//   Future<User> getUser({@required int id}) async {
//     final response = await request(EndPoint.USER + '/$id');

//     return response != null ? User.fromJson(response) : null;
//   }

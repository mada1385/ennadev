import 'package:enna/core/models/address.dart';
import 'package:enna/core/models/category.dart';
import 'package:enna/core/models/contacts.dart';
import 'package:enna/core/models/product_items.dart';
import 'package:enna/core/models/products_with_items.dart';
import 'package:enna/ui/home/home_taps/contacts/add_user_contact.dart';
import 'package:enna/ui/home/home_taps/contacts/contacts_main_page.dart';
import 'package:enna/ui/home/home_taps/contacts/user_contact_details.dart';
import 'package:enna/ui/home/home_taps/shop/payment.dart';
import 'package:enna/ui/shared/drawer/my_teams/my_teams.dart';
import 'package:enna/ui/shared/pages/camping-date.dart';
import 'package:enna/ui/shared/pages/create-or-join-team.dart';
import 'package:enna/ui/shared/pages/create_season.dart';
import 'package:enna/ui/shared/pages/selcect-team.dart';
import 'package:enna/ui/shared/pages/select_from_invitations.dart';
import 'package:enna/ui/shared/pages/season_location.dart';
import 'package:flutter/material.dart';
import 'package:enna/ui/shared/drawer/my_teams/add_contact.dart';
import 'package:enna/ui/home/home_taps/event/add_events.dart';
import 'package:enna/ui/home/home_page.dart';
import 'package:enna/ui/home/home_taps/event/events.dart';
import 'package:enna/ui/home/home_taps/home.dart';
import 'package:enna/ui/home/home_taps/shop/add_address.dart';
import 'package:enna/ui/home/home_taps/shop/add_product.dart';
import 'package:enna/ui/home/home_taps/shop/product.dart';
import 'package:enna/ui/home/home_taps/shop/shop.dart';
import 'package:enna/ui/home/home_taps/shop/shop_address.dart';
import 'package:enna/ui/home/home_taps/shop/view_all_products.dart';
import 'package:enna/ui/home/home_taps/transaction/view_all_expenses.dart';
import 'package:enna/ui/home/home_taps/transaction/transaction.dart';
import 'package:enna/ui/home/home_taps/transaction/view_all_cash.dart';
import 'package:enna/ui/home/notification.dart';
import 'package:enna/ui/shared/drawer/about_us.dart';
import 'package:enna/ui/shared/drawer/location.dart';
import 'package:enna/ui/shared/drawer/privacy_policy.dart';
import 'package:enna/ui/shared/drawer/team_members/team_members.dart';
import 'package:enna/ui/shared/pages/create_team_page.dart';
import 'package:enna/ui/shared/drawer/edit_profile.dart';
import 'package:enna/ui/shared/pages/sign_In.dart';
import 'package:enna/ui/shared/pages/sign_up.dart';
import 'package:enna/ui/shared/pages/splash_screen.dart';
import 'package:enna/ui/home/home_taps/transaction/add_cash.dart';
import 'package:enna/ui/home/home_taps/transaction/add_expense.dart';

class Routes {
  static Widget get splash => SplashScreen();
  static Widget get signIn => SignInPage();
  static Widget get createTeam => CreateTeamPage();

  //app bar Icons
  static Widget get notification => NotificationPage();

  // Transactions Tab
  static Widget get addcash => AddCashPage();
  static Widget get addexpense => AddExpensePage();
  static Widget get viewAllTransaction => AllTransactionPage();

  static Widget get allexpenses => AllExpensesPage();

  //Contacts Tab
  static Widget get addUserContact => AddUserContactPage();
  static Widget contactsDetails({ContactsCateoryModel contacts}) =>
      UserContactsDetailsPage(contacts: contacts);

  // Evnets Tab
  static Widget get addEvent => AddEventPage();

  // Shop Tab
  static Widget addProduct({List<Category> categories}) => AddProductPage(
        categories: categories,
      );
  static Widget viewAllProducts({ProductsWithItems category, bool isUser}) =>
      ViewAllProductsPage(category: category, isUser: isUser);
  static Widget product({Products product}) => ProductPage(product: product);
  static Widget shopAddress({Products product}) =>
      ShopAddressPage(product: product);
  static Widget get addAddress => AddAdderssPage();

  static Widget payment({AddressModel selectedAddress, Products product}) =>
      PaymentPage(selectedAddress: selectedAddress, product: product);

  // Home page
  static Widget get homePage => HomePage();
  static Widget get home => Home();
  static Widget get transaction => TransactionPage();
  static Widget get events => EventsPage();
  static Widget get contacts => MainContactsPage();
  static Widget get shop => ShopePage();

  //Drawer Screens
  static Widget get editProfile => EditProfilePage();
  static Widget get teamMembers => TeamMembersPage();
  static Widget get addContact => AddContactPage();
  static Widget get location => LocationPage();
  static Widget get aboutUs => AboutUsPage();
  static Widget get myteams => MyTeamsPage();

  static Widget get privacyPolicy => PrivacyPolicyPage();

  static Widget get creatOrJoinTeam => CreatOrJoinTeam();
  static Widget get selectFromInvitations => SelectFromInvitationsPage();
  static Widget selectTeam({bool isInvited}) =>
      SelectTeamPage(isInvited: isInvited);
  static Widget get createSeason => CreateSeasonPage();
  static Widget get campingDate => CampingDatePage();

  static Widget get signUp => SignUpPage();
  static Widget seasonLocation({Map<String, dynamic> body}) =>
      SeasonLocationPage(body: body);
}

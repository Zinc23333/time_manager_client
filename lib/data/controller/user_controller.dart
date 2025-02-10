import 'package:time_manager_client/data/types/user_account.dart';

class User {
  static int? id;
  static List<UserAccount> accounts = [];
  static String icon = "😀";

  static String getControllerId = "==user";
}

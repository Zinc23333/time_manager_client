class User {
  static int? id;
  static List<UserAccount> accounts = [];
}

class UserAccount {
  const UserAccount();
}

class UserAccountPhone extends UserAccount {
  final int phone;
  const UserAccountPhone(this.phone);
}

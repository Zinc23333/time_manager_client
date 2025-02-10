import 'package:flutter/material.dart';

class UserAccount {
  const UserAccount();

  String get account {
    throw UnimplementedError();
  }

  IconData get icon {
    throw UnimplementedError();
  }
}

class UserAccountPhone extends UserAccount {
  final int phone;
  const UserAccountPhone(this.phone);

  @override
  String get account => phone.toString();

  @override
  IconData get icon => Icons.phone;
}

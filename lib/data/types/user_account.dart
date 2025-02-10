import 'package:flutter/material.dart';
import 'package:time_manager_client/data/proto.gen/user.pb.dart' as p;

class UserAccount {
  const UserAccount();

  String get account => throw UnimplementedError();
  IconData get icon => throw UnimplementedError();
  p.UserAccount toProto() => throw UnimplementedError();
  UserAccount.fromProto(p.UserAccount proto);
}

class UserAccountPhone extends UserAccount {
  final int phone;
  const UserAccountPhone(this.phone);

  @override
  String get account => phone.toString();

  @override
  IconData get icon => Icons.phone;

  @override
  p.UserAccount toProto() => p.UserAccount(
        account: phone.toString(),
        type: p.UserAccountType.PHONE,
      );

  @override
  UserAccountPhone.fromProto(p.UserAccount proto) : phone = int.parse(proto.account);
}

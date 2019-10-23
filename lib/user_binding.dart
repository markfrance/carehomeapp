import 'package:flutter/material.dart';

import 'user_model.dart';

class UserBinding extends InheritedWidget {
  UserBinding({
    Key key,
    this.user,
    Widget child,
  }) : assert(user != null), super(key: key, child: child);

  final User user;

  @override
  bool updateShouldNotify(UserBinding oldWidget) => user != oldWidget.user;

  static UserBinding of(BuildContext context) =>  context.inheritFromWidgetOfExactType(UserBinding);
}
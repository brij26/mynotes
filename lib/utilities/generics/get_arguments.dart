import 'package:flutter/material.dart' show BuildContext, ModalRoute;

extension GetArguments on BuildContext {
  T? getArguments<T>() {
    final modelRoute = ModalRoute.of(this);
    if (modelRoute != null) {
      final args = modelRoute.settings.arguments;
      if (args != null && args is T) {
        return args as T;
      }
    } else {
      return null;
    }
  }
}

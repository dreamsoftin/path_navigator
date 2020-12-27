import 'package:flutter/cupertino.dart';

import 'path_builder.dart';

abstract class Path {
  String get routeName;
  String get url {
    String inital = "$routeName";
    return inital + (subRoute?.url != null ? "/${subRoute.url}" : "");
  }

  Widget pageBuilder(BuildContext context, Path currentRoute);
  Map<String, dynamic> arguments = {};
  List<PathBuilder> subRouteBuilder = [];
  Path subRoute;

  // CustomPath get subRoute => _subRoute;

  // set subRoute(CustomPath subRoute) {

  //     _subRoute = subRoute;

  // }

  Future<bool> canRemove() async {
    return true && (await subRoute?.canRemove() ?? true);
  }

  Path({
    this.arguments,
    // this.subRoute,
  }) {
    arguments = arguments ?? {};
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Path && o.routeName == routeName;
  }

  @override
  int get hashCode {
    return routeName.hashCode ^
        arguments.hashCode ^
        subRouteBuilder.hashCode ^
        subRoute.hashCode;
  }
}

class NotFoundRoute extends Path {
  @override
  String get routeName => "notfound";

  @override
  Widget pageBuilder(BuildContext context, Path currentRoute) {
    return Center(
      child: Text("PATH NOT FOUND"),
    );
  }
}

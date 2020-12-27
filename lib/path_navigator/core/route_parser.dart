import 'package:flutter/material.dart';
import 'path_navigator_state.dart';

import 'route/path.dart';
import 'routes.dart';

class PathInformationParser extends RouteInformationParser<Path> {
  final PathNavigatorState routeState;

  PathInformationParser(this.routeState);
  @override
  Future<Path> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);
    print(routeInformation.location);
    var path = routeState.parse(uri.pathSegments);
    routeState.routeStack = path;
    return path; //routeState.activeMainRoute;
  }

  @override
  RouteInformation restoreRouteInformation(Path configuration) {
    return RouteInformation(
      location: "/" + configuration.url,
    );
  }
}

class PathRouterDelegate extends RouterDelegate<Path>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Path> {
  // final GlobalKey<NavigatorState> navigatorKey;

  final PathNavigatorState routeState;

  Path get currentConfiguration {
    return routeState.activeMainRoute;
  }

  PathRouterDelegate(this.routeState) {
    routeState.addListener(notifyListeners);
  }

  @override
  Widget build(BuildContext context) {
    return //AppShell(routeState: routeState);
        Navigator(
      key: routeState.navigatorKey,
      pages: [
        MaterialPage(child: routeState?.module?.child, maintainState: false)
      ],
      onPopPage: (route, result) {
        routeState.pop();
        notifyListeners();
        if (!route.didPop(result)) {
          return false;
        }
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    routeState.setRoute(configuration);
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => routeState.navigatorKey;
}

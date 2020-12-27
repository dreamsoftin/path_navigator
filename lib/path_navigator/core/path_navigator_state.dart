import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'routes.dart';

class PathNavigatorState extends ChangeNotifier {
  PathModule module;
  Path routeStack;
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  BuildContext get context => navigatorKey.currentContext;
  // List<CustomPath> subRoute = [];
  // CustomRouteState() {

  // }
  init(PathModule appModule) {
    this.module = appModule;
    routeStack =
        module.routes.first.builder.call(module.routes.first.arguments);
  }

  Path get activeMainRoute => routeStack;
  List<Path> get activeRouteList {
    var list = [routeStack];
    if (routeStack != null) {
      list.addAll(transform(routeStack));
    }
    return list;
  }

  Path get currentRoute => getLeafRoute(routeStack);

  List<Path> transform(Path route) {
    List<Path> list = [];
    // list.add(route);
    if (route.subRoute != null) {
      // for (var item in route.subRoute) {
      list.add(route.subRoute);
      list.addAll(transform(route.subRoute));
      // }
    }
    return list;
  }

  Future<bool> pushAndRemoveUntil(
      Path path, bool Function(Path) shouldPop,
      {Map<String, dynamic> args}) async {
    bool canPop = await activeMainRoute.canRemove();
    if (!canPop) return false;
    _removeLast(activeMainRoute, shouldPop);
    if (activeMainRoute.routeName == path.routeName) {
      // activeMainRoute.subRoute = null;

      path.subRoute = null;
      // pushNewRoute(path)
      routeStack = path;
    } else
      addSubRoute(activeMainRoute, path);
      return true;
  }

  Path getLeafRoute(Path path) {
    if (path.subRoute == null)
      return path;
    else
      return getLeafRoute(path.subRoute);
  }

  Future<void> pushNewRoute(Path path,
      {Map<String, dynamic> args}) async {
    // _addSubRoute(path);
    bool canPop = await activeMainRoute.canRemove();
    if (!canPop) return;
    path.arguments = path.arguments ?? {};
    if (args != null) {
      path.arguments.addAll(args);
    }
    routeStack = path;
    // subRoute = [];
    notifyListeners();
  }

  Future<void> pushSubRoute(Path path,
      {Map<String, dynamic> args}) async {
    // _addSubRoute(path);
    path.arguments = path.arguments ?? {};
    if (args != null) {
      path.arguments.addAll(args);
    }
    bool canPop = await currentRoute.canRemove();
    if (!canPop) return;
    addSubRoute(activeMainRoute, path);
    notifyListeners();
  }

  Future<void> pushSubAndReplace(Path path,
      {Map<String, dynamic> args}) async {
    // _addSubRoute(path);
    path.arguments = path.arguments ?? {};
    if (args != null) {
      path.arguments.addAll(args);
    }
    bool canPop = await currentRoute.canRemove();
    if (!canPop) return;
    _removeLast(activeMainRoute, (path) {
      return path == currentRoute;
    });
    addSubRoute(activeMainRoute, path);
    notifyListeners();
  }

  Future<bool> pop() async {
    // if (subRoute.isNotEmpty) {
    // subRoute.removeLast();
    try {
      bool canPop = await currentRoute.canRemove();
      if (!canPop) return false;
      _removeLast(activeMainRoute, (path) {
        return path == currentRoute;
      });
    } catch (e) {}
    // notifyListeners();
    // return false;
    // }
    notifyListeners();

    return true;
  }

  void addSubRoute(Path main, Path newRoute) async {
    int current = main.subRouteBuilder.indexWhere((element) {
      print(
          "addSubRoute : ${element.pathName} == ${newRoute.routeName}  ==> ${element.pathName == newRoute.routeName}");
      return element.pathName == newRoute.routeName;
    });
    print(
        "addSubRoute :  ${main.routeName} ===> ${newRoute.routeName} $current");
    if (main.subRoute == null || main.subRoute == newRoute || current != -1) {
      print("addSubRoute : Inside Replace  ${main.routeName} ");
      main.subRoute = newRoute;
    } else {
      // if (current < 0)
      print("addSubRoute : Inside Call");
      addSubRoute(main.subRoute, newRoute);
      // else
      //   main.subRoute = newRoute;
    }
  }

  Future<bool> canRemove(Path path) async {
    return path.canRemove();
  }

  bool _removeLast(Path main, [bool Function(Path) until]) {
    if (main.subRoute == null || (until?.call(main) ?? false)) {
      return true;
    } else {
      bool shouldRemove = _removeLast(main.subRoute);
      print("_removeLast : ${main.routeName} ==>$shouldRemove");
      if (shouldRemove) {
        main.subRoute = null;
      }
      return false;
    }
  }

  Path parse(List<String> segments) {
    if (segments.isEmpty) return module.routes.first.builder(Object());
    // CustomPath path;
    String pathName = segments.first;
    segments = segments.sublist(1);
    var builder = module.routes.firstWhere(
        (element) => element.pathName.contains("$pathName"),
        orElse: () => PathBuilder(pathName,
            (_) => NotFoundRoute())); //customPathBuilder["/$pathName"];
    routeStack = builder.builder?.call(pathName);

    if (segments.isNotEmpty && routeStack.subRouteBuilder.isNotEmpty) {
      parseSubRoutes(segments.join("/"), routeStack);
    }

    return routeStack;
  }

  parseSubRoutes(String url, Path routeStack) {
    Path path;
    // List<String> segments = url.split("/");
    // String pathName = segments.first;

    List<PathBuilder> pathBuilders = routeStack.subRouteBuilder;

    PathBuilder builder;
    Map<String, String> arguments = {};
    int count = 0;

    ///Sort possible paths so that we get non-parametered path first.
    pathBuilders.sort((preview, actual) {
      return preview.pathName.contains(':') ? 1 : 0;
    });

    for (var pathBuilder in pathBuilders) {
      String rawName = pathBuilder.pathName;
      if (rawName.startsWith(RegExp(r"^/"))) {
        rawName = rawName.substring(1);
      }
      print("PARSING $pathBuilder");
      final regExp = RegExp(
        "^${prepareToRegex(rawName)}\$",
        caseSensitive: true,
      );
      print("============================");
      print("Route Name         : $rawName");
      print("Regular Expression : ${regExp.pattern}");
      print("Url                : $url");
      var match = regExp.firstMatch(url);
      print("First Match        : ${match?.start} to ${match?.end}");
      if (match != null) {
        count = 0;
        print("     **********************************");
        String matchString = url.substring(match.start, match.end);
        print("     Match String    :$matchString");
        builder = pathBuilder;
        List<String> patternsegments = rawName.split("/");
        List<String> valueSegments = matchString.split("/");
        for (int i = 0; i < patternsegments.length; i++) {
          String pattern = patternsegments[i];
          String urlValue = valueSegments[i];
          if (pattern.contains(":")) {
            print("     argumentExtraction    :$pattern");

            String value = urlValue;
            String id = pattern.replaceAll(":", "");
            print("     ID                   :$id");
            print("     value                :$value");
            builder.arguments = builder.arguments ?? {};
            builder.arguments[id] = value;
            arguments[id] = value;
          }
          count++;
        }
        print("UEL BEFORE $url");
        print("Url After $url");
        print("     **********************************");
        break;
        // url = url.replaceFirst(argumentExtraction+"/$value", "");
      }
      print("ORL AFER $url");
      print("============================");
    }

    if (builder == null) return;

    path = builder.builder.call(builder.arguments);
    routeStack.subRoute = path;
    // _addSubRoute(path);
    for (var i = 0; i < count; i++) {
      url = url.replaceFirst(RegExp("([a-zA-Z0-9]+[/]?)"), "");
    }
    if (url.isNotEmpty && path.subRouteBuilder.isNotEmpty)
      parseSubRoutes(url, path);
  }

  String prepareToRegex(String url) {
    final newUrl = <String>[];
    for (var part in url.split('/')) {
      var url = part.contains(":") ? "(.*?)" : part;
      newUrl.add(url);
    }

    return newUrl.join("/");
  }

  void setRoute(Path value) {
    routeStack = (value);
    // notifyListeners();
  }
}

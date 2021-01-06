import 'package:example/app/app.dart';
import 'package:example/app/routes.dart';
import 'package:flutter/material.dart';
import 'package:path_navigator/path_navigator.dart';
import 'package:responsive_scaffold/responsive_scaffold.dart';

class AppModule extends PathModule {
  @override
  Path get rootPath => HomeRoute();

  @override
  List<PathBuilder> get routes => [
        PathBuilder(HomeRoute.name, (_) => HomeRoute()),
        PathBuilder(SettingsRoute.name, (_) => SettingsRoute()),
        PathBuilder(ListRoute.name, (_) => ListRoute()),
      ];
  Widget get child => EntyPint();
}

class EntyPint extends StatelessWidget {
  const EntyPint({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print("Main Size : ${MediaQuery.of(context).size.width}");
    return ResponsiveScaffold(
      drawer: buildDrawer(),
      body: // SidePushScaffold(),
      Stack(
        children: PathNavigator.activeRouteList.map((e) => e.pageBuilder(context, e)).toList(),
      )
    );
    // return ResponsiveBuilder(builder: (context, sizingInfo) {
    //   switch (sizingInfo.deviceScreenType) {
    //     case DeviceScreenType.mobile:
    //       return Scaffold(
    //         appBar: AppBar(),
    //         drawer: buildDrawer(),
    //         body: SidePushScaffold(),
    //       );
    //       break;
    //     case DeviceScreenType.tablet:
    //       Scaffold(
    //         body: Row(
    //           children: [
    //             SizedBox(
    //               width: 100,
    //               // duration: duration,
    //               child: buildDrawer(),
    //             ),
    //             SizedBox(
    //                 width: MediaQuery.of(context).size.width - 100,
    //                 child: SidePushScaffold()),
    //           ],
    //         ),
    //       );
    //       break;
    //     case DeviceScreenType.desktop:
    //     // break;
    //     default:
    //   }
    //   return Scaffold(
    //     body: Row(
    //       children: [
    //         AnimatedContainer(
    //           width: 304,
    //           duration: duration,
    //           child: buildDrawer(),
    //         ),
    //         SizedBox(
    //             width: MediaQuery.of(context).size.width - 304,
    //             child: SidePushScaffold()),
    //       ],
    //     ),
    //   );
    // });
  }

  Drawer buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text("Home"),
            onTap: () {
              PathNavigator.pushNewRoute(HomeRoute());
            },
          ),
          ListTile(
            title: Text("Setting"),
            onTap: () {
              PathNavigator.pushNewRoute(SettingsRoute());
            },
          ),
          ListTile(
            title: Text("List"),
            onTap: () {
              PathNavigator.pushNewRoute(ListRoute());
            },
          ),
        ],
      ),
    );
  }
}

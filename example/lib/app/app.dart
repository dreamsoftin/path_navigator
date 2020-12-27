import 'dart:math';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:path_navigator/path_navigator.dart';
import 'package:responsive_builder/responsive_builder.dart';


class SidePushScaffold extends StatefulWidget {
  const SidePushScaffold({
    Key key,
    this.maxNumberOfSection = 3,
  }) : super(key: key);
  final int maxNumberOfSection;

  @override
  _SidePushScaffoldState createState() => _SidePushScaffoldState();
}

class _SidePushScaffoldState extends State<SidePushScaffold> {
  bool expand = false;

  @override
  Widget build(BuildContext context) {
    var lastThreeRoutes2 = lastThreeRoutes();
    // int lenth = lastThreeRoutes2.length + 1;
    // Size size = MediaQuery.of(context).size;
    int visibleNumber = widget.maxNumberOfSection;
    return ResponsiveBuilder(builder: (context, sizingInfo) {
      switch (sizingInfo.deviceScreenType) {
        case DeviceScreenType.mobile:

        case DeviceScreenType.tablet:
          // return Column(
          //   mainAxisSize: MainAxisSize.min,
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   crossAxisAlignment: CrossAxisAlignment.stretch,
          //   children: [
          //     BackButton(
          //       onPressed: () {
          //         RouteState.pop();
          //       },
          //     ),
          //     lastThreeRoutes2.last.pageBuilder(context, lastThreeRoutes2.last),
          //   ],
          // );
          visibleNumber = 1;
          break;
        case DeviceScreenType.desktop:
          visibleNumber = widget.maxNumberOfSection;
          break;
        case DeviceScreenType.watch:
          break;
        default:
      }
      if (expand) visibleNumber = 1;
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < lastThreeRoutes2.length + 1; i++) ...{
            Builder(builder: (context) {
              Path e;
              try {
                e = lastThreeRoutes2[i];
              } catch (e) {}
              bool isVisible = i > lastThreeRoutes2.length - visibleNumber - 1;
              return AnimatedContainer(
                color: Color((Random().nextDouble() * 0xFFFFFF).toInt())
                    .withOpacity(1.0),
                duration: duration,
                width: e == null || !isVisible
                    ? 0
                    : sizingInfo.localWidgetSize.width *
                        (1 /
                            (lastThreeRoutes2.length > visibleNumber
                                ? visibleNumber
                                : lastThreeRoutes2.length)),
                child: e == null || !isVisible
                    ? Container()
                    : Stack(
                        fit: StackFit.expand,
                        children: [
                          e.pageBuilder(context, e),
                          Align(
                            alignment: Alignment.topRight,
                            child: !expand
                                ? IconButton(
                                    icon: Icon(Icons.expand),
                                    onPressed: () async {
                                      if (e.subRoute != null)
                                       expand =  await PathNavigator.pushAndRemoveUntil(
                                            e,
                                            (a) =>
                                                a.routeName ==
                                                (e?.subRoute?.routeName ??
                                                    a.routeName));
                                      else expand = true;
                                      setState(() {
                                        // expand = true;
                                      });
                                    })
                                : IconButton(
                                    icon: Icon(Icons.shield),
                                    onPressed: () {
                                      setState(() {
                                        expand = false;
                                      });
                                    }),
                          ),
                          Align(
                            child: BackButton(
                              onPressed: () {
                                PathNavigator.pop();
                              },
                            ),
                          )
                        ],
                      ),
              );
            })
          }
        ],
      );
      // });
    });
  }

  List<Path> lastThreeRoutes() {
    // CustomRouteState routeState = locator.get<CustomRouteState>();

    return PathNavigator.activeRouteList;
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("HOME"),
    );
  }
}

class AppShell2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          PathNavigator.currentRoute.pageBuilder(context, PathNavigator.currentRoute),
    );
  }
}

Duration duration = Duration(milliseconds: 250);

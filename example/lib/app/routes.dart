import 'dart:convert';

import 'package:example/app/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_navigator/path_navigator.dart';
import 'package:responsive_builder/responsive_builder.dart';



class HomeRoute extends Path {
  static String get name => "home";
  @override
  String get routeName => name;

  @override
  Widget pageBuilder(BuildContext context, Path currentRoute) {
    return Home();
  }
}

class SettingsRoute extends Path {
  static String get name => "settings";
  @override
  String get routeName => name;

  @override
  Widget pageBuilder(BuildContext context, Path currentRoute) {
    return Center(
      child: Text("Settings"),
    );
  }
}

class ListRoute extends Path {
  static String get name => "users";
  @override
  String get routeName => name;

  @override
  List<PathBuilder> get subRouteBuilder => [
        PathBuilder(ListDetailRoute.name,
            (args) => ListDetailRoute((args as Map)["id"])),
        PathBuilder(ListDetailAddRoute.name, (args) => ListDetailAddRoute())
      ];

  @override
  Widget pageBuilder(BuildContext context, Path e) {
    return ResponsiveBuilder(builder: (context, sizingInfo) {
      switch (sizingInfo.deviceScreenType) {
        case DeviceScreenType.mobile:
          break;
        case DeviceScreenType.tablet:
          break;
        case DeviceScreenType.desktop:
          if (subRoute != null) break;
          return Row(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    bool selected =
                        e.subRoute != null && e.subRoute is ListDetailRoute
                            ? (e.subRoute as ListDetailRoute).id == "$i"
                            : false;
                    return ListTile(
                      title: Text(selected ? "SELECTED $i" : "$i"),
                      onTap: () {
                        PathNavigator.pushSubRoute(ListDetailRoute(i.toString()));
                      },
                      trailing: BackButton(
                        onPressed: () {
                          PathNavigator.pushSubRoute(ListDetailAddRoute());
                        },
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.amber,
                  child: Center(child: Text("Empty")),
                ),
              )
            ],
          );
          break;
        default:
      }
      return ListView.builder(
        itemCount: 5,
        shrinkWrap: true,
        itemBuilder: (context, i) {
          bool selected = e.subRoute != null && e.subRoute is ListDetailRoute
              ? (e.subRoute as ListDetailRoute).id == "$i"
              : false;
          return ListTile(
            title: Text(selected ? "SELECTED $i" : "$i"),
            onTap: () {
              PathNavigator.pushSubRoute(ListDetailRoute(i.toString()));
            },
            trailing: BackButton(
              onPressed: () {
                PathNavigator.pushSubRoute(ListDetailAddRoute());
              },
            ),
          );
        },
      );
    });
  }
}

abstract class SubCustomPath extends Path {
  String get id;
  String get segment;
  bool operator ==(Object other) {
    return (other is SubCustomPath && other.segment == segment);
  }

  @override
  int get hashCode => segment.hashCode;
}

class ListDetailRoute extends Path {
  static String get name => ":id";
  final String id;

  ListDetailRoute(this.id);
  @override
  String get routeName => ":id";

  @override
  String get url {
    String inital = "$id";
    return inital + (subRoute?.url != null ? "/${subRoute.url}" : "");
  }

  @override
  List<PathBuilder> get subRouteBuilder => [
        PathBuilder(InvoicesRoute.pathName,
            (args) => InvoicesRoute((args as Map)["sub_id"], userId: id))
      ];

  @override
  Widget pageBuilder(BuildContext context, Path e) {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      itemBuilder: (context, i) {
        bool selected = e.subRoute != null && e.subRoute is InvoicesRoute
            ? (e.subRoute as InvoicesRoute).id == "$i"
            : false;
        return ListTile(
          title: Text(selected ? "SELECTED Detail $i" : " Detail $i"),
          onTap: () {
            PathNavigator.pushSubRoute(InvoicesRoute(i.toString(), userId: id));
          },
          // trailing: BackButton(
          //   onPressed: () {
          //     routeState.pushSubRoute(ListDetailAddRoute());
          //   },
          // ),
        );
      },
    );
  }
}

class ListDetailAddRoute extends Path {
  static String get name => "add";
  // final String id;

  ListDetailAddRoute();
  @override
  String get routeName => "add";

  @override
  String get url {
    String inital = "add";
    // print("$routeName  ==> ${subRoute?.url}");
    // for (var route in subRoute ?? []) {
    //   inital += route.url;
    // }
    return inital + (subRoute?.url != null ? "/${subRoute.url}" : "");
  }

  @override
  List<PathBuilder> get subRouteBuilder => [
        // PathBuilder(InvoicesRoute.pathName,
        //     (args) => InvoicesRoute((args as Map)["sub_id"]))
      ];

  @override
  Widget pageBuilder(BuildContext context, Path currentRoute) {
    return Center(
      child: Text("Add"),
    );
  }
}

class InvoicesRoute extends Path {
  static String get pathName => "invoices/:sub_id";

  final String id;
  final String userId;
  InvoicesRoute(this.id, {this.userId});
  @override
  String get routeName => "invoices/:sub_id";
  @override
  String get url {
    String inital = "invoices/$id";
    // print("$routeName  ==> ${subRoute?.url}");
    // for (var route in subRoute ?? []) {
    //   inital += route.url;
    // }
    return inital + (subRoute?.url != null ? "/${subRoute.url}" : "");
  }

  @override
  List<PathBuilder> get subRouteBuilder => [
        PathBuilder(
            ListDetailSubSubRoute.name,
            (args) => ListDetailSubSubRoute((args as Map)["sub_sub_id"],
                data: (args as Map)["data"]))
      ];

  @override
  Widget pageBuilder(BuildContext context, Path e) {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      itemBuilder: (context, i) {
        bool selected =
            e.subRoute != null && e.subRoute is ListDetailSubSubRoute
                ? (e.subRoute as ListDetailSubSubRoute).id == "$i"
                : false;
        return ListTile(
          title: Text(selected
              ? "SELECTED sub_sub_id $i"
              : "$userId $id sub_sub_id $i"),
          onTap: () {
            PathNavigator.pushSubRoute(
                ListDetailSubSubRoute(i.toString(),
                    data: Data(name: "My NAme", number: 15.0 * i)),
                args: {"data": ""});
          },
          // trailing: BackButton(
          //   onPressed: () {
          //     routeState.pushSubRoute(ListDetailAddRoute());
          //   },
          // ),
        );
      },
    );
  }
}

class ListDetailSubSubRoute extends Path {
  static String get name => "subsub/:sub_sub_id";
  final String id;
  final Data data;
  ListDetailSubSubRoute(
    this.id, {
    this.data,
  });
  @override
  String get routeName => "subsub/:sub_sub_id";
  @override
  String get url {
    String inital = "subsub/$id";
    // print("$routeName  ==> ${subRoute?.url}");
    // for (var route in subRoute ?? []) {
    //   inital += route.url;
    // }
    return inital + (subRoute?.url != null ? "/${subRoute.url}" : "");
  }

  // bool canPop = true;
  ValueNotifier<bool> canPop = ValueNotifier(true);
  @override
  Future<bool> canRemove() async {
    // BuildContext context;
    // Builder(builder: (c) {
    //   context = c;
    //   return Container();
    // });
    return await showDialog<bool>(
      context: PathNavigator.context,
      builder: (context) {
        return AlertDialog(
          title: Text("CanRemove"),
          actions: [
            RaisedButton(
                child: Text("YES"),
                onPressed: () {
                  Navigator.pop(context, true);
                }),
            RaisedButton(
                child: Text("NO"),
                onPressed: () {
                  Navigator.pop(context, false);
                }),
          ],
        );
      },
    );
  }

  @override
  Widget pageBuilder(BuildContext context, Path currentRoute) {
    return Container(
      color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(url),
          Text(data?.toString() ?? ""),
          ValueListenableBuilder(
              valueListenable: canPop,
              builder: (context, value, child) => Switch(
                    value: value,
                    onChanged: (newVal) => canPop.value = newVal,
                  ))
        ],
      ),
    );
  }
}

class Data {
  String name;
  double number;
  Data({
    this.name,
    this.number,
  });

  Data copyWith({
    String name,
    double number,
  }) {
    return Data(
      name: name ?? this.name,
      number: number ?? this.number,
    );
  }

  Data merge(Data model) {
    return Data(
      name: model.name ?? this.name,
      number: model.number ?? this.number,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'number': number,
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Data(
      name: map['name'],
      number: map['number'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Data.fromJson(String source) => Data.fromMap(json.decode(source));

  @override
  String toString() => 'Data(name: $name, number: $number)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Data && o.name == name && o.number == number;
  }

  @override
  int get hashCode => name.hashCode ^ number.hashCode;
}

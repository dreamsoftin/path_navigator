import 'package:flutter/material.dart';
import 'package:path_navigator/path_navigator.dart';
import 'app/app_module.dart';

void main() {
  runApp(PathNavigatorApp(
    module: AppModule(),
  ));
}

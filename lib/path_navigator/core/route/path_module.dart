import 'package:flutter/material.dart';

import 'path.dart';
import 'path_builder.dart';

abstract class PathModule {
  Path get rootPath;
  List<PathBuilder> get routes;

  Widget get child;

}

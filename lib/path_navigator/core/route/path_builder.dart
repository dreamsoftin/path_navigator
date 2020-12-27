
import 'path.dart';

class PathBuilder {
  String pathName;
  Map<String, Object> arguments = {};
  Path Function(Object args) builder;
  PathBuilder(
    this.pathName,
    this.builder, {
    this.arguments,
  });

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PathBuilder && o.pathName == pathName && o.builder == builder;
  }

  @override
  int get hashCode => pathName.hashCode ^ builder.hashCode;

  PathBuilder copyWith({
    String pathName,
    Object arguments,
    Path Function(Object args) builder,
  }) {
    return PathBuilder(
      pathName ?? this.pathName,
      builder ?? this.builder,
      arguments: arguments ?? this.arguments,
    );
  }

  PathBuilder merge(PathBuilder model) {
    return PathBuilder(
      model.pathName ?? this.pathName,
      // model.arguments ?? this.arguments,
      model.builder ?? this.builder,
      arguments: model.arguments ?? this.arguments,
    );
  }
}

import 'package:flutter/material.dart';

import '../../path_navigator.dart';

// ignore: non_constant_identifier_names
PathNavigatorState PathNavigator = PathNavigatorState();

class PathNavigatorApp extends StatefulWidget {
  final PathModule module;
  final Key key;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  final RouteInformationProvider routeInformationProvider;
  final BackButtonDispatcher backButtonDispatcher;
  final Widget Function(BuildContext, Widget) builder;
  final String title = '';
  final String Function(BuildContext) onGenerateTitle;
  final Color color;
  final ThemeData theme;
  final ThemeData darkTheme;
  final ThemeData highContrastTheme;
  final ThemeData highContrastDarkTheme;
  final ThemeMode themeMode = ThemeMode.system;
  final Locale locale;
  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;
  final Locale Function(List<Locale>, Iterable<Locale>)
      localeListResolutionCallback;
  final Locale Function(Locale, Iterable<Locale>) localeResolutionCallback;
  final Iterable<Locale> supportedLocales = const <Locale>[Locale('en', 'US')];
  final bool debugShowMaterialGrid = false;
  final bool showPerformanceOverlay = false;
  final bool checkerboardRasterCacheImages = false;
  final bool checkerboardOffscreenLayers = false;
  final bool showSemanticsDebugger = false;
  final bool debugShowCheckedModeBanner = true;
  final Map<LogicalKeySet, Intent> shortcuts;
  final Map<Type, Action<Intent>> actions;
  final String restorationScopeId;
  const PathNavigatorApp({
    @required this.module,
    this.key,
    this.scaffoldMessengerKey,
    this.routeInformationProvider,
    this.backButtonDispatcher,
    this.builder,
    this.onGenerateTitle,
    this.color,
    this.theme,
    this.darkTheme,
    this.highContrastTheme,
    this.highContrastDarkTheme,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
  }) : super(key: key);
  @override
  _PathNavigatorAppState createState() => _PathNavigatorAppState();
}

class _PathNavigatorAppState extends State<PathNavigatorApp> {
  @override
  void initState() {
    super.initState();
    PathNavigator.init(widget.module);
  }

  @override
  Widget build(BuildContext context) {
//TODO: Add Backbutton dispatcher

    return MaterialApp.router(
      routeInformationParser: PathInformationParser(PathNavigator),
      routerDelegate: PathRouterDelegate(PathNavigator),
      key: widget.key,
      scaffoldMessengerKey: widget.scaffoldMessengerKey,
      routeInformationProvider: widget.routeInformationProvider,
      backButtonDispatcher: widget.backButtonDispatcher,
      builder: widget.builder,
      onGenerateTitle: widget.onGenerateTitle,
      color: widget.color,
      theme: widget.theme,
      darkTheme: widget.darkTheme,
      highContrastTheme: widget.highContrastTheme,
      highContrastDarkTheme: widget.highContrastDarkTheme,
      locale: widget.locale,
      localizationsDelegates: widget.localizationsDelegates,
      localeListResolutionCallback: widget.localeListResolutionCallback,
      localeResolutionCallback: widget.localeResolutionCallback,
      shortcuts: widget.shortcuts,
      actions: widget.actions,
      restorationScopeId: widget.restorationScopeId,
      
    );
  }
}
// class PathNavigatorBackButtonDispatcher extends BackButtonDispatcher{
  
// }
// void b({
//   Key key,
//   GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
//   RouteInformationProvider routeInformationProvider,
//   RouteInformationParser<Object> routeInformationParser,
//   RouterDelegate<Object> routerDelegate,
//   BackButtonDispatcher backButtonDispatcher,
//   Widget Function(BuildContext, Widget) builder,
//   String title = '',
//   String Function(BuildContext) onGenerateTitle,
//   Color color,
//   ThemeData theme,
//   ThemeData darkTheme,
//   ThemeData highContrastTheme,
//   ThemeData highContrastDarkTheme,
//   ThemeMode themeMode = ThemeMode.system,
//   Locale locale,
//   Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
//   Locale Function(List<Locale>, Iterable<Locale>) localeListResolutionCallback,
//   Locale Function(Locale, Iterable<Locale>) localeResolutionCallback,
//   Iterable<Locale> supportedLocales = const <Locale>[Locale('en', 'US')],
//   bool debugShowMaterialGrid = false,
//   bool showPerformanceOverlay = false,
//   bool checkerboardRasterCacheImages = false,
//   bool checkerboardOffscreenLayers = false,
//   bool showSemanticsDebugger = false,
//   bool debugShowCheckedModeBanner = true,
//   Map<LogicalKeySet, Intent> shortcuts,
//   Map<Type, Action<Intent>> actions,
//   String restorationScopeId,
// }) {}

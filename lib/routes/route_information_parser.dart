import 'package:declarative_navigation/model/page_configuration.dart';
import 'package:flutter/material.dart';

class MyRouteInformationParser
    extends RouteInformationParser<PageConfiguration> {
  @override
  Future<PageConfiguration> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = Uri.parse(routeInformation.location.toString());

    if (uri.pathSegments.isEmpty) {
      // without path parameter => "/"
      return HomePageConfiguration();
    } else if (uri.pathSegments.length == 1) {
      // path parameter => "/aaa"
      final first = uri.pathSegments[0].toLowerCase();
      if (first == 'home') {
        return HomePageConfiguration();
      } else if (first == 'login') {
        return LoginPageConfiguration();
      } else if (first == 'register') {
        return RegisterPageConfiguration();
      } else if (first == 'splash') {
        return SplashPageConfiguration();
      } else {
        return UnknownPageConfiguration();
      }
    } else if (uri.pathSegments.length == 2) {
      // path parameter => "/aaa/bbb"
      final first = uri.pathSegments[0].toLowerCase();
      final second = uri.pathSegments[1].toLowerCase();
      final quoteId = int.tryParse(second) ?? 0;
      if (first == 'quote' && (quoteId >= 1 && quoteId <= 5)) {
        return DetailQuotePageConfiguration(second);
      } else {
        return UnknownPageConfiguration();
      }
    } else {
      return UnknownPageConfiguration();
    }
  }

  @override
RouteInformation? restoreRouteInformation(PageConfiguration configuration) {
  return switch (configuration) {
    UnknownPageConfiguration() => RouteInformation(
      uri: Uri.parse("/unknown"),
    ),
    SplashPageConfiguration() => RouteInformation(uri: Uri.parse("/splash")),
    RegisterPageConfiguration() => RouteInformation(
      uri: Uri.parse("/register"),
    ),
    LoginPageConfiguration() => RouteInformation(uri: Uri.parse("/login")),
    HomePageConfiguration() => RouteInformation(uri: Uri.parse("/")),
    DetailQuotePageConfiguration() => RouteInformation(
      uri: Uri.parse("/quote/${configuration.quoteId}"),
    ),
  };
}

}

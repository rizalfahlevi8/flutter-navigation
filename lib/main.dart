import 'package:declarative_navigation/common/url_strategy.dart';
import 'package:declarative_navigation/db/auth_repository.dart';
import 'package:declarative_navigation/provider/auth_provider.dart';
import 'package:declarative_navigation/routes/page_manager.dart';
import 'package:declarative_navigation/routes/route_information_parser.dart';
import 'package:declarative_navigation/routes/router_delegate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  final authRepository = AuthRepository();
  final authProvider = AuthProvider(authRepository);
  
  usePathUrlStrategy();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PageManager<String>()),
        ChangeNotifierProvider(create: (context) => authProvider),
      ],
      child: QuotesApp(authRepository: authRepository),
    ),
  );
}

class QuotesApp extends StatefulWidget {
  final AuthRepository authRepository;

  const QuotesApp({Key? key, required this.authRepository}) : super(key: key);

  @override
  State<QuotesApp> createState() => _QuotesAppState();
}

class _QuotesAppState extends State<QuotesApp> {
  late MyRouterDelegate myRouterDelegate;
  late MyRouteInformationParser myRouteInformationParser;

  @override
  void initState() {
    super.initState();
    myRouterDelegate = MyRouterDelegate(widget.authRepository);
    myRouteInformationParser = MyRouteInformationParser();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Quotes App',
      routerDelegate: myRouterDelegate,
      routeInformationParser: myRouteInformationParser,
      backButtonDispatcher: RootBackButtonDispatcher(),
    );
  }
}

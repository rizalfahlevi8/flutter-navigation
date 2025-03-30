import 'package:declarative_navigation/db/auth_repository.dart';
import 'package:declarative_navigation/model/quote.dart';
import 'package:declarative_navigation/screen/form_screen.dart';
import 'package:declarative_navigation/screen/login_screen.dart';
import 'package:declarative_navigation/screen/quote_detail_screen.dart';
import 'package:declarative_navigation/screen/quotes_list_screen.dart';
import 'package:declarative_navigation/screen/register_screen.dart';
import 'package:declarative_navigation/screen/splash_screen.dart';
import 'package:flutter/material.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final AuthRepository authRepository;

  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool isRegister = false;

  MyRouterDelegate(this.authRepository)
    : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  _init() async {
    isLoggedIn = await authRepository.isLoggedIn();
    notifyListeners();
  }

  @override
  // TODO: implement navigatorKey
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  String? selectedQuote;
  bool isForm = false;

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }

    return Navigator(
      key: navigatorKey,
      pages: historyStack,
      onDidRemovePage: (page) {
        if (page.key == ValueKey(selectedQuote)) {
          selectedQuote = null;
          notifyListeners();
        }
        if (page.key == const ValueKey("FormScreen")) {
          isForm = false;
          notifyListeners();
        }
        if (page.key == const ValueKey("RegisterPage")) {
          isRegister = false;
          notifyListeners();
        }
      },
    );
  }

  List<Page> get _splashStack => const [
    MaterialPage(key: ValueKey("SplashPage"), child: SplashScreen()),
  ];
  List<Page> get _loggedOutStack => [
    MaterialPage(
      key: const ValueKey("LoginPage"),
      child: LoginScreen(
        onLogin: () {
          isLoggedIn = true;
          notifyListeners();
        },
        onRegister: () {
          isRegister = true;
          notifyListeners();
        },
      ),
    ),
    if (isRegister == true)
      MaterialPage(
        key: const ValueKey("RegisterPage"),
        child: RegisterScreen(
          onRegister: () {
            isRegister = false;
            notifyListeners();
          },
          onLogin: () {
            isRegister = false;
            notifyListeners();
          },
        ),
      ),
  ];
  List<Page> get _loggedInStack => [
    MaterialPage(
      key: const ValueKey("QuotesListPage"),
      child: QuotesListScreen(
        quotes: quotes,
        onTapped: (String quoteId) {
          selectedQuote = quoteId;
          notifyListeners();
        },
        toFormScreen: () {
          isForm = true;
          notifyListeners();
        },
        onLogout: () {
          isLoggedIn = false;
          notifyListeners();
        },
      ),
    ),
    if (selectedQuote != null)
      MaterialPage(
        key: ValueKey(selectedQuote),
        child: QuoteDetailsScreen(quoteId: selectedQuote!),
      ),
    if (isForm)
      MaterialPage(
        key: ValueKey("FormScreen"),
        child: FormScreen(
          onSend: () {
            isForm = false;
            notifyListeners();
          },
        ),
      ),
  ];

  @override
  Future<void> setNewRoutePath(configuration) {
    // TODO: implement setNewRoutePath
    throw UnimplementedError();
  }
}

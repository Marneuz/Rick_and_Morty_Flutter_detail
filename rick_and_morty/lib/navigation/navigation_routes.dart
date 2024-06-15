// ignore_for_file: constant_identifier_names

import 'package:go_router/go_router.dart';
import 'package:rick_and_morty/pages/detail_page.dart';
import 'package:rick_and_morty/pages/home_page.dart';

class NavigationRoutes {
  static const String HOME = "/";
  static const String DETAIL = "$HOME$_DETAIL_PATH";

  static const String _DETAIL_PATH = "detail";
}

final GoRouter router = GoRouter(routes: [
  GoRoute(
      path: NavigationRoutes.HOME,
      builder: (_, state) => const HomePage(),
      routes: [
        GoRoute(
          path: NavigationRoutes._DETAIL_PATH,
          builder: (_, state) => DetailPage(id: state.extra as int),
        )
      ])
]);

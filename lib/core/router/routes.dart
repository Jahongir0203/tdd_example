import 'package:auto_route/auto_route.dart';
import 'package:tdd_example/core/router/routes.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: CommentsRoute.page, type: .cupertino(), initial: true),
  ];
}

final router = AppRouter();

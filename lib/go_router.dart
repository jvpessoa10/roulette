import 'package:go_router/go_router.dart';
import 'package:roulette/features/items/ItemsScreen.dart';

// GoRouter configuration
final router = GoRouter(
  initialLocation: ItemsScreen.routeName,
  routes: [
    GoRoute(
      path: ItemsScreen.routeName,
      builder: ItemsScreen.goRouterBuilder,
    ),
  ],
);
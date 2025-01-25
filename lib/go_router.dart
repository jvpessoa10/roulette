import 'package:go_router/go_router.dart';
import 'package:roulette/features/items/ItemsScreen.dart';
import 'package:roulette/features/roulette/roulette_screen.dart';

// GoRouter configuration
final router = GoRouter(
  initialLocation: RouletteScreen.routeName,
  routes: [
    GoRoute(
      path: ItemsScreen.routeName,
      builder: ItemsScreen.goRouterBuilder,
    ),
    GoRoute(
      path: RouletteScreen.routeName,
      builder: RouletteScreen.goRouterBuilder,
    )
  ],
);


import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roulette/features/roulette/roulette_bloc.dart';

class RouletteScreen extends StatelessWidget {
  static const String routeName = '/roulette';

  const RouletteScreen({super.key});

  static Uri uri() {
    return Uri(path: routeName);
  }

  static Widget goRouterBuilder(BuildContext context, GoRouterState state) {
    return BlocProvider(
      create: (_) => RouletteBloc(),
      child: RouletteScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GameWidget(
        game: FlameGame(
            world: MyWorld()
        )
    );
  }
}

class MyWorld extends World {
  @override
  Future<void> onLoad() async {
    add(RouletteCenter());
  }
}

class RouletteCenter extends ShapeComponent {
  RouletteCenter(): super(
      position: Vector2.all(0),
      paint: Paint()..color = const Color(0xFF0000FF),
      anchor: Anchor.center
  );

  @override
  void render(Canvas canvas) {
    if (renderShape) {
      final pi = 3.14159265359;

      final rect = Rect.fromCenter(center: Offset.zero, width: 400, height: 400);

      final numItems = 10;

      for (var i =0; i < numItems; i++) {
        final startAngle = (2*pi / numItems) * (i + 1);
        final sweepAngle = 2*pi / numItems;


        final itemPaint = Paint()
          ..color = Color.fromRGBO(255-i*20 , i*20, i*30, opacity)
          ..filterQuality = FilterQuality.low;

        canvas.drawArc(rect, startAngle, sweepAngle, true, itemPaint);
      }

      // final startAngle = (2*pi / 10) * 3;
      // final sweepAngle = 2*pi / 10;
      //
      // final whitePaint = Paint()
      //   ..color = Colors.white;
      //
      // final startAngle2 = 2*pi / 10;
      // final sweepAngle2 = 2*pi / 10;
      // canvas.drawArc(rect, startAngle2, sweepAngle2, true, whitePaint);
    }
  }
}


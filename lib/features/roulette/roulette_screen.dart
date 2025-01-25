

import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
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

  final pi = 3.141592653589793;

  var speed = 100.0;

  var elapsedTime = 0.0;

  final numItems = 20;
  
  final colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.teal,
  ];

  @override
  FutureOr<void> onLoad() {
    final spinEffect = RotateEffect.by(
        tau * 100,
        EffectController(
            duration: 10,
            curve: Curves.easeOutQuint,
        )
    );
    add(spinEffect);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (renderShape) {
      final rect = Rect.fromCenter(center: Offset.zero, width: 400, height: 400);

      for (var i =0; i < numItems; i++) {
        final startAngle = (tau / numItems) * (i + 1);
        final sweepAngle = tau / numItems;

        final color = colors[i % colors.length];

        final itemPaint = Paint()
          // ..shader = Gradient.linear(
          //   Offset(0, 0),
          //   Offset(1, 1),
          //   [
          //     color,
          //     color.withOpacity(0.5),
          //   ],
          // )
          ..color = colors[i % colors.length];



        canvas.drawArc(rect, startAngle, sweepAngle, true, itemPaint);
      }

      final outerRect = Rect.fromCenter(center: Offset.zero, width: 410, height: 410);
      final border = Paint()
        ..color = Color(0xFFFFECB4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10;

      final border2 = Paint()
        ..color = Color(0xFF8A0000)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5;

      canvas.drawArc(outerRect, 0, tau, false, border);
      canvas.drawArc(outerRect, 0, tau, false, border2);

    }
  }
}


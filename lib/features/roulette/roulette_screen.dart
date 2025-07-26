

import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
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
        game: MyGame()
    );
  }
}

class MyGame extends FlameGame with PanDetector {
  late Vector2 screenSize;
  late RouletteCenter roulette;
  late Vector2 center;
  Vector2? lastPanDelta;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(RectangleComponent(
        paint: Paint()..color = Color(0xC8282828),
        size: Vector2.all(1000),
        anchor: Anchor.center
    )
    );


    roulette = RouletteCenter(
      position: center
    );
    add(roulette);
  }

  @override
  void onGameResize(Vector2 size) {
    // TODO: implement onGameResize
    super.onGameResize(size);
    screenSize = size;
    center = screenSize/2;
  }

  @override
  void onPanStart(DragStartInfo info) {
    // TODO: implement onPanStart
    super.onPanStart(info);
    lastPanDelta = null; // Reset last pan delta
    roulette.angularVelocity = 0.0; // Stop any ongoing rotation
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    final previous = info.eventPosition.global - info.delta.global;
    final current = info.eventPosition.global;

    final from = previous - center;
    final to = current - center;

    final double dot = from.dot(to);
    final double cross = from.cross(to);

    final angle = atan2(cross, dot); // Signed angle (in radians)

    roulette.angle += angle;
    lastPanDelta = info.delta.global; 
  }

  @override
  void onPanEnd(DragEndInfo info) {
    // TODO: implement onPanEnd
    super.onPanEnd(info);
    if (lastPanDelta != null) {
    // Use lastEventPosition instead of eventPosition
    final touchVector = info.raw.globalPosition;
    final perp = Vector2(-touchVector.dy, touchVector.dx);
    final rotational = lastPanDelta!.dot(perp.normalized());
    final velocity = rotational / 0.1;
    roulette.angularVelocity = velocity;
  }
  lastPanDelta = null;
  }
}

class RouletteCenter extends PositionComponent {
  RouletteCenter({
    required Vector2 position
  }): super(
      position: position,
      anchor: Anchor.center
  );

  final items = 6;

  final colors = [
    Color(0xFF8A0000),
    Color(0xFFFFECB4)
  ];

  final lastItemColor = Color(0xFF369D53);

  double angularVelocity = 0.0;

  @override
  FutureOr<void> onLoad() {
    for (int i = 0; i < items; i++) {
      final startAngle = (2 * pi / items) * i;
      final sweepAngle = (2 * pi / items);
      final color = (i == items - 1 && items % 2 == 0) ? lastItemColor : colors[i % colors.length];

      final pizzaSlice = PizzaSliceComponent(
        radius: 200,
        startAngle: startAngle,
        sweepAngle: sweepAngle,
        color: color,
        position: Vector2(0, 0),
      );

      add(pizzaSlice);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (angularVelocity.abs() > 0.01) {
      angle += angularVelocity * dt;
      angularVelocity *= 0.98; // Friction
    } else {
      angularVelocity = 0.0;
    }
  }
}

class PizzaSliceComponent extends PositionComponent {
  final double radius;
  final double startAngle; // in radians
  final double sweepAngle; // in radians
  final Paint paintStyle;

  PizzaSliceComponent({
    required this.radius,
    required this.startAngle,
    required this.sweepAngle,
    Color color = const Color(0xFFFFD700), // Pizza yellow
    Vector2? position,
  })  : paintStyle = Paint()..color = color,
        super( );

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    final text = TextBoxComponent(
      text: 'asdftasdsd',
      boxConfig: TextBoxConfig(
        maxWidth: radius,
        margins: EdgeInsets.fromLTRB(radius/2, 0, 0, 0),
      ),
      anchor: Anchor.centerLeft,
      angle: startAngle + (sweepAngle / 2),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    add(text); // inside onLoad or constructor
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final rect = Rect.fromCircle(center: Offset(0, 0), radius: radius);
    canvas.drawArc(rect, startAngle, sweepAngle, true, paintStyle);

    // final path = Path()
    //   ..moveTo(0, 0) // Center of the circle
    //   ..arcTo(
    //     Rect.fromCircle(center: Offset(0, 0), radius: radius),
    //     startAngle,
    //     sweepAngle,
    //     false,
    //   )
    //   ..close();
    // canvas.drawPath(path, paintStyle);


  }
}
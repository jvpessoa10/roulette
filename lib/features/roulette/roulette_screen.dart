

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
  @override
  Future<void> onLoad() async {
    super.onLoad();
    // add(RectangleComponent(
    //     paint: Paint()..color = Color(0xC8282828),
    //     size: Vector2.all(1000),
    //     anchor: Anchor.center
    // )
    // );


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
  void onPanUpdate(DragUpdateInfo info) {
    // TODO: implement onPanUpdate
    final previous = info.eventPosition.global - info.delta.global;
    final current = info.eventPosition.global;

    final from = previous - center;
    final to = current - center;

    final double dot = from.dot(to);
    final double cross = from.cross(to);

    final angle = atan2(cross, dot); // Signed angle (in radians)

    roulette.angle += angle;
  }

  @override
  void onPanEnd(DragEndInfo info) {
    // TODO: implement onPanEnd
    super.onPanEnd(info);
  }
}

class RouletteCenter extends PositionComponent {
  RouletteCenter({
    required Vector2 position
  }): super(
      position: position,
      anchor: Anchor.center
  );


  var elapsedTime = 0.0;

  final numItems = 15;
  
  final colors = [
    Color(0xFF8A0000),
    Color(0xFFFFECB4)
  ];

  final lastItemColor = Color(0xFF369D53);

  @override
  FutureOr<void> onLoad() {

    final spinEffect = RotateEffect.by(
        tau * 100,
        EffectController(
            duration: 10,
            curve: Curves.easeOutQuint,
        )
    );
    // add(spinEffect);

    final pizzaSlice = PizzaSliceComponent(
      radius: 200,
      startAngle: pi/2,
      sweepAngle: (2*pi) / 6,
      position: Vector2(0, 0),
    );

    add(pizzaSlice);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (true) {
      // final rect = Rect.fromCenter(center: Offset.zero, width: 400, height: 400);
      //
      // for (var i =0; i < numItems; i++) {
      //   final startAngle = (tau / numItems) * (i + 1);
      //   final sweepAngle = tau / numItems;
      //
      //   // For a list with an even number of items,
      //   // the last item should be a different color to avoid two items
      //   // with the same color next to each other
      //   final isLastItem = i == numItems - 1;
      //   final evenNumItems = numItems % 2 != 0;
      //   final color = (isLastItem && evenNumItems) ? lastItemColor : colors[i % colors.length];
      //
      //   final itemPaint = Paint()
      //     ..shader = RadialGradient(
      //       colors: [color.brighten(0.1), color.darken(0.1)],
      //       stops: <double>[0.1, 1],
      //     ).createShader(rect);
      //
      //   canvas.drawArc(rect, startAngle, sweepAngle, true, itemPaint);
      // }
      //
      // final outerRect = Rect.fromCenter(center: Offset.zero, width: 410, height: 410);
      // final border = Paint()
      //   ..color = Color(0xFFFFECB4)
      //   ..style = PaintingStyle.stroke
      //   ..strokeWidth = 10;
      //
      // final border2 = Paint()
      //   ..color = Color(0xFF8A0000)
      //   ..style = PaintingStyle.stroke
      //   ..strokeWidth = 5;
      //
      // canvas.drawArc(outerRect, 0, tau, false, border);
      // canvas.drawArc(outerRect, 0, tau, false, border2);
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
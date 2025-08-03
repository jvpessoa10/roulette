

import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
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

class MyGame extends FlameGame with HasCollisionDetection {

  @override
  Color backgroundColor() => const Color(0xFF222222);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(Roulette(
      radius: 200,
      position: size/2,
    ));
  }
}

class Roulette extends PositionComponent with HasCollisionDetection {

  late RouletteCenter rouletteCenter;

  double _radius;

  Roulette({
    required double radius,
    Vector2? position
  }) : 
      _radius = radius,
      super(position: position);

  @override
  FutureOr<void> onLoad() {
    add(DonutComponent(
      outerRadius: 210,
      innerRadius: 200,
      paint: Paint()..color = Color.fromARGB(255, 64, 46, 30),
    ));

    rouletteCenter = RouletteCenter(
      radius: 200
    );
    add(rouletteCenter);

    
    add(
      TriangleComponent(position: Vector2(size.x/2, -_radius)));
  }
}

class RouletteCenter extends PositionComponent with DragCallbacks, CollisionCallbacks {

  double _radius;

  RouletteCenter({
    required double radius
  }): 
      _radius = radius,
      super(size:Vector2.all(radius * 2), anchor: Anchor.center);

  final items = 12;

  final colors = [
    Color(0xFF8A0000),
    Color(0xFFFFECB4)
  ];

  final lastItemColor = Color(0xFF369D53);

  double angularVelocity = 0.0;

  @override
  FutureOr<void> onLoad() {
    debugMode = true;
    for (int i = 0; i < items; i++) {
      final startAngle = (2 * pi / items) * i;
      final sweepAngle = (2 * pi / items);
      final color = (i == items - 1 && items % 2 == 0) ? lastItemColor : colors[i % colors.length];

      final pizzaSlice = PizzaSliceComponent(
        radius: _radius,
        startAngle: startAngle,
        sweepAngle: sweepAngle,
        color: color,
        rouletteCenter: size/2
      );

      add(pizzaSlice);
    }
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    angularVelocity = 0.0;
    print("onDragStart");
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    // TODO: implement onDragUpdate
    final current = event.localEndPosition;
    final previous = current - event.localDelta;

    final from = previous - size/2;
    final to = current - size/2;

    angle += from.angleToSigned(to);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    // TODO: implement onDragEnd
    super.onDragEnd(event);
    
    if (event.velocity.x >= event.velocity.y) {
      angularVelocity = event.velocity.x ;
    } else {
      angularVelocity = event.velocity.y ;
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

class PizzaSliceComponent extends PositionComponent with CollisionCallbacks {
  final double radius;
  final double startAngle; // in radians
  final double sweepAngle; // in radians
  final Color color;
  late Vector2 rouletteCenter;
  final String tileText = 'Roulette${Random().nextInt(100)}';

  PizzaSliceComponent({
    required this.radius,
    required this.startAngle,
    required this.sweepAngle,
    required this.rouletteCenter,
    Color this.color = const Color(0xFFFFD700),
  }) : super();

  @override
  FutureOr<void> onLoad() {
    debugMode = true;
    
    // TODO: implement onLoad
    final text = TextBoxComponent(
      text: tileText,
      position: rouletteCenter,
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

     // Point at start of arc
    final Vector2 p1 = rouletteCenter + Vector2(cos(startAngle), sin(startAngle)) * radius;

    // Point at end of arc
    final Vector2 p2 = rouletteCenter + Vector2(cos(startAngle + sweepAngle), sin(startAngle + sweepAngle)) * radius;

    final hitbox = PolygonHitbox(
      [
        rouletteCenter.clone(),
        p1,
        p2,
      ],
      anchor: Anchor.center
    )..debugMode = true;
    add(hitbox);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final rect = Rect.fromCircle(center: Offset(rouletteCenter.x, rouletteCenter.y), radius: radius);

    final gradient = RadialGradient(
      radius: 0.8,
      focalRadius: 0.01,
      colors: [
        color,
        color.withAlpha(10),
      ]
    );

    final paintStyle = Paint()
          ..shader = gradient.createShader(rect);
      
    canvas.drawArc(rect, startAngle, sweepAngle, true, paintStyle);
  }
}

class DonutComponent extends PositionComponent {
  final double outerRadius;
  final double innerRadius;
  final Paint paint;

  DonutComponent({
    required this.outerRadius,
    required this.innerRadius,
    required this.paint,
    Vector2? position,
    Anchor anchor = Anchor.center,
  }) : super(
    position: position ?? Vector2.zero(),
    anchor: anchor,
  );

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Draw the outer circle (filled)
    canvas.drawCircle(Offset.zero, outerRadius, paint);

    // Draw the border
    final borderPaint = Paint()
      ..color = const Color.fromARGB(255, 89, 69, 50) // or any border color you want
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2; // Adjust thickness as needed
    canvas.drawCircle(Offset.zero, outerRadius, borderPaint);

    // Draw the inner circle with a clear paint to "cut out" the center
    final clearPaint = Paint()
      ..blendMode = BlendMode.clear;
    canvas.drawCircle(Offset.zero, innerRadius, clearPaint);
  }
}

class TriangleComponent extends PolygonComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  
  late final List<Vector2> points;
  String? lastItem;

  TriangleComponent({
    required Vector2 position,
    double size = 20.0,
    Color color = const Color.fromARGB(255, 103, 84, 51),
  }) : super(
          _buildTriangle(size),
          position: position,
          paint: Paint()..color = color,
          anchor: Anchor.center,
        ) {
    points = _buildTriangle(size);
  }

  static List<Vector2> _buildTriangle(double size) {
    return [
      Vector2(0, size),        // Top
      Vector2(-size, -size),     // Bottom left
      Vector2(size, -size),      // Bottom right
    ];
  }

  @override
  FutureOr<void> onLoad() {
    add(
      PolygonHitbox(
        [
      Vector2(0, 40),        // Top
      Vector2(1, 0),     // Bottom left
      Vector2(0, 0),      // Bottom right
    ]
        , position: size/2, anchor: Anchor.center)..debugMode = true,
    );
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is PizzaSliceComponent) {
      lastItem = other.tileText;
      print(lastItem);
    }
  }
}
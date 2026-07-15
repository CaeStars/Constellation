import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import '../pages/home.dart';
import '../pages/star/chromosphere.dart';

final GoRouter router = GoRouter(
  initialLocation: '/chromosphere',
  // TODO: implement error screen
  routes: <RouteBase>[
    GoRoute(
      path: '/chromosphere',
      builder: (BuildContext context, GoRouterState state) {
        return const ChromoMain();
      },
    ),
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Text(
              "you're not supposed to be here.",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    ),
  ],
);

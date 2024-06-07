import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rando_point_deau/features/map/presentation/pages/map_page_wrapper.dart';
import 'package:rando_point_deau/features/onboarding/presentation/cubits/onboarding_cubit/onboarding_cubit.dart';
import 'package:rando_point_deau/features/onboarding/presentation/pages/onboarding_page.dart';

final class AppRouter {
  final OnboardingCubit onboardingCubit;

  AppRouter({
    required this.onboardingCubit,
  });

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static BuildContext get context => navigatorKey.currentContext!;

  static void pop() {
    GoRouter.of(context).pop();
  }

  static void maybePop() {
    if (GoRouter.of(context).canPop()) pop();
  }

  late final router = GoRouter(
    navigatorKey: navigatorKey,
    debugLogDiagnostics: true,
    initialLocation: onboardingRoute,
    refreshListenable: _GoRouterRefreshStream([
      onboardingCubit.stream,
    ]),
    routes: [
      GoRoute(
        path: onboardingPath,
        name: onboardingName,
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: OnboardingPage(),
          );
        },
      ),
      GoRoute(
        path: homePath,
        name: homeName,
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: MapPageWrapper(),
          );
        },
      )
    ],
    redirect: (context, state) {
      if (onboardingCubit.state is OnboardingDone) {
        return homeRoute;
      }
      return onboardingRoute;
    },
  );

  static const onboardingPath = "/onboarding";
  static const onboardingName = "onboarding";
  static const onboardingRoute = onboardingPath;

  static const homePath = "/home";
  static const homeName = "home";
  static const homeRoute = homePath;
}

final class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(List<Stream<dynamic>> streams) {
    notifyListeners();
    for (final stream in streams) {
      _subscriptions.add(
          stream.asBroadcastStream().listen((dynamic _) => notifyListeners()));
    }
  }

  final List<StreamSubscription<dynamic>> _subscriptions = [];

  @override
  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    super.dispose();
  }
}

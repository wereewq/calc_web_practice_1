import 'package:go_router/go_router.dart';
import 'screens/calculator_screen.dart';
import 'screens/converter_screen.dart';
import 'screens/home_screen.dart';
import 'screens/not_found_screen.dart';
import 'screens/result_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/calculator',
      builder: (context, state) => const CalculatorScreen(),
      routes: [
        GoRoute(
          path: 'result',
          builder: (context, state) {
            final q = state.uri.queryParameters;
            return ResultScreen.forCalculator(
              rawA: q['a'],
              rawOp: q['op'],
              rawB: q['b'],
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/converter',
      builder: (context, state) => const ConverterScreen(),
      routes: [
        GoRoute(
          path: 'result',
          builder: (context, state) {
            final q = state.uri.queryParameters;
            return ResultScreen.forConverter(
              from: q['from'],
              to: q['to'],
              amount: q['amount'],
            );
          },
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => NotFoundScreen(
    location: state.uri.toString(),
  ),
);
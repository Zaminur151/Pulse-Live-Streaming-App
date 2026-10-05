import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/splash_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/register_screen.dart';
import '../../features/home/presentation/pages/main_shell.dart';
import '../../features/live/presentation/pages/go_live_screen.dart';
import '../../features/live/presentation/pages/live_broadcast_screen.dart';
import '../../features/live/presentation/pages/watch_live_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const MainShell(),
      ),
      GoRoute(
        path: '/go-live',
        name: 'goLive',
        builder: (context, state) => const GoLiveScreen(),
      ),
      GoRoute(
        path: '/broadcast',
        name: 'broadcast',
        builder: (context, state) => const LiveBroadcastScreen(),
      ),
      GoRoute(
        path: '/watch/:id',
        name: 'watchLive',
        builder: (context, state) {
          final streamId = state.pathParameters['id'] ?? '';
          return WatchLiveScreen(streamId: streamId);
        },
      ),
    ],
  );
}

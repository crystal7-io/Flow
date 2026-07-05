import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/core/models/story.dart';
import 'package:redesigned/core/navigation/root_view.dart';
import 'package:redesigned/core/services/app_service.dart';
import 'package:redesigned/core/services/auth_service.dart';
import 'package:redesigned/core/utils/screen_transitions.dart';
import 'package:redesigned/data/mock_data.dart';
import 'package:redesigned/data/repositories/profile_repository.dart';
import 'package:redesigned/screens/auth_screens/auth_controller_view.dart';
import 'package:redesigned/screens/follow/follow_view.dart';
import 'package:redesigned/screens/follow/follow_view_model.dart';
import 'package:redesigned/screens/home/home_view.dart';
import 'package:redesigned/screens/home/home_view_model.dart';
import 'package:redesigned/screens/messages/messages_view.dart';
import 'package:redesigned/screens/messages/messages_view_model.dart';
import 'package:redesigned/screens/notifications/notifications_view.dart';
import 'package:redesigned/screens/notifications/notifications_view_model.dart';
import 'package:redesigned/screens/profile/profile_view.dart';
import 'package:redesigned/screens/profile/profile_view_model.dart';
import 'package:redesigned/screens/settings/settings_view.dart';
import 'package:redesigned/screens/settings/settings_view_model.dart';
import 'package:redesigned/screens/stories/stories_view.dart';
import 'package:redesigned/screens/stories/stories_view_model.dart';
import 'package:redesigned/screens/story_view/story_view.dart';
import 'package:redesigned/screens/story_view/story_view_model.dart';
import 'package:redesigned/screens/create_post/create_post_view.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/home',
  // Redirect User to Sign-in screen if user is not signed in
  // or if user logs out
  redirect: (context, state) async {
    final authService = context.read<AuthService>();
    final bool loggedIn = await authService.isLoggedIn();
    final bool tryingToSignIn = state.matchedLocation == '/signin';
    final bool tryingToSignUp = state.matchedLocation == '/signup';

    // If the user is NOT logged in AND they are not already trying to sign in/up,
    // redirect them to the sign-in page.
    if (!loggedIn && !tryingToSignIn && !tryingToSignUp) {
      return '/signin';
    }
    return null;
  },
  routes: [
    ShellRoute(
      pageBuilder: (context, state, child) => NoTransitionPage(child: RootView(child: child)),
      routes: [
        GoRoute(
          name: 'home',
          path: '/home',
          pageBuilder: (context, state) => SlideBottomTransitionPage(
            child: ChangeNotifierProvider<HomeViewModel>(
              create: (_) => HomeViewModel(context.read<AppService>()),
              child: const HomeScreen(),
            ),
            state: state,
          ),
        ),
        GoRoute(
          path: '/stories',
          pageBuilder: ((context, state) => SlideBottomTransitionPage(
            state: state,
            child: ChangeNotifierProvider<StoriesViewModel>(
              create: (_) => StoriesViewModel(),
              child: const StoriesView(),
            ),
          )),
        ),
        GoRoute(
          path: '/notification',
          pageBuilder: (context, state) {
            return SlideBottomTransitionPage(
              child: ChangeNotifierProvider<NotificationsViewModel>(
                create: (_) => NotificationsViewModel(),
                child: const NotificationsView(),
              ),
              state: state,
            );
          },
        ),
        GoRoute(
          path: '/messages',
          pageBuilder: (context, state) => SlideBottomTransitionPage(
            child: ChangeNotifierProvider<MessagesViewModel>(
              create: (_) => MessagesViewModel(),
              child: const MessagesView(),
            ),
            state: state,
          ),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => SlideBottomTransitionPage(
            child: ChangeNotifierProvider<SettingsViewModel>(
              create: (_) => SettingsViewModel(context.read<AuthService>()),
              child: const SettingsView(),
            ),
            state: state,
          ),
        ),
      ],
    ),
    GoRoute(path: '/signin', builder: (context, state) => const AuthControllerView()),
    // UPDATE PROFILE PAGE LATER
    // GoRoute(
    //   path: '/profile/:userID',
    //   pageBuilder: ((context, state) => SlideTransitionPage(
    //     state: state,
    //     child: ChangeNotifierProvider<ProfileViewModel>(
    //       create: (_) => ProfileViewModel(
    //         ProfileRepository(state.pathParameters['userID'] as String),
    //       ),
    //       child: const ProfileView(),
    //     ),
    //   )),
    // ),
    GoRoute(
      path: '/follow/:name',
      pageBuilder: ((context, state) {
        String name = state.pathParameters['name'] ?? '';
        return SlideTransitionPage(
          state: state,
          child: ChangeNotifierProvider<FollowViewModel>(
            create: (_) => FollowViewModel(
              name: name,
              followers: followersList,
              following: followersList,
              context: context,
            ),
            child: const FollowView(),
          ),
        );
      }),
    ),
    GoRoute(
      path: '/storyview',
      pageBuilder: ((context, state) {
        var storyGroup = state.extra as StoryGroup;
        return SlideTransitionPage(
          state: state,
          child: ChangeNotifierProvider<StoryViewModel>(
            create: (_) => StoryViewModel(storyGroup),
            child: const StoryView(),
          ),
        );
      }),
    ),
    GoRoute(
      path: '/create-post',
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) =>
          ZoomTransitionPage(child: const CreatePostView(), key: state.pageKey),
    ),
  ],
);

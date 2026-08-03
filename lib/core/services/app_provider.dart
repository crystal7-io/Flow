import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/core/services/app_service.dart';
import 'package:redesigned/core/services/auth_service.dart';
import 'package:redesigned/core/services/navigation_service.dart';
import 'package:redesigned/core/services/user_data_service.dart';
import 'package:redesigned/core/navigation/create_post_transition_provider.dart';
import 'package:redesigned/data/local/local_user_data_source.dart';
import 'package:redesigned/data/remote/comments_data_source.dart';
import 'package:redesigned/data/remote/post_data_source.dart';
import 'package:redesigned/data/remote/remote_user_data_source.dart';
import 'package:redesigned/data/repositories/comment_repository.dart';
import 'package:redesigned/data/repositories/post_repository.dart';
import 'package:redesigned/data/repositories/user_repository.dart';

class AppProvider extends StatelessWidget {
  const AppProvider({super.key, required this.child});
  final Widget child;

  /// User ID to pass to [UserDataService]
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppService>(create: (_) => AppService()),
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider<CreatePostTransitionProvider>(
          create: (_) => CreatePostTransitionProvider(),
        ),
        ChangeNotifierProvider<UserDataService>(
          create: (_) =>
              UserDataService(UserRepository(LocalUserDataSource(), RemoteUserDataSource())),
        ),
        Provider<NavigationService>(create: (_) => NavigationService(context.read<GoRouter>())),

        // Post Repository Provider
        Provider<PostRepository>(create: (_) => PostRepository(PostDataSource())),

        // Comments Repository Provider
        Provider<CommentsRepository>(create: (_) => CommentsRepository(CommentsDataSource())),
      ],
      child: child,
    );
  }
}

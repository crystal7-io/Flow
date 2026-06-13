import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/core/models/models.dart';
import 'package:redesigned/screens/follow/follow_view_model.dart';
import 'package:redesigned/screens/follow/widgets/follow_widget.dart';

class FollowView extends StatelessWidget {
  const FollowView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FollowViewModel>();
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorScheme.surfaceContainerHighest,
          title: Text(viewModel.name),
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: '${viewModel.followers.length} Followers'),
              Tab(text: '${viewModel.following.length} Following'),
              Tab(text: '${viewModel.mutual.length} Mutuals'),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLowest,
          ),
          child: TabBarView(
            children: [
              ListView(
                children: viewModel.followers
                    .map(
                      (e) => Follows(
                        isFollowing: e.isFollowing,
                        person: Person(
                          id: e.id,
                          name: e.name,
                          userName: e.userName,
                          profilePicturePath: e.profilePicturePath,
                        ),
                      ),
                    )
                    .toList(),
              ),
              ListView(
                children: viewModel.following
                    .map(
                      (e) => Follows(
                        isFollowing: e.isFollowing,
                        person: Person(
                          id: e.id,
                          name: e.name,
                          userName: e.userName,
                          profilePicturePath: e.profilePicturePath,
                        ),
                      ),
                    )
                    .toList(),
              ),
              ListView(
                children: viewModel.mutual
                    .map(
                      (e) => Follows(
                        isFollowing: e.isFollowing,
                        person: Person(
                          id: e.id,
                          name: e.name,
                          userName: e.userName,
                          profilePicturePath: e.profilePicturePath,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

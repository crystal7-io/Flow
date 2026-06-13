import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/data/mock_data.dart';
import 'package:redesigned/core/services/app_service.dart';
import 'package:redesigned/screens/follow/widgets/follow_widget.dart';
import 'package:redesigned/screens/profile/profile_view_model.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});
  @override
  State<ProfileView> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileView>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileViewModel>(context, listen: false).getProfileData();
      Provider.of<ProfileViewModel>(context, listen: false).tabController =
          TabController(length: 3, vsync: this);
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: context.watch<ProfileViewModel>().isDataLoaded
          ? NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverToBoxAdapter(
                  child: AppBar(
                    backgroundColor: colorScheme.surface,
                    leading: IconButton(
                      onPressed: () {
                        context.pop();
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    actions: <IconButton>[
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.more_vert),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          // Top Row
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(75),
                              child: CachedNetworkImage(
                                height: 50,
                                width: 50,
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                placeholderFadeInDuration: const Duration(
                                  seconds: 0,
                                ),
                                placeholder: (context, url) => Icon(
                                  Icons.account_circle_rounded,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                                fit: BoxFit.contain,
                                imageUrl: context
                                    .watch<ProfileViewModel>()
                                    .profile!
                                    .profilePicturePath,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context
                                      .watch<ProfileViewModel>()
                                      .profile!
                                      .name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      context
                                          .watch<ProfileViewModel>()
                                          .profile!
                                          .userName,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: colorScheme.onSurfaceVariant,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0,
                                      ),
                                    ),
                                    IconButton(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      onPressed: () {},
                                      icon: const Icon(Icons.copy, size: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (context
                            .watch<ProfileViewModel>()
                            .profile!
                            .pronouns
                            .isNotEmpty)
                          Text(
                            context.watch<ProfileViewModel>().profile!.pronouns,
                            style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        if (context
                            .watch<ProfileViewModel>()
                            .profile!
                            .bio
                            .isNotEmpty)
                          Text(
                            context.watch<ProfileViewModel>().profile!.bio,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            displays(
                              24,
                              "Posts",
                              colorScheme.primary,
                              colorScheme.onSurfaceVariant,
                              () {},
                            ),
                            displays(
                              13600,
                              "Followers",
                              colorScheme.primary,
                              colorScheme.onSurfaceVariant,
                              () {
                                kIsWeb
                                    ? showDialog(
                                        context: context,
                                        builder: (BuildContext context) => SimpleDialog(
                                          insetPadding: EdgeInsets.only(
                                            right:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width /
                                                2,
                                          ),
                                          elevation: 10,
                                          backgroundColor: colorScheme
                                              .surfaceContainerLowest,
                                          title: const Text("Followers"),
                                          children: [
                                            SizedBox(
                                              height:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.height -
                                                  350,
                                              width: 300,
                                              child:
                                                  context
                                                      .watch<ProfileViewModel>()
                                                      .profile!
                                                      .followerIDs
                                                      .isEmpty
                                                  ? const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            vertical: 8,
                                                            horizontal: 24,
                                                          ),
                                                      child: Text(
                                                        "No Followers yet",
                                                      ),
                                                    )
                                                  : ListView(
                                                      children: context
                                                          .watch<
                                                            ProfileViewModel
                                                          >()
                                                          .profile!
                                                          .followerIDs
                                                          .map(
                                                            (e) => Follows(
                                                              isFollowing: context
                                                                  .watch<
                                                                    AppService
                                                                  >()
                                                                  .isUserNameFollowing(
                                                                    e,
                                                                  ),
                                                              person:
                                                                  getPersonFromUserName(
                                                                    e,
                                                                  ),
                                                            ),
                                                          )
                                                          .toList(),
                                                    ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                  ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("Done"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : context.push(
                                        '/follow/${context.watch<ProfileViewModel>().profile!.name}',
                                      );
                              },
                            ),
                            displays(
                              32,
                              "Following",
                              colorScheme.primary,
                              colorScheme.onSurfaceVariant,
                              () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      SimpleDialog(
                                        backgroundColor:
                                            colorScheme.surfaceContainerLow,
                                        title: const Text("Following"),
                                        children: [
                                          LimitedBox(
                                            maxHeight:
                                                MediaQuery.of(
                                                  context,
                                                ).size.height -
                                                350,
                                            child: Column(
                                              children: context
                                                  .watch<ProfileViewModel>()
                                                  .profile!
                                                  .followingIDs
                                                  .map(
                                                    (e) => Follows(
                                                      isFollowing: context
                                                          .watch<AppService>()
                                                          .isUserNameFollowing(
                                                            e,
                                                          ),
                                                      person:
                                                          getPersonFromUserName(
                                                            e,
                                                          ),
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Done"),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              // Following/Follow Buttons
                              child: SizedBox(
                                height: 40,
                                child:
                                    context
                                        .watch<ProfileViewModel>()
                                        .profile!
                                        .isFollowing
                                    ? FilledButton.tonalIcon(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                colorScheme
                                                    .surfaceContainerHighest,
                                              ),
                                        ),
                                        icon: const Icon(
                                          Icons.remove_circle_outline,
                                        ),
                                        onPressed: context
                                            .watch<ProfileViewModel>()
                                            .toggleFollow,
                                        label: const Text("Unfollow"),
                                      )
                                    : FilledButton.icon(
                                        onPressed: context
                                            .watch<ProfileViewModel>()
                                            .toggleFollow,
                                        icon: const Icon(Icons.add),
                                        label: const Text("Follow"),
                                      ),
                              ),
                            ),
                            // const SizedBox(width: 16),
                            // Expanded(
                            //     // Following/Follow Buttons
                            //     child: SizedBox(
                            //         height: 40,
                            //         child: context
                            //                 .watch<ProfileViewModel>()
                            //                 .profile!
                            //                 .isFollowing
                            //             ? OutlinedButton.icon(
                            //                 icon: const Icon(Icons
                            //                     .person_remove_outlined),
                            //                 onPressed: () {
                            //                   setState(() {
                            //                     _isFriend = !_isFriend;
                            //                   });
                            //                   MainApp.of(context)
                            //                       .myFriends
                            //                       .forEach((element) {
                            //                     if (element.userName ==
                            //                         context
                            //                             .watch<
                            //                                 ProfileViewModel>()
                            //                             .profile!
                            //                             .userName) {
                            //                       MainApp.of(context)
                            //                           .myFriends
                            //                           .remove(element);
                            //                     }
                            //                   });
                            //                 },
                            //                 label: const Text("Unfriend"))
                            //             : FilledButton.tonalIcon(
                            //                 onPressed: () {
                            //                   setState(() {
                            //                     _isFriend = !_isFriend;
                            //                   });
                            //                   MainApp.of(context)
                            //                       .myFriends
                            //                       .add(Person(
                            //                           name: widget
                            //                               .acc.person.name,
                            //                           userName: widget.acc
                            //                               .person.userName,
                            //                           pfpPath: widget.acc
                            //                               .person.pfpPath));
                            //                 },
                            //                 icon: const Icon(Icons
                            //                     .person_add_alt_1_outlined),
                            //                 label: const Text("Friend")))),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
                // SliverToBoxAdapter(
                //   child: TabBar(
                //       controller:
                //           context.watch<ProfileViewModel>().tabController,
                //       tabs: const [
                //         Tab(
                //           text: 'Posts',
                //           icon: Icon(
                //             Symbols.grid_view,
                //             weight: 700,
                //           ),
                //         ),
                //         Tab(
                //           text: 'Reels',
                //           icon: Icon(
                //             Symbols.movie,
                //             weight: 700,
                //           ),
                //         ),
                //         Tab(
                //           text: 'Live',
                //           icon: Icon(
                //             Symbols.cast,
                //             weight: 700,
                //           ),
                //         ),
                //       ]),
                // )
              ],
              body: const Padding(
                padding: EdgeInsets.only(top: 6),
                child: SizedBox(),
                // TabBarView(
                //     controller: context.watch<ProfileViewModel>().tabController,
                //     children: [
                //       dummyPost(Theme.of(context).colorScheme.primaryContainer),
                //       dummyPost(Theme.of(context).colorScheme.outlineVariant),
                //       dummyPost(
                //           Theme.of(context).colorScheme.surfaceContainerHighest),
                //     ]),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

Widget dummyPost(Color color) => GridView.count(
  crossAxisSpacing: 4,
  mainAxisSpacing: 4,
  physics: const NeverScrollableScrollPhysics(),
  shrinkWrap: true,
  crossAxisCount: 3,
  children: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
      .map(
        (e) => SizedBox.square(
          child: GestureDetector(
            onTap: () {},
            child: Container(decoration: BoxDecoration(color: color)),
          ),
        ),
      )
      .toList(),
);

Widget displays(
  int data,
  String name,
  Color primary,
  Color onVariant,
  void Function()? onTap,
) => InkWell(
  borderRadius: BorderRadius.circular(15),
  onTap: onTap,
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: Column(
      children: [
        Text(
          data.toString().length > 3
              ? "${data.toString().substring(0, data.toString().length - 3)}.${data.toString()[data.toString().length - 3]}K"
              : data.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: primary,
          ),
        ),
        SizedBox(
          height: 25,
          child: Text(
            name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: onVariant,
            ),
          ),
        ),
      ],
    ),
  ),
);

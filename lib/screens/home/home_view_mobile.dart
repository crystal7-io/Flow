import 'package:androidx_graphics_shapes/material_shapes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart' hide ShimmerEffect;
import 'package:google_fonts/google_fonts.dart';
import 'package:material_3p/material_loading_indicator.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/screens/home/home_view_model.dart';
import 'package:redesigned/core/models/models.dart';
import 'package:redesigned/screens/search/search_view_model.dart';
import 'package:redesigned/widgets/utils/open_container.dart';
import 'package:redesigned/widgets/post_widget.dart';
import 'package:redesigned/core/services/app_service.dart';
import 'package:redesigned/screens/search/search_view.dart';
import 'package:redesigned/widgets/utils/wave_divider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MobileHomeView extends StatelessWidget {
  final BoxConstraints constraints;
  const MobileHomeView({super.key, required this.constraints});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    return Scaffold(
      appBar: null,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          physics: viewModel.isLoading
              ? NeverScrollableScrollPhysics()
              : viewModel.allowRefresh
              ? const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics())
              : const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          controller: viewModel.scrollController,
          slivers: [
            SliverAppBar(
              toolbarHeight: 72,
              forceMaterialTransparency: true,
              floating: context.watch<AppService>().isSearchFloating,
              title: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SizedBox(
                  height: 64,
                  child: OpenContainer(
                    closedElevation: 0,
                    closedColor: Theme.of(context).colorScheme.surfaceContainer,
                    openColor: Theme.of(context).colorScheme.surfaceContainerLow,
                    closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(55)),
                    useRootNavigator: true,
                    closedBuilder: (context, action) => _buildSearchBar(context, viewModel, action),

                    openBuilder: (context, action) => ChangeNotifierProvider<SearchViewModel>(
                      create: (_) => SearchViewModel(),
                      child: const SearchView(),
                    ),
                  ),
                ),
              ),
            ),
            CupertinoSliverRefreshControl(
              builder:
                  (
                    context,
                    refreshState,
                    pulledExtent,
                    refreshTriggerPullDistance,
                    refreshIndicatorExtent,
                  ) {
                    // Check if the control is currently actively refreshing or armed to refresh
                    final isRefreshing =
                        refreshState == RefreshIndicatorMode.refresh ||
                        refreshState == RefreshIndicatorMode.armed;

                    return Center(
                      child: SizedBox(
                        height: 48,
                        width: 48,
                        child: isRefreshing
                            ? IndeterminateLoadingIndicator(
                                contained: true,
                                indicatorPolygons: [
                                  MaterialShapes.clover4Leaf,
                                  MaterialShapes.pill,
                                  MaterialShapes.cookie4Sided,
                                  MaterialShapes.oval,
                                  MaterialShapes.circle,
                                ],
                              )
                            : const SizedBox.shrink(), // Empty space while pulling until triggered
                      ),
                    );
                  },
              onRefresh: () async {
                await viewModel.refreshFeed().then((value) async {
                  Future.delayed(Duration(milliseconds: 300)).then((value) {
                    if (context.mounted) {
                      context.read<AppService>().setNavBarVisible(true);
                    }
                  });
                });
              },
            ),
            viewModel.isLoading
                ? SliverList.list(
                    children: [
                      SizedBox(height: 16),
                      Skeletonizer(
                        effect: ShimmerEffect(
                          baseColor: ColorScheme.of(context).surfaceContainer,
                          highlightColor: ColorScheme.of(context).surfaceContainerHighest,
                          duration: Duration(milliseconds: 1500),
                        ),
                        enabled: true,
                        child: MobilePostSkeleton(),
                      ),
                      SizedBox(height: 16),
                      Skeletonizer(
                        effect: ShimmerEffect(
                          baseColor: ColorScheme.of(context).surfaceContainer,
                          highlightColor: ColorScheme.of(context).surfaceContainerHighest,
                          duration: Duration(milliseconds: 1500),
                        ),
                        enabled: true,
                        child: MobilePostSkeleton(),
                      ),
                      SizedBox(height: 16),
                      Skeletonizer(
                        effect: ShimmerEffect(
                          baseColor: ColorScheme.of(context).surfaceContainer,
                          highlightColor: ColorScheme.of(context).surfaceContainerHighest,
                          duration: Duration(milliseconds: 1500),
                        ),
                        enabled: true,
                        child: MobilePostSkeleton(),
                      ),
                    ],
                  )
                //  SliverFillRemaining(
                //     child: Center(
                //       child: SizedBox(
                //         height: 48,
                //         width: 48,
                //         child: IndeterminateLoadingIndicator(
                //           contained: true,
                //           indicatorPolygons: [
                //             MaterialShapes.clover4Leaf,
                //             MaterialShapes.pill,
                //             MaterialShapes.cookie4Sided,
                //             MaterialShapes.oval,
                //             MaterialShapes.circle,
                //           ],
                //         ),
                //       ),
                //     ),
                //   )
                : SliverList.separated(
                    separatorBuilder: (context, index) =>
                        Padding(
                              padding: .symmetric(
                                vertical: 16,
                                horizontal: MediaQuery.widthOf(context) / 2 - 76,
                              ),
                              child: WavyDivider(thickness: 2),
                            )
                            .animate()
                            .fadeIn(duration: const Duration(milliseconds: 250))
                            .moveY(
                              begin: 24,
                              end: 0,
                              duration: const Duration(milliseconds: 300),
                              curve: Easing.standardDecelerate,
                            ),
                    itemCount: viewModel.posts.length + 1,
                    // physics: const NeverScrollableScrollPhysics(),
                    // shrinkWrap: true,
                    itemBuilder: (context, index) {
                      // Return the loading indicator if scroll down to fetch is triggerd
                      if (index == viewModel.posts.length) {
                        return viewModel.hasMoreData
                            ? Padding(
                                padding: const EdgeInsets.symmetric(vertical: 24),
                                child: Center(
                                  child: IndeterminateLoadingIndicator(
                                    contained: true,
                                    indicatorPolygons: [
                                      MaterialShapes.clover4Leaf,
                                      MaterialShapes.pill,
                                      MaterialShapes.cookie4Sided,
                                      MaterialShapes.oval,
                                      MaterialShapes.circle,
                                    ],
                                  ),
                                ),
                              )
                            : Padding(
                                padding: .all(16),
                                child: Center(
                                  child: Text(
                                    "Well...that's the end",
                                    style: GoogleFonts.sendFlowers(
                                      // fontWeight: .w900,
                                      color: ColorScheme.of(context).onSurfaceVariant,
                                      fontSize: 24,
                                      // fontFamily: "Google Sans Flex",
                                      // fontVariations: [.weight(500), .new("ROND", 100), .width(60)],
                                    ),
                                  ),
                                ),
                              );
                      }
                      Post p = viewModel.posts[index];
                      return MobilePost(post: p, key: Key(p.postId.toString()))
                          .animate()
                          .fadeIn(duration: const Duration(milliseconds: 250))
                          .moveY(
                            begin: 24,
                            end: 0,
                            duration: const Duration(milliseconds: 300),
                            curve: Easing.standardDecelerate,
                          );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, HomeViewModel viewModel, void Function() action) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: InkWell(
        onTap: () {
          viewModel.onSearchTap();
          action();
        },
        child: Padding(
          padding: EdgeInsetsGeometry.only(left: 18, right: 12),
          child: Row(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Symbols.search,
                    opticalSize: 24,
                    weight: 400,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 14),
                  Text(
                    "Search Flow",
                    style: TextStyle(
                      fontFamily: "Google Sans Flex",
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 16,
                      fontVariations: [.weight(500)],
                    ),
                  ),
                ],
              ),
              Spacer(),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: CachedNetworkImage(
                  height: 40,
                  width: 40,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  placeholderFadeInDuration: const Duration(seconds: 0),
                  placeholder: (context, url) => Icon(
                    Icons.account_circle_rounded,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  fit: BoxFit.cover,
                  imageUrl: viewModel.profilePictureLink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MobilePostSkeleton extends StatelessWidget {
  const MobilePostSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Header
          Row(
            children: [
              Skeleton.leaf(
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: ColorScheme.of(context).surfaceContainer,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    height: 14,
                    color: ColorScheme.of(context).surfaceContainer,
                  ),
                  const SizedBox(height: 6),
                  Container(width: 80, height: 12, color: ColorScheme.of(context).surfaceContainer),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Main Post Image
          Skeleton.leaf(
            child: Container(
              height: MediaQuery.widthOf(context),
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorScheme.of(context).surfaceContainer,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Caption Lines
          Container(
            width: double.infinity,
            height: 16,
            color: ColorScheme.of(context).surfaceContainer,
          ),
          const SizedBox(height: 6),
          Container(width: 150, height: 16, color: ColorScheme.of(context).surfaceContainer),
          const SizedBox(height: 20),

          // Footer (Date & Interaction Buttons)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 80, height: 14, color: ColorScheme.of(context).surfaceContainer),
              Row(
                children: [
                  Skeleton.leaf(
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: ColorScheme.of(context).surfaceContainer,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Skeleton.leaf(
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: ColorScheme.of(context).surfaceContainer,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Skeleton.leaf(
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: ColorScheme.of(context).surfaceContainer,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SafeBouncingScrollPhysics extends BouncingScrollPhysics {
  const SafeBouncingScrollPhysics({super.parent});

  @override
  SafeBouncingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SafeBouncingScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    // velocity < 0 means the user is flinging UP towards the top of the screen (offset decreasing)
    if (velocity < 0 && position.pixels > 0) {
      // Create a temporary clamping physics instance to calculate a non-bouncing stop
      const clamping = ClampingScrollPhysics();
      return clamping.createBallisticSimulation(position, velocity);
    }

    // Otherwise, let it bounce normally for slow intentional drags at the top
    return super.createBallisticSimulation(position, velocity);
  }
}

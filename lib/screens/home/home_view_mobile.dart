import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/screens/home/home_view_model.dart';
import 'package:redesigned/core/models/models.dart';
import 'package:redesigned/screens/search/search_view_model.dart';
import 'package:redesigned/widgets/utils/open_container.dart';
import 'package:redesigned/widgets/post_widget.dart';
import 'package:redesigned/core/services/app_service.dart';
import 'package:redesigned/screens/search/search_view.dart';

class MobileHomeView extends StatelessWidget {
  final BoxConstraints constraints;
  const MobileHomeView({super.key, required this.constraints});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    return Scaffold(
      appBar: null,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              toolbarHeight: 63,
              forceMaterialTransparency: true,
              floating: context.watch<AppService>().isSearchFloating,
              title: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SizedBox(
                  height: 55,
                  child: OpenContainer(
                    closedElevation: 0,
                    closedColor: Theme.of(context).colorScheme.surfaceContainer,
                    openColor:
                        Theme.of(context).colorScheme.surfaceContainerLow,
                    closedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55)),
                    useRootNavigator: true,
                    closedBuilder: (context, action) => Material(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: InkWell(
                          onTap: () {
                            viewModel.onSearchTap();
                            action();
                          },
                          child: Padding(
                            padding: EdgeInsetsGeometry.symmetric(
                                horizontal: 20, vertical: 12),
                            child: Row(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Symbols.search,
                                      opticalSize: 24,
                                      weight: 400,
                                    ),
                                    SizedBox(
                                      width: 14,
                                    ),
                                    Text("Search Flow")
                                  ],
                                ),
                                Spacer(),
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  child: CachedNetworkImage(
                                    height: 36,
                                    width: 36,
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    placeholderFadeInDuration:
                                        const Duration(seconds: 0),
                                    placeholder: (context, url) => Icon(
                                      Icons.account_circle_rounded,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                    fit: BoxFit.contain,
                                    imageUrl: viewModel.profilePictureLink,
                                  ),
                                )
                              ],
                            ),
                          )),
                    ),
                    //  SearchBar(
                    //   elevation: const WidgetStatePropertyAll(0),
                    //   shadowColor:
                    //       const WidgetStatePropertyAll(Colors.transparent),
                    //   backgroundColor: WidgetStatePropertyAll(Theme.of(context)
                    //       .colorScheme
                    //       .surfaceContainerHighest),
                    //   padding: const WidgetStatePropertyAll(
                    //       EdgeInsets.symmetric(horizontal: 16)),
                    //   leading: const Icon(
                    //     Symbols.search,
                    //     opticalSize: 24,
                    //     weight: 400,
                    //   ),
                    //   trailing: <Widget>[
                    //     Tooltip(
                    //       message: 'Change brightness mode',
                    //       child: IconButton(
                    //         icon: const Icon(Icons.mic_none_outlined),
                    //         onPressed: viewModel.onMicPressed,
                    //         selectedIcon:
                    //             const Icon(Icons.brightness_2_outlined),
                    //       ),
                    //     ),
                    //     ClipRRect(
                    //       borderRadius:
                    //           const BorderRadius.all(Radius.circular(20)),
                    //       child: CachedNetworkImage(
                    //         height: 36,
                    //         width: 36,
                    //         errorWidget: (context, url, error) =>
                    //             const Icon(Icons.error),
                    //         placeholderFadeInDuration:
                    //             const Duration(seconds: 0),
                    //         placeholder: (context, url) => Icon(
                    //           Icons.account_circle_rounded,
                    //           color: Theme.of(context)
                    //               .colorScheme
                    //               .onSurfaceVariant,
                    //         ),
                    //         fit: BoxFit.contain,
                    //         imageUrl: viewModel.profilePictureLink,
                    //       ),
                    //     )
                    //   ],
                    //   hintStyle: WidgetStatePropertyAll(TextStyle(
                    //       color: Theme.of(context).colorScheme.onSurfaceVariant,
                    //       fontSize: 16,
                    //       letterSpacing: 0.5,
                    //       fontWeight: FontWeight.w500)),
                    //   hintText: "Search Flow",
                    //   textStyle:
                    //       const WidgetStatePropertyAll(TextStyle(height: 1.2)),
                    //   onTap: () {
                    //     viewModel.onSearchTap();
                    //     action();
                    //   },
                    // ),

                    openBuilder: (context, action) =>
                        ChangeNotifierProvider<SearchViewModel>(
                      create: (_) => SearchViewModel(),
                      child: const SearchView(),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ListView.separated(
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemCount: viewModel.posts.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            Post p = viewModel.posts[index];
                            return MobilePost(post: p);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

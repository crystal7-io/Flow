import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/screens/home/home_view_model.dart';
import 'package:redesigned/core/models/models.dart';
import 'package:redesigned/screens/search/search_view_model.dart';
import 'package:redesigned/widgets/utils/open_container.dart';
import 'package:redesigned/widgets/post_widget.dart';
import 'package:redesigned/core/services/app_service.dart';
import 'package:redesigned/screens/search/search_view.dart';
import 'package:redesigned/widgets/utils/sine_wave_divider.dart';
import 'package:redesigned/widgets/utils/wave_divider.dart';

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
            SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: []),
                      ),
                      const SizedBox(height: 8),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 8),
                      //   child:
                      ListView.separated(
                        separatorBuilder: (context, index) => Padding(
                          padding: .symmetric(
                            vertical: 16,
                            horizontal: MediaQuery.widthOf(context) / 2 - 76,
                          ),
                          child: WavyDivider(thickness: 2),
                        ),
                        itemCount: viewModel.posts.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          Post p = viewModel.posts[index];
                          return MobilePost(post: p);
                        },
                      ),
                      // ),
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

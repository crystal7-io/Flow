import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/screens/home/home_view_model.dart';
import 'package:redesigned/screens/home/home_data.dart';
import 'package:redesigned/screens/home/stories_sheet_view.dart';
import 'package:side_sheet/side_sheet.dart';
import 'package:redesigned/widgets/post/desktop_post.dart';

class DesktopHomeView extends StatefulWidget {
  const DesktopHomeView({super.key});

  @override
  State<DesktopHomeView> createState() => _DesktopHomeViewState();
}

class _DesktopHomeViewState extends State<DesktopHomeView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SearchBar(
                    shadowColor: const WidgetStatePropertyAll(Colors.transparent),
                    leading: IconButton(
                      onPressed: null,
                      icon: const Icon(Symbols.search, weight: 600),
                      disabledColor: Theme.of(context).colorScheme.onSurface,
                    ),
                    trailing: [
                      IconButton(
                        onPressed: viewModel.onMicPressed,
                        icon: const Icon(Icons.mic_none_outlined),
                      ),
                    ],
                    hintText: "Search Flow",
                    onTap: viewModel.onSearchTap,
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 40,
                        child: FilledButton.tonalIcon(
                          onPressed: viewModel.onSwitchButtonPressed,
                          icon: const Icon(Icons.sync_alt_outlined),
                          label: const Text("Switch"),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: CachedNetworkImage(
                          height: 64,
                          width: 64,
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                          placeholderFadeInDuration: const Duration(seconds: 0),
                          placeholder: (context, url) => Icon(
                            Icons.account_circle_rounded,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          fit: BoxFit.contain,
                          imageUrl: viewModel.profilePictureLink,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ListView.separated(
                          separatorBuilder: (context, index) => const SizedBox(height: 8),
                          itemCount: viewModel.posts.length,
                          itemBuilder: ((context, index) => index == 0
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Explore",
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        constraints.maxWidth < 1000
                                            ? SizedBox(
                                                height: 40,
                                                child: TextButton.icon(
                                                  onPressed: () => SideSheet.right(
                                                    width: 400,
                                                    sheetBorderRadius: 14,
                                                    context: context,
                                                    body: StoriesSheetView(viewModel: viewModel),
                                                  ),
                                                  icon: const Icon(Icons.chevron_left),
                                                  label: const Text("Stories"),
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                    const SizedBox(height: 14),
                                    Wrap(
                                      spacing: 8,
                                      children: Filters.values
                                          .map(
                                            (e) => FilterChip(
                                              color: const WidgetStatePropertyAll(
                                                Colors.transparent,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.outlineVariant,
                                                ),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              label: Text(e.name),
                                              selected: viewModel.selectedFilters.contains(e),
                                              onSelected: (selected) {
                                                viewModel.toggleFilter(e, selected);
                                              },
                                            ),
                                          )
                                          .toList(),
                                    ),
                                    const SizedBox(height: 22),
                                  ],
                                )
                              : DesktopPost(post: viewModel.posts[index])),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    constraints.maxWidth > 1000
                        ? StoriesSheetView(viewModel: viewModel)
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

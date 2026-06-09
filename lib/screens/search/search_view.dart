import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/screens/search/search_view_model.dart';
import 'package:redesigned/widgets/profile_avatar.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SearchViewModel>();
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: ListView(
        children: [
          TextField(
            controller: viewModel.searchController,
            onChanged: viewModel.onSearchChanged,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 22,
                horizontal: 4,
              ),
              filled: true,
              fillColor: colorScheme.surface,
              prefixIcon: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
              ),
              hintText: "Search Flow",
              suffixIcon: IconButton(
                onPressed: viewModel.onClearSearch,
                icon: const Icon(Icons.clear),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 6),
                ...viewModel.filters.map(
                  (element) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      label: Text(element),
                      onSelected: (value) {},
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Header(text: "Recent"),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Material(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(24),
              color: colorScheme.surfaceContainer,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: viewModel.recents
                    .map((element) => RecentItem(title: element))
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Header(text: "Profiles"),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: viewModel.profiles
                  .map(
                    (element) => Padding(
                      padding: const EdgeInsets.all(12),
                      child: ProfileAvatarTouchable(
                        person: element.person,
                        onTap: () {},
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          const Header(text: "Posts"),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GridView.count(
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 3,
              children: List.generate(21, (index) => index)
                  .map(
                    (e) => SizedBox.square(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class RecentItem extends StatelessWidget {
  const RecentItem({super.key, required this.title});
  final dynamic title;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      onTap: () {},
      title: Text(title),
      leading: const Icon(Icons.history),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 22),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.outline,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

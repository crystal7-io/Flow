import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/core/models/person.dart';
import 'package:redesigned/screens/messages/search/search_message_view_model.dart';

class SearchMessageView extends StatelessWidget {
  const SearchMessageView({super.key});

  Widget _header(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SearchMessageViewModel>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: SafeArea(
          child: TextField(
            style: const TextStyle(
              height: 1.5,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 24,
                horizontal: 8,
              ),
              hintText: "Search Messages",
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.5,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: IconButton(
                  onPressed: () => viewModel.onBackPress(context),
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          _header(context, "Recent"),
          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: viewModel.recents
                  .map((e) => SuggestedWidget(person: e))
                  .toList(),
            ),
          ),
          const SizedBox(height: 8),
          _header(context, "Suggested"),
          ...viewModel.suggested.map(
            (e) => ListTile(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 12,
              ),
              onTap: () => viewModel.toggleSelection(e.userName),
              title: Text(e.name),
              subtitle: Text(e.userName),
              leading: CircleAvatar(
                child: CachedNetworkImage(
                  height: 50,
                  width: 50,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  placeholderFadeInDuration: const Duration(seconds: 0),
                  placeholder: (context, url) => Icon(
                    Icons.account_circle_rounded,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  fit: BoxFit.contain,
                  imageUrl: e.profilePicturePath,
                ),
              ),
              trailing: viewModel.selectedUserNames.contains(e.userName)
                  ? const CircleAvatar(
                      radius: 16,
                      child: Icon(Symbols.done, weight: 800, size: 18),
                    )
                  : const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}

class SuggestedWidget extends StatelessWidget {
  const SuggestedWidget({super.key, required this.person});
  final Person person;
  @override
  Widget build(BuildContext context) {
    const double size = 64;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(size),
            child: CachedNetworkImage(
              height: size,
              width: size,
              errorWidget: (context, url, error) => const Icon(Icons.error),
              placeholderFadeInDuration: const Duration(seconds: 0),
              placeholder: (context, url) => Icon(
                Icons.account_circle_rounded,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              fit: BoxFit.contain,
              imageUrl: person.profilePicturePath,
            ),
          ),
          const SizedBox(height: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: size),
            child: Text(
              overflow: TextOverflow.ellipsis,
              person.name,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

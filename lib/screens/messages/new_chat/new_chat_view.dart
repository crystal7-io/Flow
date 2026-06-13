import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/core/models/person.dart';
import 'package:redesigned/data/mock_data.dart';
import 'package:redesigned/screens/messages/new_chat/new_chat_view_model.dart';

class NewChatView extends StatelessWidget {
  const NewChatView({super.key});

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
    final viewModel = context.watch<NewChatViewModel>();

    return Scaffold(
      floatingActionButton: AnimatedSwitcher(
        duration: Durations.medium2,
        reverseDuration: Durations.short3,
        switchInCurve: Easing.emphasizedDecelerate,
        switchOutCurve: Easing.emphasizedAccelerate,
        transitionBuilder: (child, animation) => ScaleTransition(
          alignment: Alignment.bottomRight,
          scale: animation,
          child: child,
        ),
        child: viewModel.selectedUserNames.isNotEmpty
            ? FloatingActionButton.extended(
                label: const Text("Chat"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewGroupScreen(
                        participantsList: viewModel.selectedUserNames,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
              )
            : const SizedBox(),
      ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => viewModel.onBackPress(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("New Chat"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SearchBar(
              controller: viewModel.searchController,
              onChanged: (text) {
                // Trigger rebuild to update shownAccounts
                (context as Element).markNeedsBuild();
              },
              leading: const SizedBox(
                width: 40,
                child: Icon(Symbols.search, weight: 600, size: 22),
              ),
              shadowColor: const WidgetStatePropertyAll(Colors.transparent),
              hintText: "Search people",
            ),
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          viewModel.selectedUserNames.isEmpty
              ? const SizedBox()
              : _header(context, "Selected"),
          AnimatedSize(
            curve: Easing.emphasizedDecelerate,
            duration: Durations.medium4,
            clipBehavior: Clip.none,
            child: viewModel.selectedUserNames.isEmpty
                ? const SizedBox()
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: viewModel.selectedUserNames
                        .map(
                          (e) => TweenAnimationBuilder<double>(
                            curve: Easing.emphasizedDecelerate,
                            tween: Tween(begin: 80, end: 180),
                            duration: Durations.medium3,
                            builder: (context, double size, child) =>
                                ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: size),
                                  child: Chip(
                                    deleteIcon: const Icon(
                                      Icons.close,
                                      size: 16,
                                    ),
                                    onDeleted: () =>
                                        viewModel.removeSelection(e),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    label: Text(
                                      e,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    avatar: CircleAvatar(
                                      child: CachedNetworkImage(
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                        placeholderFadeInDuration:
                                            const Duration(seconds: 0),
                                        fit: BoxFit.contain,
                                        imageUrl: getAccountFromUserName(
                                          e,
                                        ).person.profilePicturePath,
                                      ),
                                    ),
                                  ),
                                ),
                          ),
                        )
                        .toList(),
                  ),
          ),
          _header(
            context,
            viewModel.searchController.text.isEmpty ? "Suggested" : "Results",
          ),
          ...viewModel.shownAccounts.map(
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
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  placeholderFadeInDuration: const Duration(seconds: 0),
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
          const SizedBox(height: 64),
        ],
      ),
    );
  }
}

class NewGroupScreen extends StatelessWidget {
  const NewGroupScreen({super.key, required this.participantsList});
  final List<String> participantsList;

  @override
  Widget build(BuildContext context) {
    List<Person> participants = [];
    for (var element in participantsList) {
      participants.add(getAccountFromUserName(element).person);
    }
    return Scaffold(
      floatingActionButton: SizedBox(
        height: 45,
        child: FilledButton(
          onPressed: () {},
          child: const Text("Create Group"),
        ),
      ),
      appBar: AppBar(title: const Text("New Group"), toolbarHeight: 64),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Group name",
              ),
            ),
            const SizedBox(height: 18),
            Text(
              "Participants",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 16,
              alignment: WrapAlignment.spaceBetween,
              children: participants
                  .map((e) => MemberWidget(person: e))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class MemberWidget extends StatelessWidget {
  const MemberWidget({super.key, required this.person});
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
              height: 80,
              width: 80,
              errorWidget: (context, url, error) => const Icon(Icons.error),
              placeholderFadeInDuration: const Duration(seconds: 0),
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
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

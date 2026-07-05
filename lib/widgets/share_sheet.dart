import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:redesigned/core/models/person.dart';
import 'package:redesigned/core/utils/dynamic_avatar_clipper.dart';
import 'package:redesigned/data/mock_data.dart';

class ShareSheet extends StatefulWidget {
  const ShareSheet({super.key, required this.controller});
  final ScrollController controller;

  @override
  State<ShareSheet> createState() => _ShareSheetState();
}

class _ShareSheetState extends State<ShareSheet> {
  // Changed to Set for O(1) lookups instead of O(N) List lookups
  final Set<String> selected = {};
  late final List<Person> people;

  @override
  void initState() {
    super.initState();
    // Cache the lookup once so the builder doesn't re-run O(N) loops on scroll
    people = recentlySent.map((username) => getPersonFromUserName(username)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: SearchBar(
            leading: Icon(Symbols.search, weight: 600),
            hintText: "Share with people",
            elevation: WidgetStatePropertyAll(0),
            padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16, vertical: 4)),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.separated(
            clipBehavior: Clip.hardEdge,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            controller: widget.controller,
            itemCount: people.length,
            separatorBuilder: (context, index) => const SizedBox(height: 2),
            itemBuilder: (context, index) {
              final p = people[index];
              final isSelected = selected.contains(p.userName);

              return ShareTile(
                person: p,
                isSelected: isSelected,
                index: index,
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selected.remove(p.userName);
                    } else {
                      selected.add(p.userName);
                    }
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// Extracted into a performance-friendly component
class ShareTile extends StatelessWidget {
  const ShareTile({
    super.key,
    required this.person,
    required this.isSelected,
    required this.index,
    required this.onTap,
  });

  final Person person;
  final bool isSelected;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          tileColor: isSelected
              ? Theme.of(context).colorScheme.surfaceContainerHigh
              : Colors.transparent,
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          title: Text(
            person.name,
            style: TextStyle(
              fontFamily: "Google Sans Flex",
              fontVariations: [.weight(500), .width(75)],
            ),
          ),
          subtitle: Text(person.userName),
          leading: SizedBox(
            width: 48, // Set bounded constraints
            height: 48,
            child: ClipPath(
              clipper: DynamicAvatarClipper(person.profilePictureShape),
              child: CachedNetworkImage(
                imageUrl: person.profilePicturePath,
                // Prevents visual jerkiness while images load
                fadeInDuration: const Duration(milliseconds: 200),
              ),
            ),
          ),
          trailing: SizedBox(
            width: 56,
            height: 56,
            child: AnimatedSwitcher(
              duration: Durations.medium1,
              transitionBuilder: (child, animation) {
                final curvedAnimation = CurvedAnimation(parent: animation, curve: Easing.standard);
                return AnimatedBuilder(
                  animation: curvedAnimation,
                  builder: (context, _) {
                    final isEntering = child.key == const ValueKey('icon');
                    return ClipRect(
                      child: Align(
                        alignment: Alignment.center,
                        widthFactor: isEntering ? curvedAnimation.value : 1.0,
                        child: child,
                      ),
                    );
                  },
                );
              },
              // Keys are required, and SizedBox replaces null to preserve layout bounds
              child: isSelected
                  ? const Icon(Symbols.done, key: ValueKey('icon'))
                  : const SizedBox(key: ValueKey('empty')),
            ),
          ),
        )
        .animate()
        .fadeIn(
          // Caps delay tracking down the viewport to prevent massive lag spikes for deep indices
          delay: ((index % 12) * 40).ms,
          duration: 400.ms,
          curve: Easing.standardDecelerate,
        )
        .move(begin: const Offset(0, 64), duration: 400.ms, curve: Easing.standard);
  }
}

const List<String> recentlySent = [
  "sofia_garxcia",
  "is.this.helen.32",
  "director_hu54",
  "mr.zhang",
  "chris_t71",
  "i.am.jenny.ig",
  "emma_wil71",
  "your_sophie_here",
  "conqurer_of_demons",
  "this.is.liam123",
  "jack_mil_25",
];

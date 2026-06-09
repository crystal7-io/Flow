import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:redesigned/data/mock_data.dart';
import 'package:redesigned/widgets/profile_avatar.dart';

class ShareSheet extends StatefulWidget {
  const ShareSheet({super.key, required this.controller});
  final ScrollController controller;
  @override
  State<ShareSheet> createState() => _ShareSheetState();
}

class _ShareSheetState extends State<ShareSheet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 36,
          child: Center(
            child: Container(
              color: Theme.of(context).colorScheme.outline,
              height: 4,
              width: 32,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            controller: widget.controller,
            children: [
              const Row(
                children: [
                  SizedBox(width: 16),
                  Text("Share", style: TextStyle(fontSize: 22)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton.filledTonal(
                        padding: const EdgeInsets.all(22),
                        onPressed: () {},
                        icon: const Icon(Icons.add, size: 36),
                      ),
                      const SizedBox(height: 8),
                      const Text("Add to story"),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton.filledTonal(
                        padding: const EdgeInsets.all(22),
                        onPressed: () {},
                        icon: const Icon(Icons.link, size: 36),
                      ),
                      const SizedBox(height: 8),
                      const Text("Copy link"),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton.filledTonal(
                        padding: const EdgeInsets.all(22),
                        onPressed: () {},
                        icon: const Icon(Icons.share_outlined, size: 36),
                      ),
                      const SizedBox(height: 8),
                      const Text("Share"),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: SearchBar(
                  leading: Icon(Symbols.search, weight: 600),
                  hintText: "Search people",
                  elevation: WidgetStatePropertyAll(0),
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                shrinkWrap: true,
                children: recentlySent
                    .map(
                      (e) => ProfileAvatarWidget(
                        person: getPersonFromUserName(e),
                        size: 74,
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
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

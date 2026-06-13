import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:redesigned/data/mock_data.dart';

class SavePostSheet extends StatefulWidget {
  const SavePostSheet({super.key, required this.controller});
  final ScrollController controller;
  @override
  State<SavePostSheet> createState() => _SavePostSheetState();
}

class _SavePostSheetState extends State<SavePostSheet> {
  bool isSaved = false;
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      controller: widget.controller,
      children: [
        Center(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            height: 4,
            width: 40,
            margin: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
        ListTile(
          minTileHeight: 60,
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 55,
              width: 55,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                height: 55,
                width: 55,
                imageUrl:
                    "https://drive.google.com/uc?export=view&id=${posts.first.coverImagePath}",
              ),
            ),
          ),
          title: const Text("Saved"),
          subtitle: const Text("Private"),
          trailing: SizedBox(
            height: 40,
            child: isSaved
                ? OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        isSaved = false;
                      });
                    },
                    label: const Text("Saved"),
                    icon: const Icon(Icons.done),
                  )
                : FilledButton.icon(
                    onPressed: () {
                      setState(() {
                        isSaved = true;
                      });
                    },
                    label: const Text("Save"),
                    icon: const Icon(Icons.add),
                  ),
          ),
        ),
        const Divider(),
        SizedBox(
          height: 120,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("You don't have any collection yet"),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {},
                  child: const Text("Create a collection"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/screens/stories/stories_view_model.dart';
import 'package:redesigned/screens/stories/widgets/story_tile.dart';

class StoriesView extends StatelessWidget {
  const StoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StoriesViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Stories",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: CachedNetworkImage(
                      height: 64,
                      width: 64,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      placeholderFadeInDuration: const Duration(seconds: 0),
                      placeholder: (context, url) => Icon(
                        Icons.account_circle_rounded,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      fit: BoxFit.contain,
                      imageUrl: viewModel.profilePictureLink,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Crystal",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "crystal_arucs",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 40,
                    child: FilledButton.tonalIcon(
                      onPressed: viewModel.addStory,
                      icon: const Icon(Icons.add),
                      label: const Text("Add"),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Divider(),
            Column(
              children: viewModel.storiesData
                  .map((e) => StoryTile(person: e[0], notifNum: e[1]))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

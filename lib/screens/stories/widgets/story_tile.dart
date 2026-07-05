import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:redesigned/core/models/models.dart';
import 'package:redesigned/core/utils/dynamic_avatar_clipper.dart';
import 'package:redesigned/data/mock_data.dart';

class StoryTile extends StatelessWidget {
  final Person person;
  final int notifNum;
  const StoryTile({super.key, required this.person, this.notifNum = 0});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 24,
      visualDensity: const VisualDensity(vertical: 4),
      onTap: () {
        context.push(
          '/storyview',
          extra: StoryGroup(
            person: person,
            stories: [
              Story(
                duration: const Duration(seconds: 7),
                pathToMedia:
                    "https://drive.google.com/uc?export=view&id=${posts[0].coverImagePath}",
                type: StoryType.image,
                uploadTime: "47 min",
              ),
            ],
          ),
        );
      },
      leading: ClipPath(
        clipper: DynamicAvatarClipper(person.profilePictureShape),
        child: CachedNetworkImage(
          height: 55,
          width: 55,
          errorWidget: (context, url, error) => const Icon(Icons.error),
          placeholderFadeInDuration: const Duration(seconds: 0),
          placeholder: (context, url) => Icon(
            Icons.account_circle_rounded,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          fit: BoxFit.contain,
          imageUrl: person.pfpPath,
        ),
      ),

      title: Text(
        person.name,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0),
      ),
      subtitle: Text(
        person.userName,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0),
      ),
      trailing: Text(
        "$notifNum new",
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }
}

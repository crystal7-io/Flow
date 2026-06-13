import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:redesigned/core/models/models.dart';

class StoryWidget extends StatelessWidget {
  final Person person;
  const StoryWidget({required this.person, super.key});
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 76),
      child: Column(
        children: <Widget>[
          InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              context.push(
                '/storyview',
                extra: StoryGroup(
                  person: Person(
                    id: '',
                    name: 'Raiden Shogun',
                    userName: 'cook.with.shogun',
                    profilePicturePath: 'images/raiden.png',
                  ),
                  stories: [
                    Story(
                      duration: const Duration(seconds: 7),
                      pathToMedia: 'images/post/11.png',
                      type: StoryType.image,
                      uploadTime: "47 min",
                    ),
                    Story(
                      duration: const Duration(seconds: 7),
                      pathToMedia: 'stories/navia1.png',
                      type: StoryType.image,
                      uploadTime: "41 min",
                    ),
                    Story(
                      duration: const Duration(seconds: 7),
                      pathToMedia: 'stories/navia3.png',
                      type: StoryType.image,
                      uploadTime: "36 min",
                    ),
                    Story(
                      duration: const Duration(seconds: 7),
                      pathToMedia: 'stories/navia2.png',
                      type: StoryType.image,
                      uploadTime: "21 min",
                    ),
                  ],
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  width: 2.4,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                child: CachedNetworkImage(
                  height: 60,
                  width: 60,
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
            ),
          ),
          Text(
            overflow: TextOverflow.ellipsis,
            person.userName,
            style: const TextStyle(),
            softWrap: true,
          ),
        ],
      ),
    );
  }
}

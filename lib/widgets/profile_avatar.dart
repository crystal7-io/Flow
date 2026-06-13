import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:redesigned/core/models/models.dart';

class ProfileAvatarWidget extends StatelessWidget {
  const ProfileAvatarWidget({super.key, required this.person, this.size});
  final Person person;
  final double? size;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(size ?? 76),
          child: CachedNetworkImage(
            height: size ?? 76,
            width: size ?? 76,
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
        const SizedBox(height: 4),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: size ?? 76),
          child: Text(
            overflow: TextOverflow.ellipsis,
            person.name,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}

class ProfileAvatarTouchable extends StatelessWidget {
  const ProfileAvatarTouchable({
    super.key,
    required this.person,
    required this.onTap,
    this.size,
  });
  final void Function() onTap;
  final Person person;
  final double? size;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ProfileAvatarWidget(person: person, size: size),
    );
  }
}

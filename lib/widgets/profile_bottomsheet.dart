import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:redesigned/core/models/models.dart';

class ProfileBottomsheet extends StatefulWidget {
  const ProfileBottomsheet({super.key, required this.acc});
  final Account acc;
  @override
  State<ProfileBottomsheet> createState() => _ProfileBottomsheetState();
}

class _ProfileBottomsheetState extends State<ProfileBottomsheet> {
  bool isFollowing = false;
  @override
  void initState() {
    super.initState();
  }

  void followPress() {
    setState(() {
      isFollowing = !isFollowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: CachedNetworkImage(
              height: 135,
              width: 135,
              errorWidget: (context, url, error) => const Icon(Icons.error),
              placeholderFadeInDuration: const Duration(seconds: 0),
              placeholder: (context, url) => Icon(
                Icons.account_circle_rounded,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              fit: BoxFit.contain,
              imageUrl: widget.acc.person.pfpPath,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.acc.person.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            widget.acc.person.userName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          if (widget.acc.bio.isNotEmpty) const SizedBox(height: 12),
          if (widget.acc.bio.isNotEmpty)
            Text(widget.acc.bio, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: isFollowing
                      ? FilledButton.tonalIcon(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: followPress,
                          label: const Text(
                            "Unfollow",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        )
                      : FilledButton.icon(
                          onPressed: followPress,
                          icon: const Icon(Icons.add),
                          label: const Text("Follow"),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.push(
                        '/profile/a1b2c3d4-e5f6-4789-90ab-cdef01234567}',
                        extra: widget.acc,
                      );
                    },
                    icon: const Icon(Icons.arrow_right_alt),
                    label: const Text("See Profile"),
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
    );
  }
}

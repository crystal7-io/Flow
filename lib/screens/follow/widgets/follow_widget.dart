import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:redesigned/core/models/models.dart';
import 'package:redesigned/data/mock_data.dart';
import 'package:redesigned/core/services/app_service.dart';
import 'package:provider/provider.dart';

class Follows extends StatefulWidget {
  const Follows({super.key, required this.isFollowing, required this.person});
  final bool isFollowing;
  final Person person;
  @override
  State<Follows> createState() => _FollowsState();
}

class _FollowsState extends State<Follows> {
  bool _isFollowing = true;

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.isFollowing;
  }

  void followPress() {
    setState(() {
      if (_isFollowing) {
        _isFollowing = false;
        context.read<AppService>().removeFollower(widget.person);
      } else {
        _isFollowing = true;
        context.read<AppService>().addFollower(widget.person);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(
          '/profile/true',
          extra: getAccountFromUserName(widget.person.userName),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: CachedNetworkImage(
                    height: 50,
                    width: 50,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    placeholderFadeInDuration: const Duration(seconds: 0),
                    placeholder: (context, url) => Icon(
                      Icons.account_circle_rounded,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    fit: BoxFit.contain,
                    imageUrl: widget.person.pfpPath,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 110,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.person.name,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.10,
                        ),
                      ),
                      Text(
                        widget.person.userName,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 12,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _isFollowing
                ? TextButton(
                    onPressed: followPress,
                    child: const Text("Unfollow"),
                  )
                : SizedBox(
                    height: 36,
                    child: FilledButton.tonal(
                      onPressed: followPress,
                      child: const Text("Follow"),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

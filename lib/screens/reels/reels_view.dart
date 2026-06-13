import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/core/models/reel_model.dart';
import 'package:redesigned/screens/reels/reels_view_model.dart';

class ReelsView extends StatelessWidget {
  const ReelsView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ReelsViewModel>();

    return Scaffold(
      body: Stack(
        children: [
          ListView.builder(
            itemCount: viewModel.reelsData.length,
            itemBuilder: (context, index) =>
                ReelWidget(reel: viewModel.reelsData[index]),
          ),
          SizedBox(
            height: 64,
            child: AppBar(
              leading: IconButton(
                onPressed: () => viewModel.onBackPress(context),
                icon: const Icon(Icons.arrow_back),
              ),
              title: const Text("Reels"),
              toolbarHeight: 64,
            ),
          ),
        ],
      ),
    );
  }
}

class ReelWidget extends StatelessWidget {
  const ReelWidget({super.key, required this.reel});
  final Reel reel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        child: CachedNetworkImage(
                          height: 50,
                          width: 50,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          placeholderFadeInDuration: const Duration(seconds: 0),
                          placeholder: (context, url) => Icon(
                            Icons.account_circle_rounded,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                          fit: BoxFit.contain,
                          imageUrl: reel.person.profilePicturePath,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            reel.person.name,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            reel.person.userName,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

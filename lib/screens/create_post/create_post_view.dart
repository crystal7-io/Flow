import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'create_post_view_model.dart';

class CreatePostView extends StatelessWidget {
  const CreatePostView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreatePostViewModel(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Icon(Icons.arrow_back)),
          title: const Text('Create Post'),
        ),
        body: const Center(
          child: Text('Simple Create Post Screen'),
        ),
      ),
    );
  }
}

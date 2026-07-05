import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/core/models/chat.dart';
import 'package:redesigned/core/utils/dynamic_avatar_clipper.dart';
import 'package:redesigned/data/mock_data.dart';
import 'package:redesigned/screens/messages/chat/chat_view_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 840) {
          return const DesktopChatView();
        } else {
          return const MobileChatView();
        }
      },
    );
  }
}

class MobileChatView extends StatelessWidget {
  const MobileChatView({super.key});

  @override
  Widget build(BuildContext context) {
    // Read instead of watch to prevent full-screen rebuilds
    final viewModel = context.read<ChatViewModel>();
    final person = viewModel.person;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      body: Consumer<ChatViewModel>(
        builder: (context, vm, child) {
          // if (!vm.isLoaded) {
          //   return SizedBox();
          //   // const Center(
          //   // child: CircularProgressIndicator(),
          //   // );
          // }
          return RepaintBoundary(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: .only(top: MediaQuery.paddingOf(context).top + 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: .start,
                    children: [
                      SizedBox(width: 4),
                      SizedBox(
                        height: 48,
                        width: 40,
                        child: IconButton(
                          style: ButtonStyle(
                            backgroundColor: .all(
                              Theme.of(context).colorScheme.surfaceContainerLow,
                            ),
                          ),
                          onPressed: () => viewModel.onBackPress(context),
                          icon: const Icon(Icons.arrow_back),
                        ),
                      ),
                      Spacer(),
                      ClipPath(
                        clipper: DynamicAvatarClipper(person.profilePictureShape),
                        child: CachedNetworkImage(
                          height: 48,
                          width: 48,
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                          placeholderFadeInDuration: const Duration(seconds: 0),
                          fit: BoxFit.contain,
                          imageUrl: person.profilePicturePath,
                        ),
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            person.name,
                            style: TextStyle(
                              fontSize: 22,
                              height: 1.1,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontFamily: "Google Sans Flex",
                              fontVariations: [
                                .weight(400),
                                .width(60),
                                // .new("ROND", 100),
                                .new("opsz", 100),
                              ],
                            ),
                          ),
                          Text(
                            person.userName,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontFamily: "Google Sans Flex",
                              fontVariations: [
                                .weight(600),
                                // .new("ROND", 100),
                                .new("opsz", 100),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 12),
                      Spacer(),
                      SizedBox(
                        height: 48,
                        child: IconButton(
                          style: ButtonStyle(
                            backgroundColor: .all(
                              Theme.of(context).colorScheme.surfaceContainerLow,
                            ),
                          ),
                          onPressed: () {},
                          icon: const Icon(Icons.more_vert),
                        ),
                      ),
                      SizedBox(width: 4),
                    ],
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: .circular(28),
                    child: ColoredBox(
                      color: Theme.of(context).colorScheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ScrollablePositionedList.builder(
                          padding: .only(bottom: 12),
                          reverse: true,
                          itemScrollController: vm.scrollController,
                          itemCount: vm.chats.length,
                          itemBuilder: (context, index) {
                            final chat = vm.chats[index];
                            if (chat.sentByUser) {
                              return UserChat(
                                onLongPress: () {},
                                isTopSame:
                                    index < vm.chats.length - 1 && vm.chats[index + 1].sentByUser,
                                chatText: chat,
                              );
                            } else {
                              return InterlocutorChat(
                                isBottomSame: index > 1 && !vm.chats[index - 1].sentByUser,
                                pfpPath: person.profilePicturePath,
                                chatText: chat,
                                isTopSame:
                                    index < vm.chats.length - 1 && !vm.chats[index + 1].sentByUser,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const _MobileInputWidget(),
                SizedBox(
                  height:
                      // MediaQuery not working
                      //  MediaQuery.of(context).padding.bottom
                      16,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MobileInputWidget extends StatelessWidget {
  const _MobileInputWidget();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ChatViewModel>();

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        spacing: 4,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              alignment: .center,
              constraints: const BoxConstraints(minHeight: 56),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: .circular(12),
              ),
              padding: const EdgeInsets.all(8),
              child: TextField(
                // autofocus: true,
                maxLines: 5,
                minLines: 1,
                controller: viewModel.textEditingController,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1,
                ),
                decoration: InputDecoration(
                  prefixIcon: IconButton(onPressed: () {}, icon: const Icon(Icons.add, size: 24)),
                  contentPadding: .symmetric(vertical: 16),
                  hintText: "Message...",
                  hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1,
                    fontFamily: "Google Sans Flex",
                    fontVariations: [.weight(600), .width(75), .new("ROND", 100)],
                  ),
                  isDense: true,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          SizedBox(
            height: 64,
            width: 64,
            child: IconButton.filledTonal(
              style: ButtonStyle(
                backgroundColor: .all(ColorScheme.of(context).tertiaryContainer),
                foregroundColor: .all(ColorScheme.of(context).onTertiaryContainer),
              ),
              onPressed: () {},
              icon: const Icon(Symbols.send, fill: 0, weight: 800),
            ),
          ),
        ],
      ),
    );
  }
}

class DesktopChatView extends StatelessWidget {
  const DesktopChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ChatViewModel>();
    final person = viewModel.person;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        toolbarHeight: 64,
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.8,
                  color: person.isStoryVisible
                      ? person.newStory
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outlineVariant
                      : Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: CachedNetworkImage(
                  height: 36,
                  width: 36,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  placeholderFadeInDuration: const Duration(seconds: 0),
                  fit: BoxFit.contain,
                  imageUrl: person.profilePicturePath,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Text(
                  person.userName,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: const Icon(Icons.videocam_outlined)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.phone_outlined)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ScrollablePositionedList.builder(
                reverse: true,
                itemScrollController: viewModel.scrollController,
                itemCount: viewModel.chats.length,
                itemBuilder: (context, index) {
                  final chat = viewModel.chats[index];
                  if (chat.sentByUser) {
                    return UserChat(
                      onLongPress: () {},
                      isTopSame:
                          index < viewModel.chats.length - 1 &&
                          viewModel.chats[index + 1].sentByUser,
                      chatText: chat,
                    );
                  } else {
                    return InterlocutorChat(
                      isBottomSame: index > 1 && !viewModel.chats[index - 1].sentByUser,
                      pfpPath: person.profilePicturePath,
                      chatText: chat,
                      isTopSame:
                          index < viewModel.chats.length - 1 &&
                          !viewModel.chats[index + 1].sentByUser,
                    );
                  }
                },
              ),
            ),
          ),
          _buildInput(context, viewModel),
        ],
      ),
    );
  }

  Widget _buildInput(BuildContext context, ChatViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 120),
        child: TextField(
          maxLines: null,
          onChanged: viewModel.onInputChanged,
          controller: viewModel.textEditingController,
          decoration: InputDecoration(
            filled: true,
            isDense: false,
            fillColor: Theme.of(context).colorScheme.surfaceContainerHigh,
            hintText: "Message...",
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            prefixIcon: IconButton(onPressed: () {}, icon: const Icon(Icons.camera_alt, size: 24)),
            suffixIcon: viewModel.currentInput.isEmpty
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.attach_file_outlined, size: 24),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.emoji_emotions_outlined, size: 24),
                      ),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.mic, size: 24)),
                      const SizedBox(width: 4),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextButton(
                      onPressed: viewModel.sendMessage,
                      child: const Text("Send", style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}

// Reusable Menu Items to save memory
List<Widget> _buildChatMenu(BuildContext context) => [
  const MenuItemButton(leadingIcon: Icon(Icons.reply), child: Text("Reply")),
  const MenuItemButton(leadingIcon: Icon(Icons.send_outlined), child: Text("Forward")),
  const MenuItemButton(leadingIcon: Icon(Icons.copy_outlined), child: Text("Copy")),
  const MenuItemButton(leadingIcon: Icon(Icons.delete_outline), child: Text("Delete")),
];

class InterlocutorChat extends StatelessWidget {
  const InterlocutorChat({
    super.key,
    required this.chatText,
    required this.isTopSame,
    required this.pfpPath,
    required this.isBottomSame,
  });

  final ChatText chatText;
  final String pfpPath;
  final bool isTopSame;
  final bool isBottomSame;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(top: isTopSame ? 0 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isTopSame) const SizedBox(height: 4),
          if (chatText.repliedTo != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: chatText.repliedTo != null
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      // Convert the int to a String here
                      child: ReplyWidget(reply: chatTexts[chatText.repliedTo].text),
                    )
                  : SizedBox(),
            ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.75),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(isBottomSame ? 0 : 28),
                  topLeft: const Radius.circular(0),
                  topRight: const Radius.circular(28),
                  bottomRight: const Radius.circular(28),
                ),
              ),
              child: Text(
                chatText.text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontFamily: "Google Sans Flex",
                  fontVariations: [.weight(500), .width(75), .new("ROND", 100)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserChat extends StatelessWidget {
  const UserChat({
    super.key,
    required this.chatText,
    required this.isTopSame,
    required this.onLongPress,
  });

  final ChatText chatText;
  final bool isTopSame;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(top: isTopSame ? 0 : 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(width: 60),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.75),
            child: MenuAnchor(
              menuChildren: _buildChatMenu(context),
              builder: (context, controller, child) {
                return GestureDetector(
                  onLongPress: () => controller.isOpen ? controller.close() : controller.open(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(28),
                        bottomLeft: const Radius.circular(28),
                        topRight: Radius.circular(isTopSame ? 0 : 28),
                        bottomRight: const Radius.circular(0),
                      ),
                    ),
                    child: Text(
                      chatText.text,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onPrimaryContainer,
                        fontFamily: "Google Sans Flex",
                        fontVariations: [.weight(500), .width(75), .new("ROND", 100)],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ReplyWidget extends StatelessWidget {
  const ReplyWidget({super.key, required this.reply});
  final String reply;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Theme.of(context).colorScheme.surfaceContainer,
      ),
      child: Text(reply, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
    );
  }
}

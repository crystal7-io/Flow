import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/core/models/models.dart';
import 'package:redesigned/core/services/app_service.dart';
import 'package:redesigned/core/utils/light_open_container.dart';
import 'package:redesigned/data/mock_data.dart';
import 'package:redesigned/screens/messages/chat/chat_view.dart';
import 'package:redesigned/screens/messages/chat/chat_view_model.dart';
import 'package:redesigned/screens/messages/messages_view_model.dart';
import 'package:redesigned/screens/messages/search/search_message_view.dart';
import 'package:redesigned/screens/messages/search/search_message_view_model.dart';

class MessagesView extends StatelessWidget {
  const MessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => constraints.maxWidth > 840
          ? const MessageScreenDesktop()
          : const MessageScreenMobile(),
    );
  }
}

class MessageScreenMobile extends StatelessWidget {
  const MessageScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MessagesViewModel>();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text(
          "Messages",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        ),
        actions: <Widget>[
          const MessageSearchAnchor(),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              color: Colors.black,
              child: CachedNetworkImage(
                height: 40,
                width: 40,
                errorWidget: (context, url, error) => const Icon(Icons.error),
                placeholderFadeInDuration: const Duration(seconds: 0),
                placeholder: (context, url) => Icon(
                  Icons.account_circle_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                fit: BoxFit.contain,
                imageUrl: linkToPfp,
              ),
            ),
          ),
          const SizedBox(width: 16)
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ListView(
        children: [
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                const SizedBox(width: 8),
                ...filters.map((e) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChip(
                        side: BorderSide.none,
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceContainerHigh,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        label: Text(e),
                        labelPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 2),
                        selected: viewModel.currentFilters.contains(e),
                        onSelected: (bool isSelected) {
                          viewModel.toggleFilter(e, isSelected);
                        },
                      ),
                    ))
              ],
            ),
          ),
          ...viewModel.chatData.map((e) => LightOpenContainer(
                useRootNavigator: false,
                openColor: Theme.of(context).colorScheme.surface,
                closedColor: Theme.of(context).colorScheme.surface,
                closedBuilder: (context, close) => ChatWidget(
                  chat: e,
                  openChat: () {
                    context.read<AppService>().setNavBarVisible(false);
                    close();
                  },
                ),
                onClosed: (_) {
                  context.read<AppService>().setNavBarVisible(true);
                },
                openBuilder: (context, _) =>
                    ChangeNotifierProvider<ChatViewModel>(
                  create: (_) => ChatViewModel(e.person),
                  child: const ChatView(),
                ),
              )),
          const SizedBox(height: 120)
        ],
      ),
    );
  }
}

class MessageScreenDesktop extends StatelessWidget {
  const MessageScreenDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MessagesViewModel>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Row(
          children: <Widget>[
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(14)),
              width: MediaQuery.sizeOf(context).width / 3.5,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: SearchBar(
                      backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.surfaceContainerHigh),
                      leading: const SizedBox(
                        height: 40,
                        width: 40,
                        child: Icon(Symbols.search),
                      ),
                      hintText: "Search messages",
                      onTap: () {},
                      elevation: const WidgetStatePropertyAll(0),
                      trailing: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Stack(
                            children: <Widget>[
                              CachedNetworkImage(
                                  height: 40,
                                  width: 40,
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  placeholderFadeInDuration:
                                      const Duration(seconds: 0),
                                  placeholder: (context, url) => Icon(
                                      Icons.account_circle_rounded,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant),
                                  fit: BoxFit.contain,
                                  imageUrl: linkToPfp),
                              Positioned.fill(
                                  child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {},
                                      )))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 55,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        const SizedBox(width: 8),
                        ...filters.map((e) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: FilterChip(
                                side: BorderSide(
                                    color: viewModel.currentFilters.contains(e)
                                        ? Theme.of(context)
                                            .colorScheme
                                            .primaryContainer
                                        : Theme.of(context)
                                            .colorScheme
                                            .outlineVariant),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                label: Text(e),
                                labelPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 2),
                                selected: viewModel.currentFilters.contains(e),
                                onSelected: (bool isSelected) {
                                  viewModel.toggleFilter(e, isSelected);
                                },
                              ),
                            ))
                      ],
                    ),
                  ),
                  Expanded(
                      child: ListView(
                    children: chats
                        .map((e) => ChatWidgetDesktop(
                            chat: e,
                            onPressed: () {
                              viewModel.selectActiveChat(e.person);
                            }))
                        .toList(),
                  ))
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
                child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: viewModel.currentActive != null
                  ? ChangeNotifierProvider<ChatViewModel>(
                      create: (_) => ChatViewModel(viewModel.currentActive!),
                      child: const ChatView(),
                    )
                  : Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface),
                      padding: const EdgeInsets.symmetric(),
                      child: const Center(
                        child: Text("Messages"),
                      ),
                    ),
            )),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

class ChatWidgetDesktop extends StatelessWidget {
  const ChatWidgetDesktop(
      {super.key, required this.chat, required this.onPressed});
  final Chat chat;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        onTap: onPressed,
        title: Text(
          chat.person.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        leading: CircleAvatar(
          radius: 28,
          child: CachedNetworkImage(
              errorWidget: (context, url, error) => const Icon(Icons.error),
              placeholderFadeInDuration: const Duration(seconds: 0),
              placeholder: (context, url) => Icon(Icons.account_circle_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
              fit: BoxFit.contain,
              imageUrl: chat.person.pfpPath),
        ),
        subtitle: Text(
          maxLines: 1,
          chat.lastMessageState == LastMessageState.sentByUserAndSeen
              ? "Seen"
              : chat.lastMessageState == LastMessageState.sentByUserAndUnseen
                  ? "Sent"
                  : chat.newMessage > 1
                      ? "${chat.newMessage} new messages"
                      : chat.lastMessage,
          style: TextStyle(
              fontSize: 14,
              fontWeight:
                  chat.newMessage == 0 ? FontWeight.w500 : FontWeight.w700,
              letterSpacing: 0),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              chat.lastTime,
              style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

Set<String> filters = {'Unread', 'Read', 'Groups', 'Active', 'Starred'};

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key, required this.chat, required this.openChat});
  final VoidCallback openChat;
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: openChat,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: CircleAvatar(
                  radius: 24,
                  child: CachedNetworkImage(
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      placeholderFadeInDuration: const Duration(seconds: 0),
                      placeholder: (context, url) => Icon(
                          Icons.account_circle_rounded,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                      fit: BoxFit.contain,
                      imageUrl: chat.person.pfpPath),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    chat.person.name,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    chat.lastMessageState == LastMessageState.sentByUserAndSeen
                        ? "Seen"
                        : chat.lastMessageState ==
                                LastMessageState.sentByUserAndUnseen
                            ? "Sent"
                            : chat.newMessage > 1
                                ? "${chat.newMessage} new messages"
                                : chat.lastMessage,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: chat.newMessage == 0
                            ? FontWeight.w500
                            : FontWeight.w700,
                        letterSpacing: 0),
                  ),
                ],
              )),
              const SizedBox(width: 18),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: Axis.horizontal,
                children: [
                  Text(
                    chat.lastTime,
                    style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ],
              )
            ],
          )),
    );
  }
}

class MessageSearchAnchor extends StatelessWidget {
  const MessageSearchAnchor({super.key});

  @override
  Widget build(BuildContext context) {
    return LightOpenContainer(
        openColor: Theme.of(context).colorScheme.surface,
        closedColor: Theme.of(context).colorScheme.surface,
        closedBuilder: (context, openContainer) => SizedBox(
              height: 45,
              width: 45,
              child: IconButton(
                  onPressed: openContainer,
                  icon: const Icon(
                    Icons.search,
                    weight: 600,
                  )),
            ),
        openBuilder: (context, controller) =>
            ChangeNotifierProvider<SearchMessageViewModel>(
              create: (_) => SearchMessageViewModel(),
              child: const SearchMessageView(),
            ));
  }
}

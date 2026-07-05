import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/core/models/models.dart';
import 'package:redesigned/core/services/app_service.dart';
import 'package:redesigned/core/utils/dynamic_avatar_clipper.dart';
import 'package:redesigned/core/utils/light_open_container.dart';
import 'package:redesigned/data/mock_data.dart';
import 'package:redesigned/screens/messages/chat/chat_view.dart';
import 'package:redesigned/screens/messages/chat/chat_view_model.dart';
import 'package:redesigned/screens/messages/messages_view_model.dart';
import 'package:redesigned/screens/messages/search/search_message_view.dart';
import 'package:redesigned/screens/messages/search/search_message_view_model.dart';
import 'package:redesigned/widgets/utils/wave_divider.dart';

class MessagesView extends StatelessWidget {
  const MessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) =>
          constraints.maxWidth > 840 ? const MessageScreenDesktop() : const MessageScreenMobile(),
    );
  }
}

class MessageScreenMobile extends StatelessWidget {
  const MessageScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MessagesViewModel>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ListView(
        padding: .zero,
        shrinkWrap: true,
        children: [
          Column(
            children: [
              SizedBox(height: MediaQuery.paddingOf(context).top),

              // Padding(
              //   padding: .symmetric(horizontal: 16, vertical: 8),
              //   child: const MessageSearchAnchor(),
              // ),
              Padding(
                padding: .symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  crossAxisAlignment: .end,
                  children: [
                    Text(
                      "Messages",
                      style: GoogleFonts.limelight(
                        textStyle: TextTheme.of(context).displaySmall!.copyWith(
                          // fontFamily: "Google Sans Flex",
                          color: ColorScheme.of(context).onSurfaceVariant,
                          fontWeight: .w600,
                          // fontVariations: [.weight(1000), .width(50)],
                        ),
                      ),
                    ),
                    Spacer(),
                    MessageSearchAnchor(),
                  ],
                ),
              ),
              SizedBox(height: 8),

              Padding(
                padding: .symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: .min,
                  children: [
                    Row(
                      spacing: 4,
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        FilterChip(
                          shape: viewModel.currentFilters.isEmpty ? StadiumBorder() : null,
                          selectedColor: ColorScheme.of(context).primaryContainer,
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          labelStyle: TextStyle(
                            color: viewModel.currentFilters.isEmpty
                                ? ColorScheme.of(context).onPrimaryContainer
                                : null,
                            fontFamily: "Google Sans Flex",
                            fontVariations: [.weight(500), .width(70)],
                          ),
                          checkmarkColor: ColorScheme.of(context).onPrimaryContainer,
                          selected: viewModel.currentFilters.isEmpty,
                          onSelected: (value) {
                            viewModel.toggleFilter(-1, value);
                          },
                          label: Text("All"),
                        ),
                        FilterChip(
                          shape: viewModel.currentFilters.contains(0) ? StadiumBorder() : null,
                          selectedColor: ColorScheme.of(context).tertiaryContainer,
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          labelStyle: TextStyle(
                            color: viewModel.currentFilters.contains(0)
                                ? ColorScheme.of(context).onTertiaryContainer
                                : null,
                            fontFamily: "Google Sans Flex",
                            fontVariations: [.weight(500), .width(70)],
                          ),
                          checkmarkColor: ColorScheme.of(context).onTertiaryContainer,
                          selected: viewModel.currentFilters.contains(0),
                          onSelected: (value) {
                            viewModel.toggleFilter(0, value);
                          },
                          label: Text("Unread"),
                        ),
                        FilterChip(
                          shape: viewModel.currentFilters.contains(1) ? StadiumBorder() : null,
                          selectedColor: ColorScheme.of(context).tertiaryContainer,
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          labelStyle: TextStyle(
                            color: viewModel.currentFilters.contains(1)
                                ? ColorScheme.of(context).onTertiaryContainer
                                : null,
                            fontFamily: "Google Sans Flex",
                            fontVariations: [.weight(500), .width(70)],
                          ),
                          checkmarkColor: ColorScheme.of(context).onTertiaryContainer,
                          selected: viewModel.currentFilters.contains(1),
                          onSelected: (value) {
                            viewModel.toggleFilter(1, value);
                          },
                          label: Text("Groups"),
                        ),
                        FilterChip(
                          shape: viewModel.currentFilters.contains(2) ? StadiumBorder() : null,
                          selectedColor: ColorScheme.of(context).tertiaryContainer,
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          labelStyle: TextStyle(
                            color: viewModel.currentFilters.contains(2)
                                ? ColorScheme.of(context).onTertiaryContainer
                                : null,
                            fontFamily: "Google Sans Flex",
                            fontVariations: [.weight(500), .width(70)],
                          ),
                          checkmarkColor: ColorScheme.of(context).onTertiaryContainer,
                          selected: viewModel.currentFilters.contains(2),
                          onSelected: (value) {
                            viewModel.toggleFilter(2, value);
                          },
                          label: Text("Starred"),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      width: .infinity,
                      child: Padding(
                        padding: .symmetric(horizontal: 0, vertical: 12),
                        child: ClipRect(child: WavyDivider()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          ...viewModel.chatData.map(
            (e) => CustomOpenContainer(
              closedColor: Theme.of(context).colorScheme.surface,
              onClosed: () {
                context.read<AppService>().setNavBarVisible(true);
                // prefix_scheduler.timeDilation = 1.0;
              },
              closedBuilder: (context, open, visible) => ChatWidget(
                key: Key(e.person.userName),
                chat: e,
                openChat: () {
                  // prefix_scheduler.timeDilation = 8.0;
                  context.read<AppService>().setNavBarVisible(false);
                  open();
                },
              ),

              openBuilder: (context) => ChangeNotifierProvider<ChatViewModel>(
                create: (_) => ChatViewModel(e.person),
                child: const ChatView(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Set<String> filters = {'Unread', 'Groups', 'Starred'};

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key, required this.chat, required this.openChat});
  final VoidCallback openChat;
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: openChat,
        child: Padding(
          // Tightened up padding to keep structural bounds consistent
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            // 1. Change to start so text and image use a shared vertical baseline
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 2. Removed the extra Align and internal padding wrappers
              SizedBox(
                height: 56,
                width: 56,
                child: ClipPath(
                  clipper: DynamicAvatarClipper(chat.person.profilePictureShape),
                  child: CachedNetworkImage(
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    placeholderFadeInDuration: const Duration(seconds: 0),
                    placeholder: (context, url) => Icon(
                      Icons.account_circle_rounded,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    fit: BoxFit.contain,
                    imageUrl: chat.person.pfpPath,
                  ),
                ),
              ),
              const SizedBox(width: 16), // Match standard list spacing
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Added slight offset to center-align cleanly with a 56px avatar
                    const SizedBox(height: 4),
                    Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      chat.person.name,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      chat.lastMessageState == LastMessageState.sentByUserAndSeen
                          ? "Seen"
                          : chat.lastMessageState == LastMessageState.sentByUserAndUnseen
                          ? "Sent"
                          : chat.newMessage > 1
                          ? "${chat.newMessage} new messages"
                          : chat.lastMessage,
                      style: TextStyle(
                        color: chat.newMessage == 0
                            ? Theme.of(context).colorScheme.onSurfaceVariant
                            : Theme.of(context).colorScheme.secondary,
                        fontSize: 14,
                        fontWeight: chat.newMessage == 0 ? FontWeight.w400 : FontWeight.w600,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Padding(
                padding: const EdgeInsets.only(top: 6), // Align timestamp to name baseline
                child: Text(
                  chat.lastTime,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageSearchAnchor extends StatelessWidget {
  const MessageSearchAnchor({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      width: 56,
      child: IconButton(
        style: ButtonStyle(
          foregroundColor: .all(ColorScheme.of(context).onSurfaceVariant),
          backgroundColor: .all(ColorScheme.of(context).surfaceContainerHigh),
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider<SearchMessageViewModel>(
                create: (_) => SearchMessageViewModel(),
                child: const SearchMessageView(),
              ),
            ),
          );
        },
        icon: Icon(Symbols.search),
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
                borderRadius: BorderRadius.circular(14),
              ),
              width: MediaQuery.sizeOf(context).width / 3.5,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: SearchBar(
                      backgroundColor: WidgetStatePropertyAll(
                        Theme.of(context).colorScheme.surfaceContainerHigh,
                      ),
                      leading: const SizedBox(height: 40, width: 40, child: Icon(Symbols.search)),
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
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                placeholderFadeInDuration: const Duration(seconds: 0),
                                placeholder: (context, url) => Icon(
                                  Icons.account_circle_rounded,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                                fit: BoxFit.contain,
                                imageUrl: linkToPfp,
                              ),
                              Positioned.fill(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(onTap: () {}),
                                ),
                              ),
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
                        ...filters.map(
                          (e) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: FilterChip(
                              side: BorderSide(
                                color: viewModel.currentFilters.contains(e)
                                    ? Theme.of(context).colorScheme.primaryContainer
                                    : Theme.of(context).colorScheme.outlineVariant,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              label: Text(e),
                              labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                              selected: viewModel.currentFilters.contains(e),
                              onSelected: (bool isSelected) {
                                // This logic is wrong, instead of 0 there should be e (String of Filter) but
                                // I changed logic of Mobile and didnt have time to change for desktop
                                // viewModel.toggleFilter();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: chats
                          .map(
                            (e) => ChatWidgetDesktop(
                              chat: e,
                              onPressed: () {
                                viewModel.selectActiveChat(e.person);
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
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
                        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
                        padding: const EdgeInsets.symmetric(),
                        child: const Center(child: Text("Messages")),
                      ),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

class ChatWidgetDesktop extends StatelessWidget {
  const ChatWidgetDesktop({super.key, required this.chat, required this.onPressed});
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
            placeholder: (context, url) => Icon(
              Icons.account_circle_rounded,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            fit: BoxFit.contain,
            imageUrl: chat.person.pfpPath,
          ),
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
            fontWeight: chat.newMessage == 0 ? FontWeight.w500 : FontWeight.w700,
            letterSpacing: 0,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              chat.lastTime,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

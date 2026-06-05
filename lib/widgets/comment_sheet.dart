import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:redesigned/widgets/utils/expansion_view.dart';
import 'package:redesigned/core/models/models.dart';
import 'package:redesigned/data/mock_data.dart';

class CommentSheet extends StatefulWidget {
  const CommentSheet({super.key, required this.controller});
  final ScrollController controller;
  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  List<bool> isReplyOpen = List.filled(comments[0].length, false);

  void expandComment(panelIndex) {
    setState(() {
      isReplyOpen[panelIndex] = !isReplyOpen[panelIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            height: 4,
            width: 40,
            margin: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
        Expanded(
            child: ListView(controller: widget.controller, children: [
          const Row(
            children: [
              SizedBox(width: 16),
              Text(
                'Comments',
                style: TextStyle(fontSize: 22),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ExpansionViewList(
              elevation: 0,
              expandedHeaderPadding: EdgeInsets.zero,
              materialGapSize: 0,
              children: comments[0]
                  .mapIndexed((index, comment) => ExpansionView(
                      backgroundColor: Colors.transparent,
                      isExpanded: isReplyOpen[index],
                      headerBuilder: (context, isExpanded) =>
                          CommentWidget(expand: expandComment, comment: comment),
                      body: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: comment.replies.length,
                          separatorBuilder: (context, index) => Divider(
                                indent: 36,
                                endIndent: 12,
                                color: Theme.of(context).colorScheme.outlineVariant,
                              ),
                          itemBuilder: (context, index) =>
                              CommentReplyWidget(reply: comment.replies[index]))))
                  .toList()),
        ])),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: CachedNetworkImage(
                        height: 40,
                        width: 40,
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                        placeholderFadeInDuration: const Duration(seconds: 0),
                        placeholder: (context, url) => Icon(Icons.account_circle_rounded,
                            color: Theme.of(context).colorScheme.onSurfaceVariant),
                        fit: BoxFit.contain,
                        imageUrl: linkToPfp),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                      child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 18),
                      hintText: "Add a comment...",
                    ),
                  )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Symbols.send,
                        size: 24,
                        weight: 600,
                      ))
                ],
              ),
            )),
        Container(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          width: double.maxFinite,
          height: MediaQuery.of(context).padding.bottom,
        )
      ],
    );
  }
}

class CommentWidget extends StatefulWidget {
  const CommentWidget({
    super.key,
    required this.comment,
    required this.expand,
  });
  final Comment comment;
  final void Function(dynamic) expand;
  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: CachedNetworkImage(
                    height: 45,
                    width: 45,
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    placeholderFadeInDuration: const Duration(seconds: 0),
                    placeholder: (context, url) => Icon(Icons.account_circle_rounded,
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                    fit: BoxFit.contain,
                    imageUrl: widget.comment.person.pfpPath,
                  ),
                )),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.comment.person.name,
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(width: 16),
                              Text(widget.comment.dateTime),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            maxLines: 50,
                            overflow: TextOverflow.clip,
                            widget.comment.text,
                            style: const TextStyle(fontSize: 14),
                          )
                        ],
                      )),

                      // const Spacer(),
                    ],
                  ),
                  Row(
                    children: [
                      TextButton.icon(
                          style: ButtonStyle(
                              iconColor: WidgetStatePropertyAll(
                            widget.comment.isLiked
                                ? Colors.red
                                : Theme.of(context).colorScheme.primary,
                          )),
                          label: Text(
                            widget.comment.likes.toString(),
                          ),
                          onPressed: () {
                            setState(() {
                              if (widget.comment.isLiked) {
                                widget.comment.isLiked = false;
                                widget.comment.likes -= 1;
                                return;
                              }
                              widget.comment.isLiked = true;
                              widget.comment.likes += 1;
                            });
                          },
                          icon: Icon(
                            widget.comment.isLiked ? Icons.favorite : Icons.favorite_outline,
                            size: 22,
                          )),
                      const SizedBox(width: 8),
                      TextButton.icon(
                          label: const Text(
                            "Reply",
                          ),
                          onPressed: () {},
                          icon: Icon(
                            Icons.reply_outlined,
                            size: 24,
                          )),
                    ],
                  ),
                  if (widget.comment.replies.isNotEmpty)
                    TextButton.icon(
                        onPressed: () {
                          widget.expand(0);
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        iconAlignment: IconAlignment.end,
                        label: Text(isExpanded
                            ? "Hide replies"
                            : "See ${widget.comment.replies.length.toString()} replies"),
                        icon: Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                        )),
                ],
              ),
            ),
          ],
        ));
  }
}

class CommentReplyWidget extends StatefulWidget {
  const CommentReplyWidget({super.key, required this.reply});
  final CommentReply reply;
  @override
  State<CommentReplyWidget> createState() => _CommentReplyWidgetState();
}

class _CommentReplyWidgetState extends State<CommentReplyWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(36, 8, 0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: CachedNetworkImage(
              height: 36,
              width: 36,
              imageUrl: widget.reply.person.pfpPath,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.reply.person.userName,
                style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface),
              ),
              const SizedBox(height: 4),
              Text(
                overflow: TextOverflow.clip,
                widget.reply.text,
                style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface),
              ),
              Row(
                children: [
                  TextButton.icon(
                      style: ButtonStyle(
                          iconColor: WidgetStatePropertyAll(
                        widget.reply.isLiked ? Colors.red : Theme.of(context).colorScheme.primary,
                      )),
                      label: Text(
                        widget.reply.likes.toString(),
                      ),
                      onPressed: () {
                        setState(() {
                          if (widget.reply.isLiked) {
                            widget.reply.isLiked = false;
                            widget.reply.likes -= 1;
                            return;
                          }
                          widget.reply.isLiked = true;
                          widget.reply.likes += 1;
                        });
                      },
                      icon: Icon(
                        widget.reply.isLiked ? Icons.favorite : Icons.favorite_outline,
                        size: 22,
                      )),
                  const SizedBox(width: 8),
                  TextButton.icon(
                      label: const Text(
                        "Reply",
                      ),
                      onPressed: () {},
                      icon: Icon(
                        Icons.reply_outlined,
                        size: 24,
                      )),
                ],
              ),
            ],
          )),
        ],
      ),
    );
  }
}

//  setState(() {
                    //isReplyOpen[panelIndex] = isExpanded;
                  //});
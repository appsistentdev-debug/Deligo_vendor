import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:delivoo_store/Chat/MessageBloc/message_bloc.dart';
import 'package:delivoo_store/Components/cached_image.dart';
import 'package:delivoo_store/Components/entry_field.dart';
import 'package:delivoo_store/Constants/constants.dart';
import 'package:delivoo_store/JsonFiles/Chat/chat.dart';
import 'package:delivoo_store/JsonFiles/Chat/message.dart';
import 'package:delivoo_store/Locale/locales.dart';
import 'package:delivoo_store/Themes/colors.dart';
import 'package:delivoo_store/UtilityFunctions/helper.dart';

import 'message_bubble.dart';

class ChattingPage extends StatelessWidget {
  final Chat chat;

  ChattingPage(this.chat);

  @override
  Widget build(BuildContext context) => BlocProvider<MessageBloc>(
        create: (context) => MessageBloc(chat),
        child: ChattingBody(chat),
      );
}

class ChattingBody extends StatefulWidget {
  final Chat chat;

  ChattingBody(this.chat);

  @override
  _ChattingBodyState createState() => _ChattingBodyState();
}

class _ChattingBodyState extends State<ChattingBody> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late MessageBloc _messageBloc;
  List<Message> _messages = [];

  @override
  void initState() {
    _messageBloc = BlocProvider.of<MessageBloc>(context);
    super.initState();
    _messageBloc.add(ShowMessagesEvent());
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            titleAlignment: ListTileTitleAlignment.center,
            dense: true,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedImage(
                widget.chat.chatImage,
                height: 50,
                width: 50,
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.getTranslationOf(
                      (widget.chat.chatId?.contains(Constants.ROLE_USER) ??
                              false)
                          ? "customer"
                          : "delivery_guy"),
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 12, color: Colors.grey, letterSpacing: 0.05),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.chat.chatName ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontSize: 16, letterSpacing: 0.07),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            trailing: FittedBox(
              fit: BoxFit.fill,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      border: Border.all(color: theme.cardColor, width: 1),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.phone,
                        color: kMainColor,
                        size: 20.0,
                      ),
                      onPressed: () => Helper.launchCustomUrl(
                          'tel:${widget.chat.chatStatus}'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      border: Border.all(color: theme.cardColor, width: 1),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: kMainColor,
                        size: 20.0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: BlocListener<MessageBloc, MessageState>(
        listener: (context, state) {
          if (state is MessageSentState) {
            _messageController.clear();
            setState(() {});
          }
          if (state is MessageSuccessState) {
            _messages.addAll(state.messages);
            //_messages = _messages.reversed.toList();
            setState(() {});
            _scrollToBottom();
          }
        },
        child: Container(
          color: theme.cardColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: ListView.separated(
                  controller: _scrollController,
                  physics: BouncingScrollPhysics(),
                  itemCount: _messages.length,
                  //reverse: true,
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 20),
                  itemBuilder: (context, index) => MessageBubble(
                    _messages[index].senderId == widget.chat.myId,
                    _messages[index],
                  ),
                ),
              ),
              // Container(
              //   color: theme.canvasColor,
              //   padding: EdgeInsets.only(
              //       left: 12.0, top: 12.0, bottom: 20, right: 12),
              //   child: EntryField(
              //     controller: _messageController,
              //     inputBorder: InputBorder.none,
              //     hint: AppLocalizations.of(context)!.enterMessage,
              //     textAlignVertical: TextAlignVertical.top,
              //     keyboardType: TextInputType.multiline,
              //     restrictHeight: true,
              //     suffixIcon: IconButton(
              //       icon: Icon(
              //         Icons.send,
              //         color: kMainColor,
              //       ),
              //       onPressed: () {
              //         if (_messageController.text.trim().isNotEmpty) {
              //           _messageBloc.add(
              //               MessageSendEvent(_messageController.text.trim()));
              //         }
              //       },
              //     ),
              //     border: InputBorder.none,
              //   ),
              // ),
              Container(
                color: theme.scaffoldBackgroundColor,
                padding: const EdgeInsets.only(
                    left: 20.0, top: 12.0, bottom: 30, right: 20),
                child: EntryField(
                  controller: _messageController,
                  hint: AppLocalizations.of(context)!.enterMessage,
                  textAlignVertical: TextAlignVertical.top,
                  keyboardType: TextInputType.multiline,
                  restrictHeight: true,
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: theme.primaryColor,
                    ),
                    onPressed: () {
                      if (_messageController.text.trim().isNotEmpty) {
                        _messageBloc.add(
                            MessageSendEvent(_messageController.text.trim()));
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _scrollToBottom() {
    try {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    } catch (e) {
      if (kDebugMode) {
        print("scrollToBottom: $e");
      }
    }
  }
}

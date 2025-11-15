import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:delivoo_store/AppConfig/app_config.dart';
import 'package:delivoo_store/Chat/chat_repository.dart';
import 'package:delivoo_store/Constants/constants.dart';
import 'package:delivoo_store/JsonFiles/Chat/chat.dart';
import 'package:delivoo_store/JsonFiles/Chat/message.dart';
import 'package:delivoo_store/JsonFiles/User/vendor_info.dart';
import 'package:delivoo_store/UtilityFunctions/helper.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';

part 'message_event.dart';

part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final Chat chat;

  StreamSubscription<DatabaseEvent>? _messagesStreamSubscription;

  ChatRepository _chatRepository = ChatRepository();

  MessageBloc(this.chat) : super(MessageLoadingState()) {
    _chatRepository
        .setupDatabaseReferences(_getChatChild(chat.myId!, chat.chatId!));
  }

  @override
  Future<void> close() async {
    await _unRegisterMessageUpdates();
    return super.close();
  }

  @override
  Stream<MessageState> mapEventToState(MessageEvent event) async* {
    if (event is ShowMessagesEvent) {
      yield* _mapShowMessagesToState();
    } else if (event is UpdateMessagesEvent) {
      yield* _mapUpdateMessagesToState(event.messages);
    } else if (event is MessageSendEvent) {
      yield* _mapMessageSentToState(event.messageBody);
    }
  }

  Stream<MessageState> _mapShowMessagesToState() async* {
    if (_messagesStreamSubscription == null) {
      _messagesStreamSubscription = _chatRepository
          .getMessagesFirebaseDbRef()
          .listen((DatabaseEvent event) => _handleFireEvent(event));
    }
  }

  Stream<MessageState> _mapMessageSentToState(String body) async* {
    VendorInfo? vendorInfo = await Helper().getVendorInfo();

    Message message = new Message()
      ..chatId = _getChatChild(chat.myId!, chat.chatId!)
      ..body = body
      ..dateTimeStamp = "${DateTime.now().millisecondsSinceEpoch}"
      ..delivered = false
      ..sent = true
      ..recipientId = chat.chatId
      ..recipientImage = chat.chatImage
      ..recipientName = chat.chatName
      ..recipientStatus = chat.chatStatus
      ..senderId = chat.myId
      ..senderName = vendorInfo?.name ?? ""
      ..senderImage = vendorInfo?.image ?? ""
      ..senderStatus = vendorInfo?.user?.mobileNumber ?? "";

    try {
      await _chatRepository.sendMessage(message);
      yield MessageSentState();
      String chatRole = chat.chatId!.contains(Constants.ROLE_VENDOR)
          ? Constants.ROLE_VENDOR
          : Constants.ROLE_DELIVERY;
      bool notified = await _chatRepository.postNotificationContent(
          chatRole, chat.chatId!.substring(0, chat.chatId!.indexOf(chatRole)));
      print("notified: $notified");
    } catch (e) {
      print("sendMessage: $e");
    }
  }

  Stream<MessageState> _mapUpdateMessagesToState(
      List<Message> messages) async* {
    yield MessageSuccessState(messages);
  }

  void _handleFireEvent(DatabaseEvent event) {
    if (event.snapshot.value != null) {
      try {
        Map resultMap = event.snapshot.value as Map;
        Map<String, dynamic> json = {};
        for (String key in resultMap.keys) json[key] = resultMap[key];
        Message newMessage = Message.fromJson(json);
        newMessage.timeDiff = Helper.formatDateTimeFromMillis(
            int.parse(newMessage.dateTimeStamp!),
            false,
            AppConfig.fireConfig!.enableAmPm);
        if (newMessage.senderId != chat.myId) {
          newMessage.delivered = true;
          _chatRepository.setMessageDelivered(newMessage.id!);
        }
        add(UpdateMessagesEvent([newMessage]));
      } catch (e) {
        print("requestMapCastError: $e");
      }
    }
  }

  _unRegisterMessageUpdates() async {
    if (_messagesStreamSubscription != null) {
      await _messagesStreamSubscription?.cancel();
      _messagesStreamSubscription = null;
    }
  }

  _getChatChild(String userId, String myId) {
    //example: userId="9" and myId="5" -->> chat child = "5-9"
    List<String> values = [userId, myId];
    values.sort();
    return "${values[0]}-${values[1]}";
  }
}

import 'package:delivoo_store/AppConfig/app_config.dart';
import 'package:delivoo_store/Constants/constants.dart';
import 'package:delivoo_store/JsonFiles/Order/Get/order_data.dart';
import 'package:delivoo_store/UtilityFunctions/helper.dart';

import 'message.dart';

class Chat {
  String? chatId;
  String? myId;
  String? dateTimeStamp;
  String? timeDiff;
  String? lastMessage;
  String? chatName;
  String? chatImage;
  String? chatStatus;
  bool? isGroup;
  bool? isRead;

  static Chat fromMessage(Message msg, bool isMeSender) {
    Chat chat = new Chat();
    chat.chatId = isMeSender ? msg.recipientId : msg.senderId;
    chat.myId = isMeSender ? msg.senderId : msg.recipientId;
    chat.chatName = isMeSender ? msg.recipientName : msg.senderName;
    chat.chatImage = isMeSender ? msg.recipientImage : msg.senderImage;
    chat.chatStatus = isMeSender ? msg.recipientStatus : msg.senderStatus;
    chat.dateTimeStamp = msg.dateTimeStamp;
    chat.lastMessage = msg.body;
    chat.timeDiff = Helper.formatDateTimeFromMillis(
        int.parse(chat.dateTimeStamp!),
        false,
        AppConfig.fireConfig!.enableAmPm);
    return chat;
  }

  static Chat fromOrder(OrderData orderData, String roleTo) {
    Chat chat = new Chat();
    chat.chatId = roleTo == Constants.ROLE_USER
        ? "${(orderData.userId ?? orderData.meta?.customer_id)}${Constants.ROLE_USER}"
        : "${orderData.delivery?.delivery?.user?.id}${Constants.ROLE_DELIVERY}";
    chat.chatImage = roleTo == Constants.ROLE_USER
        ? (orderData.user?.image ?? orderData.meta?.customer_image)
        : orderData.delivery?.delivery?.user?.image;
    chat.chatName = roleTo == Constants.ROLE_USER
        ? (orderData.user?.name ?? orderData.customerName)
        : orderData.delivery?.delivery?.user?.name;
    chat.chatStatus = roleTo == Constants.ROLE_USER
        ? (orderData.user?.mobileNumber ?? orderData.customerMobile)
        : orderData.delivery?.delivery?.user?.mobileNumber;
    chat.myId = "${orderData.vendor?.userId}${Constants.ROLE_VENDOR}";
    return chat;
  }
}

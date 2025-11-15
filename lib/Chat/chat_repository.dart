import 'package:delivoo_store/AppConfig/app_config.dart';
import 'package:delivoo_store/Constants/constants.dart';
import 'package:delivoo_store/JsonFiles/Chat/message.dart';
import 'package:delivoo_store/UtilityFunctions/helper.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ChatRepository {
  final Dio dio;
  late DatabaseReference _chatRef, _inboxRef;

  ChatRepository._(this.dio);

  factory ChatRepository() {
    Dio dio = Dio();
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
    dio.options.headers = {
      "content-type": "application/json",
      'Accept': 'application/json'
    };
    return ChatRepository._(dio);
  }

  void setupDatabaseReferences(String chatChild) {
    _chatRef = FirebaseDatabase.instance
        .ref()
        .child(Constants.REF_CHAT)
        .child(chatChild);
    _inboxRef = FirebaseDatabase.instance.ref().child(Constants.REF_INBOX);
  }

  Stream<DatabaseEvent> getMessagesFirebaseDbRef() {
    return _chatRef.limitToLast(50).onChildAdded;
  }

  Future<void> setMessageDelivered(String messageId) {
    return _chatRef.child(messageId).child("delivered").set(true);
  }

  Future<void> sendMessage(Message message) async {
    message.id = _chatRef.child(message.chatId!).push().key ?? "";
    await _chatRef.child(message.id!).set(message.toJson());
    await _inboxRef
        .child(message.recipientId!)
        .child(message.senderId!)
        .set(message.toJson());
    await _inboxRef
        .child(message.senderId!)
        .child(message.recipientId!)
        .set(message.toJson());
  }

  Future<bool> postNotificationContent(String roleTo, String userIdTo,
      [String title = "", String body = ""]) async {
    try {
      String authToken = await Helper().getAuthToken() ?? "";
      const _extra = <String, dynamic>{};
      final queryParameters = <String, dynamic>{};
      if (title.isNotEmpty) queryParameters["message_title"] = title;
      if (body.isNotEmpty) queryParameters["message_body"] = body;
      final _data = <String, dynamic>{};
      _data["role"] = roleTo;
      _data["user_id"] = userIdTo;
      final _result = await dio.request<Map<String, dynamic>>(
          '${AppConfig.baseUrl}api/user/push-notification',
          queryParameters: queryParameters,
          options: Options(
            method: 'POST',
            headers: <String, dynamic>{"Authorization": "Bearer $authToken"},
            extra: _extra,
          ),
          data: _data);
      if (_result.statusCode != null) {
        return _result.statusCode! > 199 && _result.statusCode! < 300;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}

import 'package:joy_app/core/constants/endpoints.dart';
import 'package:joy_app/core/network/request.dart';

import '../model/create_conversation_model.dart';

class ChatApi {
  final DioClient _dioClient;

  ChatApi(this._dioClient);

  Future<CreateConversation> createConversation(
      int userId, int friendId, String userName, String friendName) async {
    try {
      final result = await _dioClient.postCustomize(
          Endpoints.chatBaseUrl + Endpoints.createConversation,
          data: {
            "userId": userId,
            "friendId": friendId,
            "userName": userName,
            "friendName": friendName
          });

      return CreateConversation.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    } finally {}
  }
}

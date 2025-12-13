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
          Endpoints.chatRestBase + Endpoints.chatEnsureConversation,
          data: {
            "user_id": userId,
            "user_type": 'user',
            "peer_id": friendId,
            "peer_type": 'user'
          });

      return CreateConversation.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    } finally {}
  }
}

import 'package:joy_app/core/constants/endpoints.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/core/network/utils/token.dart';

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

  Future<List<dynamic>> getMyConversations(String userId, String userType) async {
    try {
      final url = '${Endpoints.chatRestBase}${Endpoints.chatMyConversations}?user_id=$userId&user_type=$userType';
      
      // Get actual token for cURL logging
      String? actualToken;
      try {
        actualToken = await getToken();
      } catch (e) {
        actualToken = null;
      }
      
      // Log complete cURL command with actual token
      print('📡 [ChatApi] ========== cURL for getMyConversations ==========');
      print('curl --location --request GET \'$url\' \\');
      if (actualToken != null) {
        print('  --header \'Authorization: Bearer $actualToken\'');
      } else {
        print('  --header \'Authorization: Bearer {YOUR_TOKEN}\'');
      }
      print('📡 [ChatApi] ==================================================');
      print('🌐 [ChatApi] GET $url');
      
      final result = await _dioClient.get(url);
      print('✅ [ChatApi] My conversations response: ${result}');
      
      if (result is Map && result['data'] != null) {
        return List.from(result['data']);
      } else if (result is List) {
        return List.from(result);
      }
      return [];
    } catch (e) {
      print('❌ [ChatApi] Error getting conversations: $e');
      throw e;
    }
  }
}

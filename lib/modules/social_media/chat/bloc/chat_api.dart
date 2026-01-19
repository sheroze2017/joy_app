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
      // Use relative path since DioClient already has baseUrl configured
      final endpoint = Endpoints.chatMyConversations; // Just '/chat/myConversations'
      final queryParams = {
        'user_id': userId,
        'user_type': userType,
      };
      final fullUrl = '${Endpoints.chatRestBase}$endpoint?user_id=$userId&user_type=$userType';
      
      // Get actual token for cURL logging
      String? actualToken;
      try {
        actualToken = await getToken();
      } catch (e) {
        actualToken = null;
      }
      
      // Log complete cURL command with actual token
      print('📡 [ChatApi] ========== cURL for getMyConversations ==========');
      print('curl --location --request GET \'$fullUrl\' \\');
      if (actualToken != null) {
        print('  --header \'Authorization: Bearer $actualToken\'');
      } else {
        print('  --header \'Authorization: Bearer {YOUR_TOKEN}\'');
      }
      print('📡 [ChatApi] ==================================================');
      print('🌐 [ChatApi] GET $endpoint with query params: $queryParams');
      print('🌐 [ChatApi] Full URL would be: $fullUrl');
      
      // Use relative path with query parameters - DioClient will prepend baseUrl automatically
      final result = await _dioClient.get(endpoint, queryParameters: queryParams);
      print('✅ [ChatApi] My conversations response type: ${result.runtimeType}');
      print('✅ [ChatApi] My conversations response: ${result}');
      
      if (result is Map && result['data'] != null) {
        final dataList = result['data'];
        print('📥 [ChatApi] Extracted data list type: ${dataList.runtimeType}');
        print('📥 [ChatApi] Extracted data list length: ${dataList is List ? dataList.length : 'not a list'}');
        if (dataList is List) {
          print('📥 [ChatApi] Returning ${dataList.length} conversations');
          return List.from(dataList);
        } else {
          print('⚠️ [ChatApi] Data is not a list, returning empty list');
          return [];
        }
      } else if (result is List) {
        print('📥 [ChatApi] Result is directly a list, returning ${result.length} conversations');
        return List.from(result);
      }
      print('⚠️ [ChatApi] No data found in response, returning empty list');
      return [];
    } catch (e) {
      print('❌ [ChatApi] Error getting conversations: $e');
      throw e;
    }
  }
}

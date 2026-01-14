import 'package:dio/dio.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:joy_app/core/constants/endpoints.dart';
import 'package:joy_app/core/network/utils/token.dart';

class ChatService {
  final Dio dio;
  IO.Socket? socket;

  ChatService(this.dio);

  Future<String> ensureConversation({
    required dynamic userId, // Changed to dynamic to accept both String and int
    required String userType,
    required dynamic peerId, // Changed to dynamic to accept both String and int
    required String peerType,
  }) async {
    try {
      // Convert to string if needed (MongoDB ObjectIds are strings)
      final userIdStr = userId.toString();
      final peerIdStr = peerId.toString();
      
      final url = Endpoints.chatRestBase + Endpoints.chatEnsureConversation;
      final payload = {
        'user_id': userIdStr,
        'user_type': userType,
        'peer_id': peerIdStr,
        'peer_type': peerType,
      };
      
      // Get actual token for cURL logging
      String? actualToken;
      try {
        final token = await getToken();
        actualToken = token;
      } catch (e) {
        actualToken = null;
      }
      
      // Log complete cURL command with actual token
      final jsonPayload = '{"user_id":"$userIdStr","user_type":"$userType","peer_id":"$peerIdStr","peer_type":"$peerType"}';
      print('📡 [ChatService] ========== cURL for ensureConversation ==========');
      print('curl --location --request POST \'$url\' \\');
      if (actualToken != null) {
        print('  --header \'Authorization: Bearer $actualToken\' \\');
      } else {
        print('  --header \'Authorization: Bearer {YOUR_TOKEN}\' \\');
      }
      print('  --header \'Content-Type: application/json\' \\');
      print('  --data-raw \'$jsonPayload\'');
      print('📡 [ChatService] ================================================');
      print('[Chat] POST $url');
      print('[Chat] payload: $payload');
      
      final res = await dio.post(
        url,
        data: payload,
      );
      print('[Chat] ensureConversation response: ${res.data}');

      final data = res.data;
      if (data is Map) {
        final d = data['data'];
        if (d is Map && d['id'] != null) {
          final v = d['id'];
          if (v is num) return v.toString();
          if (v is String) return v;
        }
        if (d is num) return d.toString();
        if (d is String) return d;
        if (data['id'] != null) {
          final v = data['id'];
          if (v is num) return v.toString();
          if (v is String) return v;
        }
      } else if (data is num) {
        return data.toString();
      } else if (data is String) {
        return data;
      }
      throw Exception('ensureConversation unexpected response: $data');
    } on DioException catch (e) {
      final msg = e.response?.data ?? e.message;
      print('[Chat][ERROR] ensureConversation failed: $msg');
      throw Exception('ensureConversation failed: $msg');
    }
  }

  Future<List<dynamic>> getMessages(
    String conversationId, {
    int limit = 50,
    int? before,
  }) async {
    try {
      final url = Endpoints.chatRestBase + Endpoints.chatMessages;
      final queryParams = {
        'conversation_id': conversationId,
        'limit': limit,
        if (before != null) 'before': before,
      };
      final queryString = queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');
      
      // Get actual token for cURL logging
      String? actualToken;
      try {
        final token = await getToken();
        actualToken = token;
      } catch (e) {
        actualToken = null;
      }
      
      // Log complete cURL command with actual token
      print('📡 [ChatService] ========== cURL for getMessages ==========');
      print('curl --location --request GET \'$url?$queryString\' \\');
      if (actualToken != null) {
        print('  --header \'Authorization: Bearer $actualToken\'');
      } else {
        print('  --header \'Authorization: Bearer {YOUR_TOKEN}\'');
      }
      print('📡 [ChatService] ============================================');
      print('[Chat] GET $url?$queryString');
      
      final res = await dio.get(
        url,
        queryParameters: queryParams,
      );
      print('[Chat] messages response: ${res.data}');
      final data = res.data;
      if (data is Map && data['data'] is List) return List.from(data['data']);
      if (data is List) return List.from(data);
      return [];
    } on DioException catch (e) {
      final msg = e.response?.data ?? e.message;
      print('[Chat][ERROR] getMessages failed: $msg');
      throw Exception('getMessages failed: $msg');
    }
  }

  void connectSocket({required dynamic userId, required String userType}) {
    print('[Socket] connecting: ${Endpoints.chatSocketBase}');
    socket = IO.io(
      Endpoints.chatSocketBase,
      IO.OptionBuilder().setTransports(['websocket']).enableAutoConnect().build(),
    );

    socket!.onConnect((_) {
      print('[Socket] connected');
      final payload = {'user_id': userId.toString(), 'user_type': userType};
      print('[Socket] emit auth: ' + payload.toString());
      socket!.emit('auth', payload);
    });
  }

  void joinConversation(String conversationId) {
    final payload = {'conversation_id': conversationId};
    print('[Socket] emit join_conversation: ' + payload.toString());
    socket?.emit('join_conversation', payload);
  }

  void onMessage(void Function(dynamic data) handler) {
    socket?.on('message', handler);
  }

  void sendMessage({
    required String conversationId,
    required dynamic senderId, // Changed to dynamic to accept both String and int
    required String senderType,
    required dynamic receiverId, // Changed to dynamic to accept both String and int
    required String receiverType,
    String? body,
    String? mediaUrl,
  }) {
    final payload = {
      'conversation_id': conversationId,
      'sender_id': senderId.toString(), // Convert to string
      'sender_type': senderType,
      'receiver_id': receiverId.toString(), // Convert to string
      'receiver_type': receiverType,
      'body': body,
      'media_url': mediaUrl,
    };
    print('📤 [Socket] Sending message via socket:');
    print('📤 [Socket] Event: send_message');
    print('📤 [Socket] Payload: $payload');
    socket?.emit('send_message', payload);
  }

  Future<bool> markMessageAsRead({
    required String messageId,
    required dynamic readerId,
    required String readerType,
  }) async {
    try {
      final url = Endpoints.chatRestBase + Endpoints.chatMarkRead;
      final payload = {
        'message_id': messageId,
        'reader_id': readerId.toString(),
        'reader_type': readerType,
      };
      
      // Get actual token for cURL logging
      String? actualToken;
      try {
        final token = await getToken();
        actualToken = token;
      } catch (e) {
        actualToken = null;
      }
      
      // Log complete cURL command
      final jsonPayload = '{"message_id":"$messageId","reader_id":"${readerId.toString()}","reader_type":"$readerType"}';
      print('📡 [ChatService] ========== cURL for markRead ==========');
      print('curl --location --request POST \'$url\' \\');
      if (actualToken != null) {
        print('  --header \'Authorization: Bearer $actualToken\' \\');
      } else {
        print('  --header \'Authorization: Bearer {YOUR_TOKEN}\' \\');
      }
      print('  --header \'Content-Type: application/json\' \\');
      print('  --data-raw \'$jsonPayload\'');
      print('📡 [ChatService] =======================================');
      
      final res = await dio.post(url, data: payload);
      print('[Chat] markRead response: ${res.data}');
      
      final data = res.data;
      if (data is Map) {
        return data['sucess'] ?? data['success'] ?? false;
      }
      return false;
    } on DioException catch (e) {
      final msg = e.response?.data ?? e.message;
      print('[Chat][ERROR] markRead failed: $msg');
      return false;
    }
  }

  void dispose() {
    socket?.dispose();
  }
}



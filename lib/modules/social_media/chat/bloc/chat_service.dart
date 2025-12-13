import 'package:dio/dio.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:joy_app/core/constants/endpoints.dart';

class ChatService {
  final Dio dio;
  IO.Socket? socket;

  ChatService(this.dio);

  Future<String> ensureConversation({
    required int userId,
    required String userType,
    required int peerId,
    required String peerType,
  }) async {
    try {
      print('[Chat] POST ${Endpoints.chatRestBase + Endpoints.chatEnsureConversation}');
      print('[Chat] payload: {user_id: $userId, user_type: $userType, peer_id: $peerId, peer_type: $peerType}');
      final res = await dio.post(
        Endpoints.chatRestBase + Endpoints.chatEnsureConversation,
        data: {
          'user_id': userId,
          'user_type': userType,
          'peer_id': peerId,
          'peer_type': peerType,
        },
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
      print('[Chat] GET $url?conversation_id=$conversationId&limit=$limit${before != null ? '&before=$before' : ''}');
      final res = await dio.get(
        url,
        queryParameters: {
          'conversation_id': conversationId,
          'limit': limit,
          if (before != null) 'before': before,
        },
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

  void connectSocket({required int userId, required String userType}) {
    print('[Socket] connecting: ${Endpoints.chatSocketBase}');
    socket = IO.io(
      Endpoints.chatSocketBase,
      IO.OptionBuilder().setTransports(['websocket']).enableAutoConnect().build(),
    );

    socket!.onConnect((_) {
      print('[Socket] connected');
      final payload = {'user_id': userId, 'user_type': userType};
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
    required int senderId,
    required String senderType,
    required int receiverId,
    required String receiverType,
    String? body,
    String? mediaUrl,
  }) {
    final payload = {
      'conversation_id': conversationId,
      'sender_id': senderId,
      'sender_type': senderType,
      'receiver_id': receiverId,
      'receiver_type': receiverType,
      'body': body,
      'media_url': mediaUrl,
    };
    print('[Socket] emit send_message: ' + payload.toString());
    socket?.emit('send_message', payload);
  }

  void dispose() {
    socket?.dispose();
  }
}



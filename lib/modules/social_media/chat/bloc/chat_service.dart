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

  void connectSocket({required dynamic userId, required String userType}) async {
    print('🔌 [Socket] ========== CONNECTING SOCKET ==========');
    print('🔌 [Socket] Base URL: ${Endpoints.chatSocketBase}');
    print('🔌 [Socket] User ID: $userId');
    print('🔌 [Socket] User Type: $userType');
    
    // Get authentication token
    String? token;
    try {
      token = await getToken();
      print('🔌 [Socket] Token retrieved: ${token != null ? "Yes (${token.substring(0, 20)}...)" : "No"}');
    } catch (e) {
      print('⚠️ [Socket] Failed to get token: $e');
      token = null;
    }
    
    // CRITICAL FIX: Socket.IO client adds :0 when URL parsing fails
    // We MUST provide a clean URL with NO port, NO path, NO query
    // Hardcode the exact URL to prevent any parsing issues that cause :0 port
    String socketUrl = 'https://joy.comsrvssoftwaresolutions.com';
    
    // Verify baseUrl matches (for debugging)
    final baseUrl = Endpoints.chatSocketBase;
    if (baseUrl != socketUrl) {
      try {
        final uri = Uri.parse(baseUrl);
        final cleaned = '${uri.scheme}://${uri.host}';
        if (cleaned == socketUrl) {
          print('🔌 [Socket] Base URL cleaned correctly: $baseUrl -> $socketUrl');
        } else {
          print('⚠️ [Socket] Base URL mismatch: $baseUrl -> $cleaned, using hardcoded: $socketUrl');
        }
      } catch (e) {
        print('⚠️ [Socket] Using hardcoded URL due to parsing error: $e');
      }
    }
    
    // Final verification: URL MUST be exactly "https://joy.comsrvssoftwaresolutions.com"
    // No port, no path, no trailing slash, no query parameters
    assert(socketUrl == 'https://joy.comsrvssoftwaresolutions.com',
        'Socket URL must be exactly "https://joy.comsrvssoftwaresolutions.com" without port');
    
    print('🔌 [Socket] ========== FINAL URL VERIFICATION ==========');
    print('🔌 [Socket] Base URL from Endpoints: $baseUrl');
    print('🔌 [Socket] Final Socket URL: $socketUrl');
    print('🔌 [Socket] Expected: https://joy.comsrvssoftwaresolutions.com');
    print('🔌 [Socket] Match: ${socketUrl == "https://joy.comsrvssoftwaresolutions.com"}');
    print('🔌 [Socket] Socket.io will use: wss://joy.comsrvssoftwaresolutions.com/socket.io/');
    print('🔌 [Socket] ============================================');
    
    // Build extra headers for authentication
    Map<String, dynamic> extraHeaders = {};
    if (token != null && token.isNotEmpty) {
      extraHeaders['Authorization'] = 'Bearer $token';
      print('🔌 [Socket] Adding Authorization header to socket connection');
    }
    
    // CRITICAL: Ensure socketUrl is exactly "https://joy.comsrvssoftwaresolutions.com"
    // No port, no path, no trailing slash
    // Socket.IO client will add :0 if URL format is incorrect
    assert(socketUrl == 'https://joy.comsrvssoftwaresolutions.com',
        'Socket URL must be exactly "https://joy.comsrvssoftwaresolutions.com"');
    
    print('🔌 [Socket] Creating socket with URL: $socketUrl');
    print('🔌 [Socket] Socket.IO will construct: wss://joy.comsrvssoftwaresolutions.com/socket.io/');
    
    // Create socket with explicit configuration to prevent :0 port issue
    socket = IO.io(
      socketUrl, // MUST be exactly "https://joy.comsrvssoftwaresolutions.com" with NO port
      IO.OptionBuilder()
        .setTransports(['websocket', 'polling']) // REQUIRED: WebSocket with polling fallback
        .setPath('/socket.io/') // REQUIRED: Explicit path for reverse proxy
        .enableAutoConnect()
        .enableReconnection()
        .setReconnectionAttempts(5)
        .setReconnectionDelay(1000)
        .setReconnectionDelayMax(5000)
        .setTimeout(5000)
        .setQuery({'EIO': '4'}) // Explicitly set Engine.IO version to prevent parsing issues
        .setExtraHeaders(extraHeaders) // Add auth headers
        .build(),
    );
    
    print('🔌 [Socket] Socket created with explicit path and query parameters');
    print('🔌 [Socket] Waiting for connection...');

    // Connection status listeners
    socket!.onConnect((_) {
      print('✅ [Socket] ========== CONNECTED SUCCESSFULLY ==========');
      print('✅ [Socket] Socket ID: ${socket!.id}');
      print('✅ [Socket] Connected: ${socket!.connected}');
      final payload = {'user_id': userId.toString(), 'user_type': userType};
      print('🔐 [Socket] Emitting auth event with payload: $payload');
      socket!.emit('auth', payload);
      print('✅ [Socket] Auth event emitted');
    });

    socket!.onDisconnect((_) {
      print('❌ [Socket] ========== DISCONNECTED ==========');
      print('❌ [Socket] Reason: ${socket!.disconnected}');
    });

    socket!.onConnectError((error) {
      print('❌ [Socket] ========== CONNECTION ERROR ==========');
      print('❌ [Socket] Error: $error');
    });

    socket!.onError((error) {
      print('❌ [Socket] ========== SOCKET ERROR ==========');
      print('❌ [Socket] Error: $error');
    });

    socket!.onReconnect((attempt) {
      print('🔄 [Socket] Reconnecting... Attempt: $attempt');
    });

    socket!.onReconnectAttempt((attempt) {
      print('🔄 [Socket] Reconnection attempt: $attempt');
    });

    socket!.onReconnectError((error) {
      print('❌ [Socket] Reconnection error: $error');
    });

    socket!.onReconnectFailed((_) {
      print('❌ [Socket] Reconnection failed after max attempts');
    });

    // Log current connection status
    print('🔌 [Socket] Initial connection status: ${socket!.connected}');
    print('🔌 [Socket] Socket ID: ${socket!.id}');
    print('🔌 [Socket] ============================================');
  }

  void joinConversation(String conversationId) {
    print('🚪 [Socket] ========== JOINING CONVERSATION ==========');
    print('🚪 [Socket] Conversation ID: $conversationId');
    print('🚪 [Socket] Socket connected: ${socket?.connected ?? false}');
    print('🚪 [Socket] Socket ID: ${socket?.id ?? "null"}');
    
    final payload = {'conversation_id': conversationId};
    print('🚪 [Socket] Emitting join_conversation event with payload: $payload');
    socket?.emit('join_conversation', payload);
    
    // Also try alternative event names
    socket?.emit('join', payload);
    socket?.emit('joinRoom', payload);
    
    print('🚪 [Socket] Join events emitted');
    print('🚪 [Socket] ===========================================');
  }

  void onMessage(void Function(dynamic data) handler) {
    print('👂 [Socket] ========== SETTING UP MESSAGE LISTENERS ==========');
    print('👂 [Socket] Socket connected: ${socket?.connected ?? false}');
    print('👂 [Socket] Socket ID: ${socket?.id ?? "null"}');
    
    // Listen to multiple possible event names (server might use different names)
    socket?.on('message', (data) {
      print('📨 [Socket] Received event "message": $data');
      handler(data);
    });
    
    socket?.on('receive_message', (data) {
      print('📨 [Socket] Received event "receive_message": $data');
      handler(data);
    });
    
    socket?.on('new_message', (data) {
      print('📨 [Socket] Received event "new_message": $data');
      handler(data);
    });
    
    socket?.on('message_received', (data) {
      print('📨 [Socket] Received event "message_received": $data');
      handler(data);
    });
    
    // Listen to all events for debugging (helps identify what events server sends)
    socket?.onAny((event, data) {
      print('🔔 [Socket] Received ANY event: "$event"');
      print('🔔 [Socket] Event data: $data');
      // If it's a message-related event, also call handler
      if (event.toString().toLowerCase().contains('message')) {
        print('🔔 [Socket] This looks like a message event, forwarding to handler');
        handler(data);
      }
    });
    
    print('👂 [Socket] Message listeners set up for: message, receive_message, new_message, message_received');
    print('👂 [Socket] Also listening to all events for debugging');
    print('👂 [Socket] ===================================================');
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



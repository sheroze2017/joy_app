import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/Widgets/appbar/chat_appbar.dart';
import 'package:joy_app/core/constants/endpoints.dart';
import 'package:joy_app/theme.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:joy_app/modules/social_media/chat/bloc/chat_service.dart';
import '../widgets/message_widget.dart';
import 'package:joy_app/core/network/request.dart';

// legacy unused globals removed

class DirectMessageScreen extends StatefulWidget {
  final String userName;
  final String userAsset;
  final String userId;
  final String friendId;
  final String senderType; // user, doctor, pharmacy, hospital, bloodbank
  final String receiverType;
  DirectMessageScreen({
    super.key,
    required this.userName,
    required this.userAsset,
    required this.userId,
    required this.friendId,
    this.senderType = 'user',
    this.receiverType = 'user',
  });

  @override
  State<DirectMessageScreen> createState() => _DirectMessageScreenState();
}

class _DirectMessageScreenState extends State<DirectMessageScreen> {
  final chatMsgTextController = TextEditingController();
  late IO.Socket socket;
  ChatService? chatService;
  String? conversationId;
  StreamSocket streamSocket = StreamSocket();
  List<MessageBubble> messageWidgets = [];
  Set<String> processedMessageIds = {}; // Track processed message IDs to prevent duplicates
  bool _isLoading = false;
  String? _loadError;
  // ChatController not needed in new flow
  
  // Helper function to normalize IDs for comparison (handle both string and number formats)
  String _normalizeId(dynamic id) {
    if (id == null) return '';
    final str = id.toString().trim();
    // Remove any ObjectId wrapper if present and normalize to lowercase
    return str.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toLowerCase();
  }

  @override
  void initState() {
    super.initState();
    // Clear previous messages when opening chat
    messageWidgets.clear();
    processedMessageIds.clear(); // Clear processed IDs
    print("************** ${DateTime.now().toString()} *****************");
    connectAndListen();
  }

  void connectAndListen() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });

    // Build service - use DioClient to get Dio with interceptors (Bearer token)
    final dio = DioClient.createDio();
    dio.options.baseUrl = Endpoints.chatRestBase;
    chatService = ChatService(dio);

    try {
      // Ensure conversation (user IDs are strings, not ints)
      final ensuredConversationId = await chatService!.ensureConversation(
        userId: widget.userId, // Pass as string
        userType: widget.senderType,
        peerId: widget.friendId, // Pass as string
        peerType: widget.receiverType,
      );
      conversationId = ensuredConversationId;
      print('[Chat] Conversation ID: $conversationId');

      // Connect socket + auth
      chatService!.connectSocket(
        userId: widget.userId, // Pass as string
        userType: widget.senderType,
      );

      // Join conversation room
      chatService!.joinConversation(conversationId!);

      // Load history
      await loadHistory();

      // Listen for new messages
      chatService!.onMessage((data) async {
        print('📨 [Socket] Received message: ${data.toString()}');
        // Handle message structure from guide: _id, conversationId, senderId, senderType, receiverId, receiverType, body, mediaUrl, status, createdAt
        final messageId = data['_id']?.toString() ?? '';
        final senderIdRaw = data['senderId'] ?? data['sender_id'];
        final senderId = senderIdRaw?.toString() ?? '';
        final senderType = (data['senderType'] ?? data['sender_type'])?.toString() ?? '';
        final conversationIdFromMsg = (data['conversationId'] ?? data['conversation_id'])?.toString() ?? '';
        final body = data['body']?.toString() ?? '';
        
        // Only process messages for this conversation
        if (conversationIdFromMsg.isNotEmpty && conversationIdFromMsg != conversationId) {
          print('⚠️ [Socket] Ignoring message from different conversation: $conversationIdFromMsg (current: $conversationId)');
          return;
        }
        
        // Handle "NaN" sender_id case - if sender_id is "NaN" or invalid, check sender_type
        bool isCurrentUser = false;
        String normalizedSenderId = '';
        String normalizedUserId = '';
        
        if (senderId.toLowerCase() == 'nan' || senderId.isEmpty) {
          // If sender_id is NaN, check if sender_type matches and assume it's our message if type matches
          // This is a workaround for backend issue where sender_id is "NaN"
          if (senderType.toLowerCase() == widget.senderType.toLowerCase()) {
            isCurrentUser = true;
            print('⚠️ [Chat] Socket: sender_id is "NaN", but sender_type matches, assuming current user message');
          }
          normalizedSenderId = senderId;
          normalizedUserId = widget.userId;
        } else {
          // Normalize IDs for comparison (handle both string and number formats)
          normalizedSenderId = _normalizeId(senderId);
          normalizedUserId = _normalizeId(widget.userId);
          isCurrentUser = normalizedSenderId.isNotEmpty && 
                         normalizedUserId.isNotEmpty && 
                         normalizedSenderId == normalizedUserId;
        }
        
        print('📨 [Chat] Real-time message - id: $messageId, sender: "$normalizedSenderId" (raw: "$senderId"), current user: "$normalizedUserId" (raw: "${widget.userId}"), isCurrentUser: $isCurrentUser, body: $body');
        
        // Check if message already exists (avoid duplicates)
        bool messageExists = false;
        if (messageId.isNotEmpty) {
          // Check by messageId first (most reliable)
          messageExists = processedMessageIds.contains(messageId);
        }
        
        // Also check by text and sender to catch duplicates (including optimistic messages)
        if (!messageExists) {
          // Find optimistic message with same text from current user
          if (isCurrentUser) {
            final optimisticIndex = messageWidgets.indexWhere((msg) => 
              msg.msgText == body && 
              msg.user == true // Sent message (right side)
            );
            
            if (optimisticIndex != -1) {
              // Replace optimistic message with real one
              messageExists = true;
              if (mounted) {
                setState(() {
                  messageWidgets[optimisticIndex] = MessageBubble(
                    msgText: body,
                    msgSender: "You",
                    user: true, // Always right side for sent messages
                    sending: false, // No longer sending
                    receiverImage: widget.userAsset,
                  );
                  if (messageId.isNotEmpty) {
                    processedMessageIds.add(messageId);
                  }
                });
              }
              print('✅ [Chat] Replaced optimistic message with real message: $messageId');
              return; // Don't add again - IMPORTANT: prevents duplicate
            }
          }
          
          // Check for other duplicates (including if message already exists with same text and alignment)
          messageExists = messageWidgets.any((msg) => 
            msg.msgText == body && 
            ((isCurrentUser && msg.user == true) || (!isCurrentUser && msg.user == false))
          );
        }
        
        // CRITICAL: If message is from current user but isCurrentUser is false, fix it
        // This handles cases where ID comparison failed but we know it's our message
        bool shouldBeRightSide = isCurrentUser;
        if (!isCurrentUser && body.isNotEmpty) {
          // Double-check: if we just sent this message (check optimistic messages)
          final recentOptimistic = messageWidgets.any((msg) => 
            msg.msgText == body && 
            msg.user == true && 
            msg.sending == true
          );
          if (recentOptimistic) {
            shouldBeRightSide = true;
            print('⚠️ [Chat] Fixing alignment: message from current user incorrectly identified, forcing right side');
          }
        }
        
        if (!messageExists && body.isNotEmpty) {
          // Mark as processed
          if (messageId.isNotEmpty) {
            processedMessageIds.add(messageId);
          }
          final msgBubble = MessageBubble(
            msgText: body,
            msgSender: shouldBeRightSide ? 'You' : widget.userName,
            user: shouldBeRightSide, // true = right side (sent), false = left side (received)
            receiverImage: widget.userAsset,
          );
          if (mounted) {
            setState(() {
              messageWidgets.add(msgBubble);
            });
          }
          
          // Mark as read if message is from peer and user is viewing chat
          if (!isCurrentUser && messageId.isNotEmpty) {
            try {
              await chatService!.markMessageAsRead(
                messageId: messageId,
                readerId: widget.userId,
                readerType: widget.senderType,
              );
            } catch (e) {
              print('⚠️ [Chat] Failed to mark message as read: $e');
            }
          }
        } else {
          print('⚠️ [Chat] Duplicate message detected, skipping');
        }
      });
    } catch (e) {
      print('[Chat][ERROR] connectAndListen failed: $e');
      if (mounted) {
        setState(() {
          _loadError = 'Failed to connect: ${e.toString()}';
          _isLoading = false;
        });
      }
      return;
    }
  }

  @override
  void dispose() {
    chatService?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(
        username: widget.userName.isNotEmpty ? widget.userName : 'User',
        status: _isLoading
            ? 'Loading...'
            : (_loadError != null ? 'Error' : 'Offline'),
        userId: widget.friendId,
        userImage: widget.userAsset,
      ),
      body: Column(
        children: [
          if (_loadError != null)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red.withValues(alpha: 0.7),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Unable to load chat',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: ThemeUtil.isDarkMode(context)
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _loadError!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ThemeUtil.isDarkMode(context)
                              ? Colors.white70
                              : Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          connectAndListen();
                        },
                        icon: Icon(Icons.refresh),
                        label: Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ThemeUtil.isDarkMode(context)
                              ? Color(0xffC5D3E3)
                              : Color(0xff1C2A3A),
                          foregroundColor: ThemeUtil.isDarkMode(context)
                              ? Color(0xff1C2A3A)
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else if (_isLoading)
            Expanded(
                child: Center(
                    child: CircularProgressIndicator(
              color: ThemeUtil.isDarkMode(context)
                  ? Color(0xffC5D3E3)
                  : Color(0xff1C2A3A),
            )))
          else
            Expanded(
              child: messageWidgets.isEmpty
                  ? Center(
                      child: Text(
                        'No messages yet\nSay hi to start the conversation!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ThemeUtil.isDarkMode(context)
                              ? Colors.white70
                              : Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.builder(
                      reverse: true,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      itemCount: messageWidgets.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 12),
                          child: messageWidgets.reversed.toList()[index],
                        );
                      },
                    ),
            ),
          Container(
            padding: EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                    child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: ThemeUtil.isDarkMode(context)
                        ? Color(0xff121212)
                        : Color(0x05000000),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onSubmitted: (value) {
                            if (chatMsgTextController.text.trim().isEmpty) return;
                            final messageText = chatMsgTextController.text.trim();
                            chatMsgTextController.clear();
                            
                            // Add message optimistically (immediate UI feedback)
                            final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}_${messageText.hashCode}';
                            final optimisticBubble = MessageBubble(
                              msgText: messageText,
                              msgSender: "You",
                              user: true, // Always right side for sent messages
                              sending: true,
                              receiverImage: widget.userAsset,
                            );
                            setState(() {
                              messageWidgets.add(optimisticBubble);
                              processedMessageIds.add(tempId); // Track temp ID
                            });
                            
                            // Send message (IDs are strings, not ints)
                            chatService?.sendMessage(
                              conversationId: conversationId!,
                              senderId: widget.userId, // Pass as string
                              senderType: widget.senderType,
                              receiverId: widget.friendId, // Pass as string
                              receiverType: widget.receiverType,
                              body: messageText,
                            );
                          },
                          controller: chatMsgTextController,
                          maxLines: null,
                          textInputAction: TextInputAction.newline,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                              border: InputBorder.none,
                              hintText: 'Type a message...',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              fillColor: Colors.transparent),
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.emoji_emotions_outlined,
                        color: Color(0xffA5ABB3),
                        size: 24,
                      )
                    ],
                  ),
                )),
                SizedBox(width: 10),
                InkWell(
                    onTap: () {
                      if (chatMsgTextController.text.trim().isEmpty) return;
                      final messageText = chatMsgTextController.text.trim();
                      chatMsgTextController.clear();
                      
                      // Add message optimistically (immediate UI feedback)
                      final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}_${messageText.hashCode}';
                      final optimisticBubble = MessageBubble(
                        msgText: messageText,
                        msgSender: "You",
                        user: true, // Always right side for sent messages
                        sending: true,
                        receiverImage: widget.userAsset,
                      );
                      setState(() {
                        messageWidgets.add(optimisticBubble);
                        processedMessageIds.add(tempId); // Track temp ID
                      });
                      
                      // Send message (IDs are strings, not ints)
                      chatService?.sendMessage(
                        conversationId: conversationId!,
                        senderId: widget.userId, // Pass as string
                        senderType: widget.senderType,
                        receiverId: widget.friendId, // Pass as string
                        receiverType: widget.receiverType,
                        body: messageText,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: ThemeUtil.isDarkMode(context)
                            ? Color(0xffC5D3E3)
                            : Color(0xff1C2A3A),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        'Assets/icons/send-2.svg',
                        width: 20,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          ThemeUtil.isDarkMode(context)
                              ? Color(0xff1C2A3A)
                              : Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
      // bottomNavigationBar: Stack(
      //   alignment: new FractionalOffset(.5, 1.0),
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      //       child: Row(
      //         children: [
      //           SvgPicture.asset('Assets/icons/camera-2.svg'),
      //           SvgPicture.asset('Assets/icons/gallery.svg'),
      //           SvgPicture.asset('Assets/icons/microphone-2.svg'),
      //           SvgPicture.asset('Assets/icons/microphone-2.svg'),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  // Future<void> getConversationID() async {
  //   try {
  //     final fcmToken = await getToken();
  //     print(fcmToken);
  //     FirebaseApp app = await Firebase.initializeApp();
  //     final response = await http.post(
  //         Uri.parse(
  //             'Endpoints.CHAT_PROD_URL' + 'Endpoints.CHAT_CREATE_CONVERSATION'),
  //         body: jsonEncode({
  //           // "orderId": widget.orderDetail.id,
  //           // "customerId": widget.orderDetail.customer?.id,
  //           // "driverId": widget.orderDetail.driver?.id,
  //           // "customerName": widget.orderDetail.customer?.name,
  //           // "driverName": widget.orderDetail.driver?.name,
  //           // "projectId": app.options.projectId,
  //           // "driverImageURL": _profileController.photoImageURL!.value,
  //           // // "driverFcmToken":"",
  //           // // "customerFcmToken":"",
  //           // "status": widget.orderDetail.status,
  //         }),
  //         headers: {"Content-Type": "application/json"});

  //     if (response.statusCode == 201 || response.statusCode == 200) {
  //       final resp =
  //           CreateConversationResponse.fromJson(jsonDecode(response.body));

  //       _conversationId = resp.conversationData?.sId ?? "";
  //       _senderId = resp.conversationData?.driverId ?? 0;
  //       _receiverId = resp.conversationData?.customerId ?? 0;
  //       _date = resp.conversationData?.createdAt ?? "";

  //       updateUserDeviceToken(_conversationId);
  //     }
  //   } on Exception catch (e) {
  //     print(e.toString());
  //   }
  // }

  // Future<void> updateUserDeviceToken(String conversationId) async {
  //   try {
  //     final fcmToken = await getToken();
  //     print(fcmToken);
  //     FirebaseApp app = await Firebase.initializeApp();
  //     final response = await http.post(
  //         Uri.parse('Endpoints.CHAT_PROD_URL' +
  //             'Endpoints.CHAT_UPDATE_DEVICE_TOKEN' +
  //             '$conversationId'),
  //         body: jsonEncode({
  //           "userType": "driver",
  //           "fcmToken": fcmToken,
  //         }),
  //         headers: {"Content-Type": "application/json"});

  //     if (response.statusCode == 201 || response.statusCode == 200) {
  //       print(
  //           'Chat: Device token has been updated Response ${response.toString()}');
  //     }
  //   } on Exception catch (e) {
  //     print(e.toString());
  //   }
  // }

  Future<void> loadHistory() async {
    try {
      setState(() {
        _isLoading = true;
        _loadError = null;
      });
      print('📥 [Chat] Loading message history for conversation: $conversationId');
      final list = await chatService!.getMessages(conversationId!, limit: 50);
      print('📥 [Chat] Loaded ${list.length} messages from history');
      
      // Clear existing messages before loading history
      messageWidgets.clear();
      
      // Track unread message IDs to mark as read
      final List<String> unreadMessageIds = [];
      
      for (final item in list) {
        // Handle message structure from guide: _id, senderId, senderType, receiverId, receiverType, body, mediaUrl, status, createdAt
        final messageId = item['_id']?.toString() ?? '';
        final senderIdRaw = item['senderId'] ?? item['sender_id'];
        final senderId = senderIdRaw?.toString() ?? '';
        final senderType = (item['senderType'] ?? item['sender_type'])?.toString() ?? '';
        final body = item['body']?.toString() ?? '';
        final status = item['status']?.toString() ?? 'sent';
        
        // Handle "NaN" sender_id case - if sender_id is "NaN" or invalid, check sender_type
        // If sender_type matches current user type, it's likely our message
        bool isCurrentUser = false;
        if (senderId.toLowerCase() == 'nan' || senderId.isEmpty) {
          // If sender_id is NaN, check if sender_type matches and assume it's our message if type matches
          // This is a workaround for backend issue where sender_id is "NaN"
          if (senderType.toLowerCase() == widget.senderType.toLowerCase()) {
            isCurrentUser = true;
            print('⚠️ [Chat] History: sender_id is "NaN", but sender_type matches, assuming current user message');
          }
        } else {
          // Normalize IDs for comparison (handle both string and number formats)
          final normalizedSenderId = _normalizeId(senderId);
          final normalizedUserId = _normalizeId(widget.userId);
          isCurrentUser = normalizedSenderId.isNotEmpty && 
                         normalizedUserId.isNotEmpty && 
                         normalizedSenderId == normalizedUserId;
        }
        
        print('📥 [Chat] History message - id: $messageId, sender: "$senderId" (type: ${senderIdRaw.runtimeType}), sender_type: "$senderType", current user: "${widget.userId}", isCurrentUser: $isCurrentUser, body: $body, status: $status');
        
        if (body.isNotEmpty) {
          // Mark as processed to prevent duplicates
          if (messageId.isNotEmpty) {
            processedMessageIds.add(messageId);
          }
          
          final msgBubble = MessageBubble(
            msgText: body,
            msgSender: isCurrentUser ? 'You' : widget.userName,
            user: isCurrentUser, // true = right side (sent), false = left side (received)
            receiverImage: widget.userAsset,
          );
          messageWidgets.add(msgBubble);
          
          // Track unread messages (not sent by current user and status is not 'read')
          if (!isCurrentUser && messageId.isNotEmpty && status != 'read') {
            unreadMessageIds.add(messageId);
          }
        }
      }
      
      // Mark unread messages as read
      if (unreadMessageIds.isNotEmpty) {
        print('📥 [Chat] Marking ${unreadMessageIds.length} messages as read');
        for (final messageId in unreadMessageIds) {
          try {
            await chatService!.markMessageAsRead(
              messageId: messageId,
              readerId: widget.userId,
              readerType: widget.senderType,
            );
          } catch (e) {
            print('⚠️ [Chat] Failed to mark message $messageId as read: $e');
          }
        }
      }
      
      print('📥 [Chat] Total messages in UI: ${messageWidgets.length}');
      if (mounted) setState(() {});
    } catch (e) {
      print('❌ [Chat] Error loading history: $e');
      _loadError = e.toString();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

class StreamSocket {
  final _socketResponse = StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}

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
  
  // Helper function to check if sender ID matches current user ID
  // When senderId is null/empty/NaN, we use receiverId or optimistic messages to determine ownership
  bool _isSenderCurrentUser(dynamic senderId, String senderType, {String? messageBody, String? receiverId}) {
    final currentUserIdStr = widget.userId.toString().trim();
    
    if (senderId == null) {
      print('⚠️ [Chat] _isSenderCurrentUser: senderId is null');
      
      // Strategy 1: Check receiverId - if receiverId matches our userId, message was sent TO us (from other person)
      if (receiverId != null && receiverId.isNotEmpty) {
        final receiverIdStr = receiverId.toString().trim();
        if (receiverIdStr == currentUserIdStr || receiverIdStr.toLowerCase() == currentUserIdStr.toLowerCase()) {
          print('✅ [Chat] _isSenderCurrentUser: senderId is null but receiverId matches current user, message is FROM other person');
          return false; // Message was sent TO us, so it's FROM the other person
        }
      }
      
      // Strategy 2: Check if we have an optimistic message with same body (we just sent it)
      if (messageBody != null && messageBody.isNotEmpty) {
        final hasOptimisticMessage = messageWidgets.any((msg) => 
          msg.msgText == messageBody && 
          msg.user == true && 
          msg.sending == true
        );
        if (hasOptimisticMessage) {
          print('✅ [Chat] _isSenderCurrentUser: senderId is null but found optimistic message, assuming current user');
          return true;
        }
      }
      
      // Strategy 3: If receiverId doesn't match us and no optimistic message, assume it's NOT from current user
      print('⚠️ [Chat] _isSenderCurrentUser: senderId is null, receiverId check failed, no optimistic message - assuming NOT current user');
      return false;
    }
    
    final senderIdStr = senderId.toString().trim();
    
    // Handle "NaN" or empty sender_id
    if (senderIdStr.toLowerCase() == 'nan' || senderIdStr.isEmpty || senderIdStr == 'null') {
      // Strategy 1: Check receiverId - if receiverId matches our userId, message was sent TO us (from other person)
      if (receiverId != null && receiverId.isNotEmpty) {
        final receiverIdStr = receiverId.toString().trim();
        if (receiverIdStr == currentUserIdStr || receiverIdStr.toLowerCase() == currentUserIdStr.toLowerCase()) {
          print('✅ [Chat] _isSenderCurrentUser: sender_id is NaN/null but receiverId matches current user, message is FROM other person');
          return false; // Message was sent TO us, so it's FROM the other person
        }
      }
      
      // Strategy 2: Check if we have an optimistic message with same body
      if (messageBody != null && messageBody.isNotEmpty) {
        final hasOptimisticMessage = messageWidgets.any((msg) => 
          msg.msgText == messageBody && 
          msg.user == true && 
          msg.sending == true
        );
        if (hasOptimisticMessage) {
          print('✅ [Chat] _isSenderCurrentUser: sender_id is NaN/null but found optimistic message, assuming current user');
          return true;
        }
      }
      
      // DO NOT rely on senderType alone when senderId is missing - this causes false positives
      print('⚠️ [Chat] _isSenderCurrentUser: sender_id is NaN/null, receiverId check failed, no optimistic message - assuming NOT current user');
      return false;
    }
    
    // Direct string comparison first (most common case)
    if (senderIdStr == currentUserIdStr) {
      print('✅ [Chat] _isSenderCurrentUser: Direct match - "$senderIdStr" == "$currentUserIdStr"');
      return true;
    }
    
    // Case-insensitive comparison
    if (senderIdStr.toLowerCase() == currentUserIdStr.toLowerCase()) {
      print('✅ [Chat] _isSenderCurrentUser: Case-insensitive match - "$senderIdStr" == "$currentUserIdStr"');
      return true;
    }
    
    // Also check if they're numeric and equal
    try {
      final senderNum = int.parse(senderIdStr);
      final currentNum = int.parse(currentUserIdStr);
      if (senderNum == currentNum) {
        print('✅ [Chat] _isSenderCurrentUser: Numeric match - $senderNum == $currentNum');
        return true;
      }
    } catch (e) {
      // Not numeric, continue
    }
    
    print('❌ [Chat] _isSenderCurrentUser: No match - sender: "$senderIdStr", current: "$currentUserIdStr"');
    return false;
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

      // Log socket connection status before listening
      print('🔍 [Socket] Checking connection status before listening...');
      print('🔍 [Socket] Socket connected: ${chatService!.socket?.connected ?? false}');
      print('🔍 [Socket] Socket ID: ${chatService!.socket?.id ?? "null"}');
      
      // Listen for new messages
      chatService!.onMessage((data) async {
        print('📨 [Socket] ========== RECEIVED MESSAGE EVENT ==========');
        print('📨 [Socket] Raw data: ${data.toString()}');
        print('📨 [Socket] Data type: ${data.runtimeType}');
        // Handle message structure from guide: _id, conversationId, senderId, senderType, receiverId, receiverType, body, mediaUrl, status, createdAt
        final messageId = data['_id']?.toString() ?? '';
        final senderIdRaw = data['senderId'] ?? data['sender_id'];
        final senderId = senderIdRaw?.toString() ?? '';
        final senderType = (data['senderType'] ?? data['sender_type'])?.toString() ?? '';
        final receiverIdRaw = data['receiverId'] ?? data['receiver_id'];
        final receiverId = receiverIdRaw?.toString() ?? '';
        final conversationIdFromMsg = (data['conversationId'] ?? data['conversation_id'])?.toString() ?? '';
        final body = data['body']?.toString() ?? '';
        
        // Only process messages for this conversation
        if (conversationIdFromMsg.isNotEmpty && conversationIdFromMsg != conversationId) {
          print('⚠️ [Socket] Ignoring message from different conversation: $conversationIdFromMsg (current: $conversationId)');
          return;
        }
        
        // Check if message is from current user - pass messageBody and receiverId to help with null senderId cases
        final isCurrentUser = _isSenderCurrentUser(senderId, senderType, messageBody: body, receiverId: receiverId);
        
        print('📨 [Chat] Real-time message - id: $messageId, sender: "$senderId", current user: "${widget.userId}", isCurrentUser: $isCurrentUser, body: $body');
        print('📨 [Chat] Processed message IDs count: ${processedMessageIds.length}');
        if (messageId.isNotEmpty) {
          print('📨 [Chat] Checking if message ID "$messageId" is in processed list: ${processedMessageIds.contains(messageId)}');
        }
        
        // Check if message already exists (avoid duplicates)
        // CRITICAL: Only check by messageId, NOT by text (text can be repeated)
        bool messageExists = false;
        if (messageId.isNotEmpty) {
          // Check by messageId first (most reliable)
          messageExists = processedMessageIds.contains(messageId);
          if (messageExists) {
            print('⚠️ [Chat] Message ID already processed: $messageId, skipping (this message was already loaded from API)');
          } else {
            print('✅ [Chat] Message ID is new: $messageId, will add to UI');
          }
        } else {
          print('⚠️ [Chat] Message has no ID, cannot check for duplicates reliably - will add anyway');
        }
        
        // Handle optimistic messages (only for messages from current user)
        if (!messageExists && isCurrentUser && body.isNotEmpty) {
          // Find optimistic message with same text from current user
          final optimisticIndex = messageWidgets.indexWhere((msg) => 
            msg.msgText == body && 
            msg.user == true && // Sent message (right side)
            msg.sending == true // Still sending (optimistic)
          );
          
          if (optimisticIndex != -1) {
            // Replace optimistic message with real one
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
        final receiverIdRaw = item['receiverId'] ?? item['receiver_id'];
        final receiverId = receiverIdRaw?.toString() ?? '';
        final body = item['body']?.toString() ?? '';
        final status = item['status']?.toString() ?? 'sent';
        
        // Check if message is from current user - pass messageBody and receiverId to help with null senderId cases
        final isCurrentUser = _isSenderCurrentUser(senderId, senderType, messageBody: body, receiverId: receiverId);
        
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

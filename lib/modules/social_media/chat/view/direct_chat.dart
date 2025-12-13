import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/Widgets/appbar/chat_appbar.dart';
import 'package:joy_app/core/constants/endpoints.dart';
import 'package:joy_app/theme.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:dio/dio.dart';
import 'package:joy_app/modules/social_media/chat/bloc/chat_service.dart';
import '../widgets/message_widget.dart';

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
  bool _isLoading = false;
  String? _loadError;
  // ChatController not needed in new flow

  @override
  void initState() {
    connectAndListen();
    print("************** ${DateTime.now().toString()} *****************");
    super.initState();
  }

  void connectAndListen() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });

    // Build service
    chatService = ChatService(Dio(BaseOptions(
      baseUrl: Endpoints.chatRestBase,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    )));

    try {
      // Ensure conversation
      final ensuredConversationId = await chatService!.ensureConversation(
        userId: int.parse(widget.userId),
        userType: widget.senderType,
        peerId: int.parse(widget.friendId),
        peerType: widget.receiverType,
      );
      conversationId = ensuredConversationId;
      print('[Chat] Conversation ID: $conversationId');

      // Connect socket + auth
      chatService!.connectSocket(
        userId: int.parse(widget.userId),
        userType: widget.senderType,
      );

      // Join conversation room
      chatService!.joinConversation(conversationId!);

      // Load history
      await loadHistory();

      // Listen for new messages
      chatService!.onMessage((data) {
        print('[Socket] on message: ' + data.toString());
        // Try both snake_case and camelCase for compatibility
        final senderId = (data['senderId'] ?? data['sender_id'])?.toString() ?? '';
        final isCurrentUser = senderId.toString() == widget.userId.toString();
        print('[Chat] Real-time message from sender: $senderId, current user: ${widget.userId}, isCurrentUser: $isCurrentUser');
        final msgBubble = MessageBubble(
          msgText: data['body']?.toString() ?? '',
          msgSender: isCurrentUser ? 'You' : widget.userName,
          user: isCurrentUser,
          receiverImage: widget.userAsset,
        );
        if (mounted) {
          setState(() {
            messageWidgets.add(msgBubble);
          });
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
                            setState(() {
                              chatService?.sendMessage(
                                conversationId: conversationId!,
                                senderId: int.parse(widget.userId),
                                senderType: widget.senderType,
                                receiverId: int.parse(widget.friendId),
                                receiverType: widget.receiverType,
                                body: chatMsgTextController.text,
                              );
                              final msgBubble = MessageBubble(
                                msgText: chatMsgTextController.text,
                                msgSender: "You",
                                user: true,
                                sending: true,
                                receiverImage: widget.userAsset,
                              );
                              chatMsgTextController.clear();
                              messageWidgets.add(msgBubble);
                            });
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
                      setState(() {
                        chatService?.sendMessage(
                          conversationId: conversationId!,
                          senderId: int.parse(widget.userId),
                          senderType: widget.senderType,
                          receiverId: int.parse(widget.friendId),
                          receiverType: widget.receiverType,
                          body: chatMsgTextController.text,
                        );
                        final msgBubble = MessageBubble(
                          msgText: chatMsgTextController.text,
                          msgSender: "You",
                          user: true,
                          sending: true,
                          receiverImage: widget.userAsset,
                        );
                        chatMsgTextController.clear();
                        messageWidgets.add(msgBubble);
                      });
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
      final list = await chatService!.getMessages(conversationId!, limit: 50);
      for (final item in list) {
        // Try both snake_case and camelCase for compatibility
        final senderId = (item['senderId'] ?? item['sender_id'])?.toString() ?? '';
        final body = item['body']?.toString() ?? '';
        final isCurrentUser = senderId.toString() == widget.userId.toString();
        print('[Chat] Message from sender: $senderId, current user: ${widget.userId}, isCurrentUser: $isCurrentUser');
        final msgBubble = MessageBubble(
          msgText: body,
          msgSender: isCurrentUser ? 'You' : widget.userName,
          user: isCurrentUser,
          receiverImage: widget.userAsset,
        );
        messageWidgets.add(msgBubble);
      }
      if (mounted) setState(() {});
    } catch (e) {
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

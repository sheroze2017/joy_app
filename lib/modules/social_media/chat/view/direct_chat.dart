import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/Widgets/appbar/chat_appbar.dart';
import 'package:joy_app/core/constants/endpoints.dart';
import 'package:joy_app/theme.dart';
import 'package:sizer/sizer.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import '../model/message_response.dart';
import '../widgets/message_widget.dart';

String _conversationId = "";
int _senderId = 0;
int _receiverId = 0;
String _date = "";

class DirectMessageScreen extends StatefulWidget {
  String userName;
  String userAsset;
  String userId;
  String friendId;
  String conversationId;
  DirectMessageScreen(
      {super.key,
      required this.userName,
      required this.userAsset,
      required this.userId,
      required this.friendId,
      required this.conversationId});

  @override
  State<DirectMessageScreen> createState() => _DirectMessageScreenState();
}

class _DirectMessageScreenState extends State<DirectMessageScreen> {
  final chatMsgTextController = TextEditingController();
  late IO.Socket socket;
  StreamSocket streamSocket = StreamSocket();
  List<MessageBubble> messageWidgets = [];
  bool _isLoading = false;

  @override
  void initState() {
    connectAndListen();
    print("************** ${DateTime.now().toString()} *****************");
    super.initState();
  }

  void connectAndListen() async {
    socket = IO.io(Endpoints.CHAT_PROD_URL, <String, dynamic>{
      'transports': ['websocket'],
      'force new connection': true,
    });
    print("Socket Connected: ${socket.connected}");

    socket.onConnect((_) async {
      print('connecting');
    });
    print("Socket Connected: ${socket.connected}");

    //   await getConversationID();
    await getConversations();
    print(widget.conversationId);
    socket.emit('addUser', {
      'conversationId': widget.conversationId,
      'userId': widget.userId,
    });
    socket.on('receiveMessageEvent', (data) {
      print("@@@@@@@@@@@@@@@@ $data @@@@@@@@@@@@@@");

      final msgBubble = MessageBubble(
        msgText: data,
        msgSender: widget.userName,
        user: false,
      );
      if (mounted) {
        setState(() {
          messageWidgets.add(msgBubble);
        });
      }
      streamSocket.addResponse;
    });
    socket.onDisconnect((_) => print('Socket.IO disconnect'));
    socket.on('fromServer', (e) => print(e));
    socket.on('error', (error) => print('Socket.IO Error: $error'));
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(
        username: widget.userName,
        status: 'Offline',
        userId: widget.friendId,
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: streamSocket.getResponse,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final msgBubble = MessageBubble(
                  msgText: snapshot.data ?? "N/A",
                  msgSender: widget.userName ?? "",
                  user: false,
                );
                messageWidgets.add(msgBubble);
              }
              return _isLoading
                  ? Expanded(
                      child: Center(
                          child: CircularProgressIndicator(
                      color: ThemeUtil.isDarkMode(context)
                          ? Color(0xffC5D3E3)
                          : Color(0xff1C2A3A),
                    )))
                  : Expanded(
                      child: ListView.builder(
                        reverse: true,
                        itemCount: messageWidgets.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 12),
                            child: messageWidgets.reversed.toList()[index],
                          );
                        },
                      ),
                    );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  // SvgPicture.asset('Assets/icons/camera-2.svg'),
                  // SizedBox(
                  //   width: 2.w,
                  // ),
                  // SvgPicture.asset('Assets/icons/gallery.svg'),
                  // SizedBox(
                  //   width: 2.w,
                  // ),
                  // SvgPicture.asset('Assets/icons/microphone-2.svg'),
                  // SizedBox(
                  //   width: 2.w,
                  // ),

                  Expanded(
                      child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
                    decoration: BoxDecoration(
                      color: ThemeUtil.isDarkMode(context)
                          ? Color(0xff121212)
                          : Color(0x05000000),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onSubmitted: (value) {
                              setState(() {
                                socket.emit('sendMessageEvent', {
                                  "conversationId": widget.conversationId,
                                  "senderId": widget.userId,
                                  "receiverId": widget.friendId,
                                  "text": chatMsgTextController.text,
                                  "type": 'txt',
                                  "url": '',
                                  "txt": chatMsgTextController.text,
                                });
                                final msgBubble = MessageBubble(
                                  msgText: chatMsgTextController.text,
                                  msgSender: "You",
                                  user: true,
                                  sending: true,
                                );
                                chatMsgTextController.clear();
                                messageWidgets.add(msgBubble);
                              });
                            },
                            controller: chatMsgTextController,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                border: InputBorder.none,
                                hintText: 'Aa',
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                fillColor: Colors.transparent),
                          ),
                        ),
                        Icon(
                          Icons.emoji_emotions,
                          color: Color(0xffA5ABB3),
                        )
                      ],
                    ),
                  )),
                  SizedBox(width: 3.w),
                  InkWell(
                      onTap: () {
                        setState(() {
                          socket.emit('sendMessageEvent', {
                            "conversationId": widget.conversationId,
                            "senderId": widget.userId,
                            "receiverId": widget.friendId,
                            "message": chatMsgTextController.text,
                            "text": chatMsgTextController.text,
                            "txt": chatMsgTextController.text,
                            "type": 'txt',
                            "url": ''
                          });
                          final msgBubble = MessageBubble(
                            msgText: chatMsgTextController.text,
                            msgSender: "You",
                            user: true,
                            sending: true,
                          );
                          chatMsgTextController.clear();
                          messageWidgets.add(msgBubble);
                        });
                      },
                      child: SvgPicture.asset('Assets/icons/send-2.svg')),
                ],
              ),
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

  Future<void> getConversations() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final url = Endpoints.chatBaseUrl +
          Endpoints.getConversation +
          widget.conversationId;
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      print('url ${url}');
      if (response.statusCode == 200) {
        final resp = (jsonDecode(response.body) as List)
            .map((e) => MessageResponse.fromJson(e));
        print(resp);
        for (final message in resp) {
          final msgBubble = MessageBubble(
              msgText: message.text ?? "",
              msgSender:
                  message.senderId == widget.userId ? "You" : widget.userName,
              user: widget.userId == message.senderId.toString(),
              date: message.createdAt!);
          setState(() {
            messageWidgets.add(msgBubble);
          });
        }
      }
    } on Exception catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
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

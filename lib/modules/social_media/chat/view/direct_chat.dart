import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/Widgets/chat_appbar.dart';
import 'package:joy_app/core/network/utils/extra.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:sizer/sizer.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import '../../../../common/profile/bloc/profile_bloc.dart';
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
  DirectMessageScreen(
      {super.key,
      required this.userName,
      required this.userAsset,
      required this.userId,
      required this.friendId});

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
    socket = IO.io('Endpoints.CHAT_PROD_URL', <String, dynamic>{
      'transports': ['websocket'],
      'force new connection': true,
    });
    print("Socket Connected: ${socket.connected}");

    socket.onConnect((_) async {
      print('connecting');
    });

    //   await getConversationID();
    // await getConversations();
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
      appBar: ChatAppBar(username: widget.userName, status: 'Offline'),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Stack(
            children: [
              ListView.builder(
                itemCount: 2, // Example message count
                itemBuilder: (context, index) {
                  // Replace this with your chat message widget
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: MessageBubble(
                            msgText: 'It’s morning in Tokyo 😎',
                            msgSender: 'Sheroze',
                            user: false),
                      ),
                      MessageBubble(
                          msgText: 'It’s morning in Tokyo 😎',
                          msgSender: 'Asad',
                          user: true),
                    ],
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  child: Row(
                    children: [
                      SvgPicture.asset('Assets/icons/camera-2.svg'),
                      SizedBox(
                        width: 2.w,
                      ),
                      SvgPicture.asset('Assets/icons/gallery.svg'),
                      SizedBox(
                        width: 2.w,
                      ),
                      SvgPicture.asset('Assets/icons/microphone-2.svg'),
                      SizedBox(
                        width: 2.w,
                      ),
                      Expanded(
                          child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
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
                      SvgPicture.asset('Assets/icons/send-2.svg'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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

  //       socket.emit('addUser', {
  //         'conversationId': resp.conversationData?.sId,
  //         'userId': resp.conversationData?.driverId,
  //       });

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

  // Future<void> getConversations() async {
  //   try {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     final url = 'Endpoints.CHAT_PROD_URL' +
  //         'Endpoints.CHAT_GET_CONVERSATION' +
  //         '$_conversationId';
  //     final response = await http.get(
  //       Uri.parse(url),
  //       headers: {"Content-Type": "application/json"},
  //     );
  //     print('url ${url}');
  //     if (response.statusCode == 200) {
  //       // final resp = MessageResponse.fromJson(jsonDecode(response.body));
  //       final resp = (jsonDecode(response.body) as List)
  //           .map((e) => MessageResponse.fromJson(e));
  //       print(resp);
  //       for (final message in resp) {
  //         final msgBubble = MessageBubble(
  //             msgText: message.text ?? "",
  //             msgSender:
  //                 message.senderId == widget.userId ? "You" : widget.userName,
  //             user: message.senderId == widget.userId,
  //             date: message.createdAt!);
  //         setState(() {
  //           messageWidgets.add(msgBubble);
  //         });
  //       }
  //     }
  //   } on Exception catch (e) {
  //     print(e.toString());
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }
}

class StreamSocket {
  final _socketResponse = StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}

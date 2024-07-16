// import 'dart:async';
// import 'dart:convert';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:shipox_driver/app/constants/colors.dart';
// import 'package:shipox_driver/app/constants/drawables.dart';
// import 'package:shipox_driver/app/constants/endpoints.dart';
// import 'package:shipox_driver/app/data/dtos/order_dto.dart';
// import 'package:shipox_driver/app/modules/notification_manager.dart';
// import 'package:shipox_driver/app/modules/orders/order_detail/components/create_conversation_response.dart';
// import 'package:shipox_driver/app/modules/orders/order_detail/components/message_response.dart';
// import 'package:shipox_driver/app/modules/profile/blocs/profile_bloc.dart';
// import 'package:shipox_driver/app/utils/utility.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';

// String _conversationId = "";
// int _senderId = 0;
// int _receiverId = 0;
// String _date = "";

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key, required this.orderDetail});
//   final OrderDto orderDetail;

//   @override
//   // ignore: library_private_types_in_public_api
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
  // final chatMsgTextController = TextEditingController();
  // late IO.Socket socket;
  // StreamSocket streamSocket = StreamSocket();
  // List<MessageBubble> messageWidgets = [];
  // bool _isLoading = false;
  // final ProfileController _profileController = Get.find();

  // @override
  // void initState() {
  //   connectAndListen();
  //   print("************** ${DateTime.now().toString()} *****************");
  //   super.initState();
  // }

  // void connectAndListen() async {
  //   socket = IO.io(Endpoints.CHAT_PROD_URL, <String, dynamic>{
  //     'transports': ['websocket'],
  //     'force new connection': true,
  //   });
  //   print("Socket Connected: ${socket.connected}");

  //   socket.onConnect((_) async {
  //     print('connecting');
  //   });

  //   await getConversationID();
  //   await getConversations();
  //   socket.on('receiveMessageEvent', (data) {
  //     print("@@@@@@@@@@@@@@@@ $data @@@@@@@@@@@@@@");
  //     final msgBubble = MessageBubble(
  //       msgText: data,
  //       msgSender: widget.orderDetail.customer?.name ?? "",
  //       user: false,
  //     );
  //     if (mounted) {
  //       setState(() {
  //         messageWidgets.add(msgBubble);
  //       });
  //     }
  //     streamSocket.addResponse;
  //   });
  //   socket.onDisconnect((_) => print('Socket.IO disconnect'));
  //   socket.on('fromServer', () => print());
  //   socket.on('error', (error) => print('Socket.IO Error: $error'));
  // }

  // @override
  // void dispose() {
  //   socket.dispose();
  //   super.dispose();
  // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         iconTheme: IconThemeData(
//           color: Colors.black, //change your color here
//         ),
//         backgroundColor: Colors.white,
//         title: Text(
//           widget.orderDetail.customer?.name ?? "",
//           style: TextStyle(color: Colors.black),
//         ),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: <Widget>[
//           StreamBuilder(
//             stream: streamSocket.getResponse,
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 final msgBubble = MessageBubble(
//                   msgText: snapshot.data ?? "N/A",
//                   msgSender: widget.orderDetail.customer?.name ?? "",
//                   user: false,
//                 );
//                 messageWidgets.add(msgBubble);
//               }
//               return _isLoading
//                   ? Center(child: CircularProgressIndicator())
//                   : Expanded(
//                       child: ListView.builder(
//                         reverse: true,
//                         itemCount: messageWidgets.length,
//                         itemBuilder: (context, index) {
//                           return messageWidgets.reversed.toList()[index];
//                         },
//                       ),
//                     );
//             },
//           ),
//           Container(
//             padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 Expanded(
//                   child: Material(
//                     borderRadius: BorderRadius.circular(30),
//                     color: Colors.white,
//                     elevation: 5,
//                     child: TextField(
//                       controller: chatMsgTextController,
//                       decoration: InputDecoration(
//                         contentPadding: EdgeInsets.all(16),
//                         hintText: 'Type your message here...',
//                         hintStyle: TextStyle(
//                           color: Color(0xFF6B6F80),
//                           fontSize: 14,
//                         ),
//                         border: InputBorder.none,
//                         suffixIcon: IconButton(
//                           onPressed: () {
//                             dynamic obj = {
//                               "conversationId": _conversationId,
//                               "senderId": _senderId,
//                               "receiverId": _receiverId,
//                               "message": chatMsgTextController.text,
//                               "type": 'txt',
//                               "url": ''
//                             };
//                             print('Message : ${obj.toString()}');
//                             setState(() {
//                               socket.emit('sendMessageEvent', {
//                                 "conversationId": _conversationId,
//                                 "senderId": _senderId,
//                                 "receiverId": _receiverId,
//                                 "message": chatMsgTextController.text,
//                                 "type": 'txt',
//                                 "url": ''
//                               });
//                               final msgBubble = MessageBubble(
//                                 msgText: chatMsgTextController.text,
//                                 msgSender: "You",
//                                 user: true,
//                                 sending: true,
//                               );
//                               chatMsgTextController.clear();
//                               messageWidgets.add(msgBubble);
//                             });
//                           },
//                           icon: SvgPicture.asset(Drawables.send),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

  // Future<void> getConversationID() async {
  //   try {
  //     final fcmToken = await PushNotificationsManager().getFcmToken();
  //     print(fcmToken);
  //     FirebaseApp app = await Firebase.initializeApp();
  //     final response = await http.post(
  //         Uri.parse(
  //             Endpoints.CHAT_PROD_URL + Endpoints.CHAT_CREATE_CONVERSATION),
  //         body: jsonEncode({
  //           "orderId": widget.orderDetail.id,
  //           "customerId": widget.orderDetail.customer?.id,
  //           "driverId": widget.orderDetail.driver?.id,
  //           "customerName": widget.orderDetail.customer?.name,
  //           "driverName": widget.orderDetail.driver?.name,
  //           "projectId": app.options.projectId,
  //           "driverImageURL": _profileController.photoImageURL!.value,
  //           // "driverFcmToken":"",
  //           // "customerFcmToken":"",
  //           "status": widget.orderDetail.status,
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
  //     final fcmToken = await PushNotificationsManager().getFcmToken();
  //     print(fcmToken);
  //     FirebaseApp app = await Firebase.initializeApp();
  //     final response = await http.post(
  //         Uri.parse(Endpoints.CHAT_PROD_URL +
  //             Endpoints.CHAT_UPDATE_DEVICE_TOKEN +
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

//   Future<void> getConversations() async {
//     try {
//       setState(() {
//         _isLoading = true;
//       });
//       final url = Endpoints.CHAT_PROD_URL +
//           Endpoints.CHAT_GET_CONVERSATION +
//           '$_conversationId';
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {"Content-Type": "application/json"},
//       );
//       print('url ${url}');
//       if (response.statusCode == 200) {
//         // final resp = MessageResponse.fromJson(jsonDecode(response.body));
//         final resp = (jsonDecode(response.body) as List)
//             .map((e) => MessageResponse.fromJson(e));
//         print(resp);
//         for (final message in resp) {
//           final msgBubble = MessageBubble(
//               msgText: message.text ?? "",
//               msgSender: message.senderId == widget.orderDetail.driver?.id
//                   ? "You"
//                   : widget.orderDetail.customer?.name ?? "",
//               user: message.senderId == widget.orderDetail.driver?.id,
//               date: message.createdAt!);
//           setState(() {
//             messageWidgets.add(msgBubble);
//           });
//         }
//       }
//     } on Exception catch (e) {
//       print(e.toString());
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
// }

// class MessageBubble extends StatelessWidget {
//   final String msgText;
//   final String msgSender;
//   final bool user;
//   final bool sending;
//   final String date;
//   MessageBubble(
//       {required this.msgText,
//       required this.msgSender,
//       required this.user,
//       this.sending = false,
//       this.date = ""});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: Column(
//         crossAxisAlignment:
//             user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: <Widget>[
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 10),
//             child: Text(
//               msgSender,
//               style: TextStyle(
//                   fontSize: 13, fontFamily: 'Poppins', color: Colors.black87),
//             ),
//           ),
//           Material(
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(10),
//               topLeft: user ? Radius.circular(10) : Radius.circular(0),
//               bottomRight: Radius.circular(10),
//               topRight: user ? Radius.circular(0) : Radius.circular(10),
//             ),
//             color: user ? Color(0xFF023076) : Color(0xFFF1F7FF),
//             elevation: 5,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//               child: RichText(
//                 text: TextSpan(
//                   children: [
//                     TextSpan(
//                       text: "$msgText \n",
//                       style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                             color: user ? Colors.white : Color(0xFF0D082C),
//                             fontSize: 16,
//                           ),
//                     ),
//                     WidgetSpan(
//                       child: SizedBox(width: 20),
//                     ),
//                     TextSpan(
//                       text: sending
//                           ? DateFormat("yyyy-MMM-dd HH:mm:ss")
//                               .format(DateTime.now())
//                           : Utility.convertToUserTimeZone(date),
//                       style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                           color: user
//                               ? AppColors.background
//                               : AppColors.black.withOpacity(0.5)),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class StreamSocket {
//   final _socketResponse = StreamController<String>();

//   void Function(String) get addResponse => _socketResponse.sink.add;

//   Stream<String> get getResponse => _socketResponse.stream;

//   void dispose() {
//     _socketResponse.close();
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
import 'package:joy_app/modules/social_media/chat/bloc/chat_bloc.dart';
import 'package:joy_app/modules/social_media/chat/view/direct_chat.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/widgets/appbar/custom_appbar.dart';
import 'package:sizer/sizer.dart';
import '../../friend_request/bloc/friends_bloc.dart';
import '../../friend_request/view/new_friend.dart';

class AllChats extends StatefulWidget {
  AllChats({super.key});

  @override
  State<AllChats> createState() => _AllChatsState();
}

class _AllChatsState extends State<AllChats> {
  FriendsSocialController _friendsController =
      Get.find<FriendsSocialController>();

  ChatController _chatController = Get.put(ChatController());
  ProfileController _profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    // Load conversations when screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _chatController.getMyConversations();
    });
  }

  String _getPeerType(dynamic conversation) {
    // Get peer type from conversation - check 'peer' object first (API format)
    if (conversation is Map) {
      // New API format: {peer: {id, name, image, type, user_role}}
      final peer = conversation['peer'];
      if (peer is Map) {
        final type = (peer['type'] ?? peer['user_role']?.toString().toLowerCase())?.toString().toLowerCase() ?? 'user';
        return type;
      }
      
      // Fallback: participants array (old format)
      final participants = conversation['participants'] ?? [];
      if (participants is List && participants.isNotEmpty) {
        for (var p in participants) {
          if (p is Map) {
            final userId = _profileController.userId.value;
            final pId = (p['id'] ?? p['user_id'] ?? p['userId'])?.toString() ?? '';
            if (pId != userId && pId.isNotEmpty) {
              final type = (p['type'] ?? p['user_type'] ?? p['userType'])?.toString().toLowerCase() ?? 'user';
              return type;
            }
          }
        }
      }
    }
    return 'user';
  }

  String _getPeerId(dynamic conversation) {
    // Get peer ID from conversation - check 'peer' object first (API format)
    if (conversation is Map) {
      // New API format: {peer: {id, name, image, type, user_role}}
      final peer = conversation['peer'];
      if (peer is Map) {
        final peerId = (peer['id'] ?? peer['user_id'] ?? peer['userId'])?.toString() ?? '';
        if (peerId.isNotEmpty) {
          return peerId;
        }
      }
      
      // Fallback: participants array (old format)
      final participants = conversation['participants'] ?? [];
      if (participants is List && participants.isNotEmpty) {
        for (var p in participants) {
          if (p is Map) {
            final userId = _profileController.userId.value;
            final pId = (p['id'] ?? p['user_id'] ?? p['userId'])?.toString() ?? '';
            if (pId != userId && pId.isNotEmpty) {
              return pId;
            }
          }
        }
      }
    }
    return '';
  }

  String _getPeerName(dynamic conversation) {
    // Get peer name from conversation - check 'peer' object first (API format)
    if (conversation is Map) {
      // New API format: {peer: {id, name, image, type, user_role}}
      final peer = conversation['peer'];
      if (peer is Map) {
        final name = peer['name']?.toString() ?? '';
        if (name.isNotEmpty && name.toLowerCase() != 'unknown') {
          return name;
        }
      }
      
      // Fallback: participants array (old format)
      final participants = conversation['participants'] ?? [];
      if (participants is List && participants.isNotEmpty) {
        for (var p in participants) {
          if (p is Map) {
            final userId = _profileController.userId.value;
            final pId = (p['id'] ?? p['user_id'] ?? p['userId'])?.toString() ?? '';
            if (pId != userId && pId.isNotEmpty) {
              final name = p['name']?.toString() ?? 
                          p['user_name']?.toString() ?? 
                          p['username']?.toString() ??
                          p['full_name']?.toString() ??
                          p['fullName']?.toString();
              if (name != null && name.isNotEmpty && name.toLowerCase() != 'unknown') {
                return name;
              }
            }
          }
        }
      }
    }
    return 'Unknown';
  }

  String _getPeerImage(dynamic conversation) {
    // Get peer image from conversation - check 'peer' object first (API format)
    if (conversation is Map) {
      // New API format: {peer: {id, name, image, type, user_role}}
      final peer = conversation['peer'];
      if (peer is Map) {
        final image = peer['image']?.toString() ?? 
                     peer['image_url']?.toString() ?? 
                     peer['profile_image']?.toString() ??
                     '';
        // Return empty string if image is invalid (will be handled by ChatBox)
        if (image.isNotEmpty && image.contains('http')) {
          return image;
        }
        return '';
      }
      
      // Fallback: participants array (old format)
      final participants = conversation['participants'] ?? [];
      if (participants is List && participants.isNotEmpty) {
        for (var p in participants) {
          if (p is Map) {
            final userId = _profileController.userId.value;
            final pId = (p['id'] ?? p['user_id'] ?? p['userId'])?.toString() ?? '';
            if (pId != userId && pId.isNotEmpty) {
              final image = p['image']?.toString() ?? 
                           p['image_url']?.toString() ?? 
                           p['profile_image']?.toString() ??
                           '';
              if (image.isNotEmpty && image.contains('http')) {
                return image;
              }
              return '';
            }
          }
        }
      }
    }
    return '';
  }

  String _getLastMessage(dynamic conversation) {
    // Get last message from conversation (guide format: lastMessage object with body field)
    if (conversation is Map) {
      final lastMessage = conversation['lastMessage'] ?? conversation['last_message'];
      if (lastMessage is Map) {
        // Guide format: {body: "Hello!", ...}
        return lastMessage['body']?.toString() ?? 
               lastMessage['text']?.toString() ?? 
               '';
      }
      // Fallback to direct field
      return conversation['last_message_text']?.toString() ?? 
             conversation['lastMessageText']?.toString() ?? 
             '';
    }
    return '';
  }

  String _getLastMessageTime(dynamic conversation) {
    // Get last message time from conversation
    if (conversation is Map) {
      final lastMessage = conversation['lastMessage'] ?? conversation['last_message'];
      if (lastMessage is Map) {
        final createdAt = lastMessage['createdAt'] ?? lastMessage['created_at'];
        if (createdAt != null) {
          try {
            final date = DateTime.parse(createdAt.toString());
            final now = DateTime.now();
            final diff = now.difference(date);
            if (diff.inDays > 0) {
              return '${diff.inDays}d ago';
            } else if (diff.inHours > 0) {
              return '${diff.inHours}h ago';
            } else if (diff.inMinutes > 0) {
              return '${diff.inMinutes}m ago';
            } else {
              return 'Just now';
            }
          } catch (e) {
            return '';
          }
        }
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        title: 'Chats',
        leading: Text(''),
        showIcon: false,
        actions: [],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Stack(
          children: [
            RoundedSearchTextFieldLarge(
                hintText: 'Search',
                controller: TextEditingController(),
                onChanged: _friendsController.searchChat),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  // StoryWidget(
                  //   stories: [
                  //     'https://via.placeholder.com/150',
                  //     'https://via.placeholder.com/151',
                  //     'https://via.placeholder.com/152',
                  //     'https://via.placeholder.com/153',
                  //     'https://via.placeholder.com/154',
                  //     'https://via.placeholder.com/155',
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 1.h,
                  // ),
                  RefreshIndicator(
                    onRefresh: () async {
                      await _chatController.getMyConversations();
                    },
                    child: Obx(() {
                      if (_chatController.isLoadingConversations.value) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      
                      if (_chatController.myConversations.length == 0) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              'No conversations yet',
                              style: CustomTextStyles.lightTextStyle(),
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: _chatController.myConversations.length,
                        itemBuilder: (context, index) {
                          final conversation = _chatController.myConversations.elementAt(index);
                          final peerId = _getPeerId(conversation);
                          final peerName = _getPeerName(conversation);
                          final peerImage = _getPeerImage(conversation);
                          final peerType = _getPeerType(conversation);
                          final lastMessage = _getLastMessage(conversation);
                          final lastMessageTime = _getLastMessageTime(conversation);

                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (peerId.isNotEmpty) {
                                    Get.to(DirectMessageScreen(
                                      userName: peerName,
                                      friendId: peerId,
                                      userId: _profileController.userId.value,
                                      userAsset: peerImage,
                                      senderType: 'user',
                                      receiverType: peerType,
                                    ));
                                  }
                                },
                                child: ChatBox(
                                  profileImageUrl: peerImage,
                                  personName: peerName,
                                  lastMessage: lastMessage.isNotEmpty ? lastMessage : 'No messages yet',
                                  dateTime: lastMessageTime.isNotEmpty ? lastMessageTime : '',
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                            ],
                          );
                        },
                      );
                    }),
                  )
                ],
              ),
            ),
            Obx(() => _friendsController.showlist.value
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      constraints: BoxConstraints(maxHeight: 50.h),
                      child: Obx(
                        () => ListView.builder(
                          //shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount:
                              _friendsController.filteredList.length,
                          itemBuilder: ((context, index) {
                            final data =
                                _friendsController.filteredList[index];

                            return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: InkWell(
                                    onTap: () {
                                      _friendsController.showlist.value = false;
                                      Get.to(DirectMessageScreen(
                                        userName: data.name.toString(),
                                        friendId: data.userId.toString(),
                                        userId: _profileController.userId.value,
                                        userAsset: (data.image != null && 
                                                    data.image!.contains('http') &&
                                                    !data.image!.contains('c894ac58-b8cd-47c0-94d1-3c4cea7dadab'))
                                            ? data.image.toString()
                                            : '',
                                      ));
                                      // _chatController.createConvo(
                                      //     data.userId ?? 0,
                                      //     data.name.toString());
                                    },
                                    child: Row(
                                      children: [
                                        (data.image != null && 
                                         data.image!.contains('http') &&
                                         !data.image!.contains('c894ac58-b8cd-47c0-94d1-3c4cea7dadab'))
                                            ? ClipOval(
                                                child: Image.network(
                                                  data.image.toString(),
                                                  width: 6.6.h,
                                                  height: 6.6.h,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Icon(Icons.person, size: 6.6.h);
                                                  },
                                                ),
                                              )
                                            : Icon(Icons.person, size: 6.6.h),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Expanded(
                                          child: Text(
                                            data.name.toString(),
                                            style: CustomTextStyles
                                                .darkHeadingTextStyle(
                                                    color: ThemeUtil.isDarkMode(
                                                            context)
                                                        ? AppColors.whiteColor
                                                        : Color(0xff19295C),
                                                    size: 15),
                                          ),
                                        ),
                                      ],
                                    )));
                          }),
                        ),
                      ),
                    ),
                  )
                : Container()),
          ],
        ),
      ),
    );
  }
}

class StoryWidget extends StatelessWidget {
  final List<String> stories;

  const StoryWidget({Key? key, required this.stories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: ListView.builder(
        itemCount: stories.length + 1,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: GestureDetector(
                onTap: () {
                  // Handle "Add Story" tap
                  print('Add Story tapped');
                },
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 30,
                      child: SvgPicture.asset('Assets/images/addStory.svg'),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Your Story',
                      style: CustomTextStyles.lightTextStyle(
                          color: Color(0xff99A1BE), size: 9.4),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // Friend's story circle
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: GestureDetector(
                onTap: () {
                  // Handle friend's story tap
                  print('Friend ${index} tapped');
                },
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(stories[
                          index - 1]), // -1 to adjust index for stories list
                      radius: 30,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Friend ${index}',
                      style: CustomTextStyles.lightTextStyle(
                          color: Color(0xff99A1BE), size: 9.4),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class ChatBox extends StatelessWidget {
  final String profileImageUrl;
  final String personName;
  final String lastMessage;
  final String dateTime;

  const ChatBox({
    Key? key,
    required this.profileImageUrl,
    required this.personName,
    required this.lastMessage,
    required this.dateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if image URL is valid before using NetworkImage
    final isValidImageUrl = profileImageUrl.isNotEmpty && 
                           profileImageUrl.contains('http') &&
                           !profileImageUrl.contains('c894ac58-b8cd-47c0-94d1-3c4cea7dadab');
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: isValidImageUrl ? NetworkImage(profileImageUrl) : null,
          backgroundColor: isValidImageUrl 
              ? Colors.transparent 
              : (ThemeUtil.isDarkMode(context) ? Color(0xff2A2A2A) : Color(0xffE5E5E5)),
          child: !isValidImageUrl
              ? Icon(
                  Icons.person,
                  size: 30,
                  color: ThemeUtil.isDarkMode(context) ? Color(0xff5A5A5A) : Color(0xffA5A5A5),
                )
              : null,
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                personName,
                style: CustomTextStyles.darkHeadingTextStyle(
                    size: 17,
                    color: ThemeUtil.isDarkMode(context)
                        ? AppColors.whiteColor
                        : Color(0Xff000000)),
              ),
              SizedBox(height: 0.2.h),
              Container(
                width: 60.w,
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lastMessage + ' · ',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyles.lightTextStyle(
                          size: 14, color: Colors.grey),
                    ),
                    Text(
                      dateTime,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Icon(Icons.check, size: 16),
      ],
    );
  }
}

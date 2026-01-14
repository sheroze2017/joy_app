import 'package:get/get.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/social_media/chat/bloc/chat_api.dart';
import 'package:joy_app/modules/social_media/chat/view/direct_chat.dart';

import '../model/create_conversation_model.dart';

class ChatController extends GetxController {
  late DioClient dioClient;
  late ChatApi chatApi;
  final convoDetails = Rxn<CreateConversation>();

  @override
  void onInit() {
    super.onInit();
    dioClient = DioClient.getInstance();
    chatApi = ChatApi(dioClient);
  }

  ProfileController _profileController = Get.put(ProfileController());

  RxList<dynamic> myConversations = <dynamic>[].obs;
  var isLoadingConversations = false.obs;

  Future<void> getMyConversations() async {
    isLoadingConversations.value = true;
    try {
      final userId = _profileController.userId.value;
      if (userId.isEmpty) {
        print('⚠️ [ChatController] User ID is empty');
        return;
      }
      final conversations = await chatApi.getMyConversations(userId, 'user');
      myConversations.value = conversations;
      print('✅ [ChatController] Loaded ${conversations.length} conversations');
    } catch (e) {
      print('❌ [ChatController] Error loading conversations: $e');
    } finally {
      isLoadingConversations.value = false;
    }
  }

  createConvo(int friendId, String friendName) async {
    try {
      CreateConversation result = await chatApi.createConversation(
          int.parse(_profileController.userId.value),
          friendId,
          _profileController.firstName.value.toString(),
          friendName);
      if (result.status == 'success') {
        convoDetails.value = result;
        Get.to(
            DirectMessageScreen(
              userName: friendName,
              friendId: friendId.toString(),
              userId: _profileController.userId.value,
              userAsset: _profileController.image.toString(),
            ),
            transition: Transition.native);
      } else {
        print(result);
      }
    } catch (e) {
      print(e);
    }
  }
}

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
              conversationId: result.data!.sId.toString(),
            ),
            transition: Transition.native);
      }
    } catch (e) {}
  }
}

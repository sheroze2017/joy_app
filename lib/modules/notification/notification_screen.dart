import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/auth/bloc/auth_api.dart';
import 'package:joy_app/modules/auth/models/user.dart';
import 'package:joy_app/modules/auth/utils/auth_hive_utils.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/widgets/appbar/custom_appbar.dart';
import 'package:joy_app/widgets/custom_message/notification_item.dart';
import 'package:joy_app/widgets/drawer/user_drawer.dart';
import 'package:joy_app/core/network/utils/extra.dart';

class NotificationScreen extends StatefulWidget {
  final bool showBackIcon;
  const NotificationScreen({this.showBackIcon = false, Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> _notifications = [];
  bool isPharmacyMode = false;
  bool isBloodBankMode = false;
  bool isHospitalMode = false;
  bool _isLoading = true;
  int _unreadCount = 0;
  late AuthApi _authApi;

  @override
  void initState() {
    super.initState();
    final dioClient = DioClient.getInstance();
    _authApi = AuthApi(dioClient);
    _checkMode();
    _fetchNotifications();
    FirebaseMessaging.onMessage.listen(_handleNotification);
  }

  Future<void> _fetchNotifications() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = await getCurrentUser();
      if (currentUser == null || currentUser.userId.isEmpty) {
        print('❌ [NotificationScreen] No user found');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      print('🔔 [NotificationScreen] Fetching notifications for user: ${currentUser.userId}');
      final response = await _authApi.getNotifications(currentUser.userId);

      if (response['sucess'] == true || response['success'] == true) {
        final data = response['data'] ?? {};
        final notifications = data['notifications'] as List<dynamic>? ?? [];
        final unreadCount = data['unread_count'] as int? ?? 0;

        setState(() {
          _notifications = notifications
              .map((n) => n as Map<String, dynamic>)
              .toList();
          _unreadCount = unreadCount;
          _isLoading = false;
        });

        print('✅ [NotificationScreen] Loaded ${_notifications.length} notifications, $unreadCount unread');
      } else {
        print('❌ [NotificationScreen] Failed to fetch notifications: ${response['message']}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ [NotificationScreen] Error fetching notifications: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleNotification(RemoteMessage message) async {
    // Handle notification data here
    print('');
    print('📱 [NotificationScreen] ========== NOTIFICATION RECEIVED IN SCREEN ==========');
    print('📱 [NotificationScreen] Notification Details:');
    print('   - Title: ${message.notification?.title ?? "null"}');
    print('   - Body: ${message.notification?.body ?? "null"}');
    print('   - Message ID: ${message.messageId ?? "null"}');
    print('📱 [NotificationScreen] ====================================================');
    print('');
    
    // Refresh notifications when a new one arrives
    await _fetchNotifications();
  }

  Future<void> _checkMode() async {
    UserHive? currentUser = await getCurrentUser();
    if (currentUser != null) {
      setState(() {
        isPharmacyMode = currentUser.userRole == 'PHARMACY';
        isBloodBankMode = currentUser.userRole == 'BLOODBANK';
        isHospitalMode = currentUser.userRole == 'HOSPITAL';
      });
    }
  }

  String _formatTime(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) {
      return 'Just now';
    }
    try {
      return getElapsedTime(createdAt);
    } catch (e) {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: widget.showBackIcon ? null : UserDrawer(),
      appBar: (isPharmacyMode || isBloodBankMode || isHospitalMode)
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.only(right: 24.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    decoration: BoxDecoration(
                        color: ThemeUtil.isDarkMode(context)
                            ? Color(0xffC5D3E3)
                            : Color(0xff4B5563),
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                      child: Text(
                        '$_unreadCount New',
                        style: CustomTextStyles.w600TextStyle(
                            color: ThemeUtil.isDarkMode(context)
                                ? AppColors.blackColor
                                : AppColors.whiteColor,
                            size: 14),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : HomeAppBar(
              isImage: widget.showBackIcon ? false : true,
              showIcon: widget.showBackIcon,
              title: 'Notification',
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: ThemeUtil.isDarkMode(context)
                            ? Color(0xffC5D3E3)
                            : Color(0xff4B5563),
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                      child: Text(
                        '$_unreadCount New',
                        style: CustomTextStyles.w600TextStyle(
                            color: ThemeUtil.isDarkMode(context)
                                ? AppColors.blackColor
                                : AppColors.whiteColor,
                            size: 14),
                      ),
                    ),
                  ),
                )
              ],
              leading: widget.showBackIcon ? Icon(Icons.arrow_back) : Text(''),
            ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _notifications.isEmpty
              ? Center(
                  child: Text(
                    'No notifications yet',
                    style: CustomTextStyles.lightTextStyle(
                        color: ThemeUtil.isDarkMode(context)
                            ? Color(0xffAAAAAA)
                            : null,
                        size: 16),
                  ),
                )
              : Container(
                  child: Padding(
                      padding: EdgeInsets.only(
                        left: 24.0,
                        right: 24.0,
                        top: (isPharmacyMode || isBloodBankMode || isHospitalMode) ? 60.0 : 24.0,
                        bottom: 24.0,
                      ),
                      child: ListView.separated(
                          itemCount: _notifications.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 5);
                          },
                          itemBuilder: (context, index) {
                            final notification = _notifications[index];
                            final title = notification['title'] as String? ?? 'Notification';
                            final message = notification['message'] as String? ?? '';
                            final createdAt = notification['created_at'] as String?;

                            return NotificationItem(
                                iconPath: 'Assets/icons/calendar-tick.svg',
                                title: title,
                                description: message,
                                time: _formatTime(createdAt));
                          })),
                ),
    );
  }
}

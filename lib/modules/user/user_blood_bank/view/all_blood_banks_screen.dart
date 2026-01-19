import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/appbar/custom_appbar.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/blood_bank/bloc/blood_bank_api.dart';
import 'package:joy_app/modules/blood_bank/model/blood_bank_details_model.dart';
import 'package:joy_app/modules/user/user_blood_bank/bloc/user_blood_bloc.dart';
import 'package:joy_app/modules/user/user_blood_bank/model/all_bloodbank_model.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/widgets/button/rounded_button.dart';
import 'package:sizer/sizer.dart';

class AllBloodBanksScreen extends StatefulWidget {
  const AllBloodBanksScreen({Key? key}) : super(key: key);

  @override
  State<AllBloodBanksScreen> createState() => _AllBloodBanksScreenState();
}

class _AllBloodBanksScreenState extends State<AllBloodBanksScreen> {
  final UserBloodBankController _controller = Get.find<UserBloodBankController>();
  final BloodBankApi _bloodBankApi = BloodBankApi(DioClient.getInstance());
  bool _isLoading = true;
  String? _errorMessage;
  List<BloodBank> _bloodBanks = [];

  @override
  void initState() {
    super.initState();
    _fetchAllBloodBanks();
  }

  Future<void> _fetchAllBloodBanks() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _controller.getAllBloodBank();
      setState(() {
        _bloodBanks = response.data ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load blood banks: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _showBloodBankDetails(BloodBank bloodBank) async {
    // Get the userId from _id or userId field
    final userId = bloodBank.id?.toString() ?? bloodBank.userId?.toString();
    if (userId == null || userId.isEmpty) {
      Get.snackbar(
        'Error',
        'Invalid blood bank ID',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Show loading
    Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final details = await _bloodBankApi.getBloodBankDetail(userId);
      Get.back(); // Close loading dialog

      // Show bottom sheet with details
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _buildBloodBankDetailsSheet(details.data),
      );
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'Failed to load blood bank details: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }


  Widget _buildBloodBankDetailsSheet(Data? details) {
    if (details == null) {
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: ThemeUtil.isDarkMode(context)
              ? Color(0xff121212)
              : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Text('No details available'),
      );
    }

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeUtil.isDarkMode(context) ? Color(0xff121212) : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header
            Center(
              child: Column(
                children: [
                  _buildBloodBankImage(details.image),
                  SizedBox(height: 2.h),
                  Text(
                    details.name ?? 'Blood Bank',
                    style: CustomTextStyles.darkHeadingTextStyle(
                      size: 24,
                      color: ThemeUtil.isDarkMode(context) ? Colors.white : null,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),

            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Patients',
                  '${details.patientsCount ?? 0}',
                ),
                _buildStatItem(
                  'Donors',
                  '${details.totalDonorsCount ?? 0}',
                ),
                _buildStatItem(
                  'Rating',
                  '${details.rating ?? 0.0}',
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // Active Requests
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Blood Requests',
                    '${details.activeBloodRequestsCount ?? 0}',
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: _buildStatItem(
                    'Plasma Requests',
                    '${details.activePlasmaRequestsCount ?? 0}',
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            // Location
            _buildSectionTitle('Location'),
            SizedBox(height: 1.h),
            Row(
              children: [
                SvgPicture.asset(
                  'Assets/icons/pindrop.svg',
                  width: 4.w,
                  height: 4.w,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    details.location ?? 'Location not available',
                    style: CustomTextStyles.lightTextStyle(size: 14),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            // About
            if (details.about != null && details.about!.isNotEmpty) ...[
              _buildSectionTitle('About'),
              SizedBox(height: 1.h),
              Text(
                details.about!,
                style: CustomTextStyles.lightTextStyle(size: 14),
              ),
              SizedBox(height: 3.h),
            ],

            // Timings
            if (details.timings != null && details.timings!.isNotEmpty) ...[
              _buildSectionTitle('Timings'),
              SizedBox(height: 1.h),
              Text(
                details.timings!,
                style: CustomTextStyles.lightTextStyle(size: 14),
              ),
              SizedBox(height: 3.h),
            ],

            // Contact Information
            _buildSectionTitle('Contact Information'),
            SizedBox(height: 1.h),
            if (details.phone != null && details.phone!.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: 1.h),
                child: Row(
                  children: [
                    Icon(Icons.phone, size: 5.w, color: AppColors.redColor),
                    SizedBox(width: 2.w),
                    Text(
                      details.phone!,
                      style: CustomTextStyles.lightTextStyle(size: 14),
                    ),
                  ],
                ),
              ),
            if (details.email != null && details.email!.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: 1.h),
                child: Row(
                  children: [
                    Icon(Icons.email, size: 5.w, color: AppColors.redColor),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        details.email!,
                        style: CustomTextStyles.lightTextStyle(size: 14),
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  Widget _buildBloodBankImage(String? imageUrl) {
    final isValidUrl = imageUrl != null &&
        imageUrl.isNotEmpty &&
        imageUrl != 'null' &&
        imageUrl.contains('http');

    if (isValidUrl) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: 30.w,
          height: 30.w,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => _buildPlaceholderImage(),
        ),
      );
    }
    return _buildPlaceholderImage();
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 30.w,
      height: 30.w,
      decoration: BoxDecoration(
        color: ThemeUtil.isDarkMode(context) ? Color(0xff2A2A2A) : Color(0xffE5E5E5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.local_hospital,
        size: 15.w,
        color: AppColors.redColor,
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ThemeUtil.isDarkMode(context) ? Color(0xff2A2A2A) : Color(0xffF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xffE5E7EB)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: CustomTextStyles.darkHeadingTextStyle(
              size: 20,
              color: ThemeUtil.isDarkMode(context) ? Colors.white : null,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: CustomTextStyles.lightTextStyle(
              size: 12,
              color: Color(0xff6B7280),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: CustomTextStyles.w600TextStyle(
        size: 16,
        color: ThemeUtil.isDarkMode(context) ? Color(0xffC8D3E0) : Color(0xff1F2A37),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        title: 'Blood Banks',
        leading: Icon(Icons.arrow_back),
        actions: [],
        showIcon: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _errorMessage!,
                          style: CustomTextStyles.lightTextStyle(size: 16),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 2.h),
                        RoundedButton(
                          text: 'Retry',
                          onPressed: _fetchAllBloodBanks,
                          backgroundColor: AppColors.redColor,
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                )
              : _bloodBanks.isEmpty
                  ? Center(
                      child: Text(
                        'No blood banks found',
                        style: CustomTextStyles.lightTextStyle(size: 16),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _fetchAllBloodBanks,
                      child: ListView.builder(
                        padding: EdgeInsets.all(16.0),
                        itemCount: _bloodBanks.length,
                        itemBuilder: (context, index) {
                          final bloodBank = _bloodBanks[index];
                          return _buildBloodBankCard(bloodBank);
                        },
                      ),
                    ),
    );
  }

  Widget _buildBloodBankCard(BloodBank bloodBank) {
    final isValidImage = bloodBank.image != null &&
        bloodBank.image!.isNotEmpty &&
        bloodBank.image != 'null' &&
        bloodBank.image!.contains('http');

    return InkWell(
      onTap: () => _showBloodBankDetails(bloodBank),
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: ThemeUtil.isDarkMode(context) ? Color(0xff1E1E1E) : Color(0xffF4F4F4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Color(0xffE5E7EB),
            width: 0.5,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: isValidImage
                    ? CachedNetworkImage(
                        imageUrl: bloodBank.image!,
                        width: 27.w,
                        height: 27.w,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => _buildCardPlaceholder(),
                      )
                    : _buildCardPlaceholder(),
              ),
              SizedBox(width: 4.w),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bloodBank.name ?? 'Blood Bank',
                      style: CustomTextStyles.darkHeadingTextStyle(
                        size: 16,
                        color: ThemeUtil.isDarkMode(context) ? Colors.white : null,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'Assets/icons/pindrop.svg',
                          width: 3.w,
                          height: 3.w,
                        ),
                        SizedBox(width: 1.w),
                        Expanded(
                          child: Text(
                            bloodBank.location ?? 'Location not available',
                            style: CustomTextStyles.lightTextStyle(
                              size: 12,
                              color: Color(0xff6B7280),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (bloodBank.phone != null && bloodBank.phone!.isNotEmpty) ...[
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          Icon(Icons.phone, size: 3.w, color: AppColors.redColor),
                          SizedBox(width: 1.w),
                          Expanded(
                            child: Text(
                              bloodBank.phone!,
                              style: CustomTextStyles.lightTextStyle(
                                size: 12,
                                color: Color(0xff6B7280),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardPlaceholder() {
    return Container(
      width: 27.w,
      height: 27.w,
      decoration: BoxDecoration(
        color: ThemeUtil.isDarkMode(context) ? Color(0xff2A2A2A) : Color(0xffE5E5E5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.local_hospital,
        size: 12.w,
        color: AppColors.redColor,
      ),
    );
  }
}


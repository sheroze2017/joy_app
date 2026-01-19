import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/Widgets/appbar/custom_appbar.dart';
import 'package:joy_app/common/profile/view/my_profile.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/blood_bank/bloc/blood_bank_api.dart';
import 'package:joy_app/modules/user/user_blood_bank/model/donor_details_model.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/widgets/button/rounded_button.dart';
import 'package:sizer/sizer.dart';

class DonorDetailApiScreen extends StatefulWidget {
  final String userId;

  const DonorDetailApiScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<DonorDetailApiScreen> createState() => _DonorDetailApiScreenState();
}

class _DonorDetailApiScreenState extends State<DonorDetailApiScreen> {
  final BloodBankApi _bloodBankApi = BloodBankApi(DioClient.getInstance());
  bool _isLoading = true;
  DonorDetailsData? _donorDetails;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDonorDetails();
  }

  Future<void> _fetchDonorDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _bloodBankApi.getDonorDetails(widget.userId);
      setState(() {
        _donorDetails = response.data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load donor details: ${e.toString()}';
        _isLoading = false;
      });
    }
  }


  Widget _buildProfileImage(String? imageUrl) {
    final isValidUrl = imageUrl != null &&
        imageUrl.isNotEmpty &&
        imageUrl != 'null' &&
        imageUrl.contains('http') &&
        !imageUrl.contains('c894ac58-b8cd-47c0-94d1-3c4cea7dadab');

    if (isValidUrl) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: 23.74.w,
          height: 23.74.w,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => _buildPlaceholderImage(),
        ),
      );
    }
    return _buildPlaceholderImage();
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 23.74.w,
      height: 23.74.w,
      decoration: BoxDecoration(
        color: ThemeUtil.isDarkMode(context) ? Color(0xff2A2A2A) : Color(0xffE5E5E5),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person,
        size: 15.w,
        color: ThemeUtil.isDarkMode(context) ? Color(0xff5A5A5A) : Color(0xffA5A5A5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        title: 'Donor Detail',
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
                          onPressed: _fetchDonorDetails,
                          backgroundColor: AppColors.redColor,
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                )
              : _donorDetails == null
                  ? Center(
                      child: Text(
                        'No donor details found',
                        style: CustomTextStyles.lightTextStyle(size: 16),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 1.5.h),
                            // Profile Header
                            Row(
                              children: [
                                _buildProfileImage(_donorDetails!.image),
                                SizedBox(width: 5.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _donorDetails!.name ?? 'Donor',
                                        style: CustomTextStyles.lightSmallTextStyle(
                                          size: 24,
                                          color: ThemeUtil.isDarkMode(context)
                                              ? Colors.white
                                              : Color(0xff1F2A37),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            'Assets/icons/donationcount.svg',
                                          ),
                                          Text(
                                            '  ${_donorDetails!.totalDonations ?? 0}',
                                            style: CustomTextStyles.lightSmallTextStyle(
                                              size: 26,
                                            ),
                                          )
                                        ],
                                      ),
                                      Text(
                                        'Donations',
                                        style: CustomTextStyles.lightSmallTextStyle(
                                          size: 14,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 3.h),
                            // About Section
                            if (_donorDetails!.about != null && _donorDetails!.about!.isNotEmpty) ...[
                              Heading(title: 'About me', size: 14),
                              Text(
                                _donorDetails!.about!,
                                style: CustomTextStyles.lightTextStyle(size: 12),
                              ),
                              SizedBox(height: 3.h),
                            ],
                            // Blood Group
                            if (_donorDetails!.bloodGroup != null && _donorDetails!.bloodGroup!.isNotEmpty) ...[
                              Heading(title: 'Blood Group', size: 14),
                              Text(
                                _donorDetails!.bloodGroup!,
                                style: CustomTextStyles.lightTextStyle(size: 14.91),
                              ),
                              SizedBox(height: 3.h),
                            ],
                            // Gender
                            if (_donorDetails!.profile?.demographics?.gender != null && 
                                _donorDetails!.profile!.demographics!.gender!.isNotEmpty) ...[
                              Heading(title: 'Gender', size: 14),
                              Text(
                                _donorDetails!.profile!.demographics!.gender!,
                                style: CustomTextStyles.lightTextStyle(size: 14.91),
                              ),
                              SizedBox(height: 3.h),
                            ],
                            // Date of Birth
                            if (_donorDetails!.profile?.demographics?.dob != null && 
                                _donorDetails!.profile!.demographics!.dob!.isNotEmpty) ...[
                              Heading(title: 'Date of Birth', size: 14),
                              Text(
                                _donorDetails!.profile!.demographics!.dob!,
                                style: CustomTextStyles.lightTextStyle(size: 14.91),
                              ),
                              SizedBox(height: 3.h),
                            ],
                            // Age
                            if (_donorDetails!.age != null) ...[
                              Heading(title: 'Age', size: 14),
                              Text(
                                '${_donorDetails!.age}',
                                style: CustomTextStyles.lightTextStyle(size: 14.91),
                              ),
                              SizedBox(height: 3.h),
                            ],
                            // Location
                            if (_donorDetails!.location != null && _donorDetails!.location!.isNotEmpty) ...[
                              Heading(title: 'Location', size: 14),
                              Text(
                                _donorDetails!.location!,
                                style: CustomTextStyles.lightTextStyle(size: 14.91),
                              ),
                              SizedBox(height: 3.h),
                            ],
                            // Email
                            if (_donorDetails!.email != null && _donorDetails!.email!.isNotEmpty) ...[
                              Heading(title: 'Email', size: 14),
                              Text(
                                _donorDetails!.email!,
                                style: CustomTextStyles.lightTextStyle(size: 14.91),
                              ),
                              SizedBox(height: 3.h),
                            ],
                            // Phone
                            if (_donorDetails!.phone != null && _donorDetails!.phone!.isNotEmpty) ...[
                              Heading(title: 'Phone', size: 14),
                              Text(
                                _donorDetails!.phone!,
                                style: CustomTextStyles.lightTextStyle(size: 14.91),
                              ),
                              SizedBox(height: 3.h),
                            ],
                          ],
                        ),
                      ),
                    ),
    );
  }
}


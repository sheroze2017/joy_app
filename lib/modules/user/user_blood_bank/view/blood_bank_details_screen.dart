import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/Widgets/appbar/custom_appbar.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/blood_bank/bloc/blood_bank_api.dart';
import 'package:joy_app/modules/blood_bank/model/blood_bank_details_model.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/widgets/button/rounded_button.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class BloodBankDetailsScreen extends StatefulWidget {
  final String userId;
  
  const BloodBankDetailsScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<BloodBankDetailsScreen> createState() => _BloodBankDetailsScreenState();
}

class _BloodBankDetailsScreenState extends State<BloodBankDetailsScreen> {
  late final BloodBankApi _bloodBankApi;
  bool _isLoading = true;
  BloodBankDetails? _bloodBankDetails;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _bloodBankApi = BloodBankApi(DioClient.getInstance());
    _fetchBloodBankDetails();
  }

  Future<void> _fetchBloodBankDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final details = await _bloodBankApi.getBloodBankDetail(widget.userId);
      setState(() {
        _bloodBankDetails = details;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load blood bank details: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _makePhoneCall(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        title: 'All Donors',
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
                          onPressed: _fetchBloodBankDetails,
                          backgroundColor: AppColors.redColor,
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                )
              : _bloodBankDetails?.data == null
                  ? Center(
                      child: Text(
                        'No blood bank details found',
                        style: CustomTextStyles.lightTextStyle(size: 16),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _fetchBloodBankDetails,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header with Image and Name
                            Center(
                              child: Column(
                                children: [
                                  _buildBloodBankImage(_bloodBankDetails!.data!.image),
                                  SizedBox(height: 2.h),
                                  Text(
                                    _bloodBankDetails!.data!.name ?? 'Blood Bank',
                                    style: CustomTextStyles.darkHeadingTextStyle(
                                      size: 24,
                                      color: ThemeUtil.isDarkMode(context)
                                          ? Colors.white
                                          : null,
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
                                _buildStatCard(
                                  'Patients',
                                  '${_bloodBankDetails!.data!.patientsCount ?? 0}',
                                  'Assets/icons/donationcount.svg',
                                ),
                                _buildStatCard(
                                  'Donors',
                                  '${_bloodBankDetails!.data!.totalDonorsCount ?? 0}',
                                  'Assets/icons/donationcount.svg',
                                ),
                                _buildStatCard(
                                  'Rating',
                                  '${_bloodBankDetails!.data!.rating ?? 0.0}',
                                  'Assets/icons/star.svg',
                                ),
                              ],
                            ),
                            SizedBox(height: 3.h),

                            // Active Requests
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: _buildStatCard(
                                    'Blood Requests',
                                    '${_bloodBankDetails!.data!.activeBloodRequestsCount ?? 0}',
                                    'Assets/icons/blood.svg',
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: _buildStatCard(
                                    'Plasma Requests',
                                    '${_bloodBankDetails!.data!.activePlasmaRequestsCount ?? 0}',
                                    'Assets/icons/blood.svg',
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 3.h),

                            // Location
                            Heading(title: 'Location', size: 16),
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
                                    _bloodBankDetails!.data!.location ?? 'Location not available',
                                    style: CustomTextStyles.lightTextStyle(size: 14),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 3.h),

                            // About
                            if (_bloodBankDetails!.data!.about != null &&
                                _bloodBankDetails!.data!.about!.isNotEmpty) ...[
                              Heading(title: 'About', size: 16),
                              SizedBox(height: 1.h),
                              Text(
                                _bloodBankDetails!.data!.about!,
                                style: CustomTextStyles.lightTextStyle(size: 14),
                              ),
                              SizedBox(height: 3.h),
                            ],

                            // Timings
                            if (_bloodBankDetails!.data!.timings != null &&
                                _bloodBankDetails!.data!.timings!.isNotEmpty) ...[
                              Heading(title: 'Timings', size: 16),
                              SizedBox(height: 1.h),
                              Text(
                                _bloodBankDetails!.data!.timings!,
                                style: CustomTextStyles.lightTextStyle(size: 14),
                              ),
                              SizedBox(height: 3.h),
                            ],

                            // Contact Information
                            Heading(title: 'Contact Information', size: 16),
                            SizedBox(height: 1.h),
                            if (_bloodBankDetails!.data!.phone != null &&
                                _bloodBankDetails!.data!.phone!.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(bottom: 1.h),
                                child: Row(
                                  children: [
                                    Icon(Icons.phone, size: 5.w, color: AppColors.redColor),
                                    SizedBox(width: 2.w),
                                    Text(
                                      _bloodBankDetails!.data!.phone!,
                                      style: CustomTextStyles.lightTextStyle(size: 14),
                                    ),
                                  ],
                                ),
                              ),
                            if (_bloodBankDetails!.data!.email != null &&
                                _bloodBankDetails!.data!.email!.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(bottom: 1.h),
                                child: Row(
                                  children: [
                                    Icon(Icons.email, size: 5.w, color: AppColors.redColor),
                                    SizedBox(width: 2.w),
                                    Expanded(
                                      child: Text(
                                        _bloodBankDetails!.data!.email!,
                                        style: CustomTextStyles.lightTextStyle(size: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            SizedBox(height: 3.h),

                            // Contact Button
                            RoundedButton(
                              text: 'Contact Blood Bank',
                              onPressed: () {
                                if (_bloodBankDetails!.data!.phone != null &&
                                    _bloodBankDetails!.data!.phone!.isNotEmpty) {
                                  _makePhoneCall(_bloodBankDetails!.data!.phone!);
                                }
                              },
                              backgroundColor: AppColors.redColor,
                              textColor: Colors.white,
                            ),

                            SizedBox(height: 3.h),
                          ],
                        ),
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
        color: ThemeUtil.isDarkMode(context)
            ? Color(0xff2A2A2A)
            : Color(0xffE5E5E5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.local_hospital,
        size: 15.w,
        color: AppColors.redColor,
      ),
    );
  }

  Widget _buildStatCard(String label, String value, String iconPath) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ThemeUtil.isDarkMode(context)
            ? Color(0xff2A2A2A)
            : Color(0xffF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xffE5E7EB),
        ),
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            iconPath,
            width: 6.w,
            height: 6.w,
            color: AppColors.redColor,
          ),
          SizedBox(height: 1.h),
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
}

class Heading extends StatelessWidget {
  final String title;
  final double size;

  Heading({Key? key, required this.title, this.size = 20}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: CustomTextStyles.w600TextStyle(
        size: size,
        color: ThemeUtil.isDarkMode(context)
            ? Color(0xffC8D3E0)
            : Color(0xff1F2A37),
      ),
    );
  }
}


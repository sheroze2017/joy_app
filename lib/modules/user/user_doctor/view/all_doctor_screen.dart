import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
import 'package:joy_app/modules/user/user_doctor/model/all_doctor_model.dart';
import 'package:joy_app/modules/user/user_doctor/view/doctor_detail_screen2.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/blood_bank/view/all_donor_screen.dart';
import 'package:joy_app/modules/blood_bank/view/blood_appeal_screen.dart';
import 'package:joy_app/modules/social_media/friend_request/view/new_friend.dart';
import 'package:joy_app/Widgets/appbar/custom_appbar.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/modules/user/user_doctor/view/manage_booking.dart';
import 'package:joy_app/widgets/dailog/confirmation_dailog.dart';
import 'package:joy_app/widgets/loader/loader.dart';
import 'package:sizer/sizer.dart';

import '../bloc/user_doctor_bloc.dart';
import 'booking_history.dart';

class AllDoctorsScreen extends StatefulWidget {
  final bool isPharmacy;
  final bool isBloodBank;
  final bool isHospital;
  final String appBarText;
  bool isSelectable;
  AllDoctorsScreen(
      {super.key,
      this.isPharmacy = false,
      this.isBloodBank = false,
      this.isHospital = false,
      this.isSelectable = false,
      required this.appBarText});

  @override
  State<AllDoctorsScreen> createState() => _AllDoctorsScreenState();
}

class _AllDoctorsScreenState extends State<AllDoctorsScreen> {
  final _userdoctorController = Get.find<UserDoctorController>();
  final _profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    // Load doctor categories with doctors
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _userdoctorController.getDoctorCategoriesWithDoctors();
    });
  }

  void _searchByName(String query) {
    if (query.isEmpty) {
      _userdoctorController.searchDoctorsList.assignAll(_userdoctorController.doctorsList);
    } else {
      final filtered = _userdoctorController.doctorsList.where((doctor) {
        final name = doctor.name?.toLowerCase() ?? '';
        final expertise = doctor.expertise?.toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();
        return name.contains(searchQuery) || expertise.contains(searchQuery);
      }).toList();
      _userdoctorController.searchDoctorsList.assignAll(filtered);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: widget.isSelectable
          ? Container()
          : Drawer(
              backgroundColor: AppColors.darkBlueColor,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Image.network(
                            _profileController.image.contains('http')
                                ? _profileController.image.toString()
                                : 'http://194.233.69.219/joy-Images//c894ac58-b8cd-47c0-94d1-3c4cea7dadab.png',
                            width: 12.8.w,
                            height: 12.8.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          width: 3.w,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _profileController.firstName.toString(),
                                style: CustomTextStyles.w600TextStyle(
                                  size: 15.59,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                _profileController.email.toString(),
                                style: CustomTextStyles.lightSmallTextStyle(
                                  color: Color(0xffF4D9E5),
                                  size: 12.47,
                                ),
                              ),
                              SizedBox(
                                width: 0.5.w,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(ManageAllAppointmentUser());
                      },
                      child: DrawerItem(
                        isBloodBank: false,
                        isBooking: true,
                        bookingText: 'My Booking',
                        bookingAsset: 'Assets/icons/booking.svg',
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(UserBookingHistory());
                      },
                      child: DrawerItem(
                        isBloodBank: false,
                        isBooking: false,
                        bookingText: 'Medical History',
                        bookingAsset: 'Assets/icons/bookingplus.svg',
                      ),
                    ),
                  ],
                ),
              ),
            ),
      appBar: HomeAppBar(
          title: widget.appBarText,
          leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(Icons.arrow_back)),
          actions: [],
          showIcon: true),
      body: RefreshIndicator(
        onRefresh: () async {
          await _userdoctorController.getDoctorCategoriesWithDoctors();
        },
        child: Obx(
          () => _userdoctorController.showLoader.value
              ? Center(child: LoadingWidget())
              : SingleChildScrollView(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 1.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: RoundedSearchTextField(
                              onChanged: _searchByName,
                              hintText: 'Search doctor...',
                              controller: TextEditingController()),
                        ),
                        SizedBox(
                          height: 1.5.h,
                        ),
                        // Horizontal categories list
                        Container(
                          height: 22.h, // Height for category cards
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(left: 16.0),
                            itemCount: _userdoctorController.doctorCategories.length,
                            itemBuilder: (context, index) {
                              final category = _userdoctorController.doctorCategories[index];
                              final isSelected = _userdoctorController.selectedCategory.value?.categoryId == category.categoryId;
                              final doctorCount = category.doctors?.length ?? 0;
                              // Get first 3 doctor images for avatars
                              final doctorImages = category.doctors != null && category.doctors!.isNotEmpty
                                  ? category.doctors!.take(3).map((d) => d.image ?? '').toList()
                                  : <String>[];
                              
                              return Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: InkWell(
                                  onTap: () {
                                    _userdoctorController.selectCategory(category);
                                  },
                                  child: DoctorCategoryCard(
                                    categoryName: category.name ?? '',
                                    doctorCount: doctorCount,
                                    isSelected: isSelected,
                                    doctorImages: doctorImages,
                                    categoryIndex: index,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 1.5.h,
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Obx(
                              () => Text(
                                _userdoctorController.searchDoctorsList.length.toString() + ' found',
                                style: CustomTextStyles.darkHeadingTextStyle(
                                    color: ThemeUtil.isDarkMode(context)
                                        ? Color(0xffC8D3E0)
                                        : null),
                              ),
                            )),
                        SizedBox(
                          height: 1.h,
                        ),
                        Obx(
                          () => VerticalDoctorsList(
                            isSelectable: widget.isSelectable,
                            doctorList: _userdoctorController.searchDoctorsList.toList(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final bool isBooking;
  final String bookingText;
  final String bookingAsset;
  final isBloodBank;
  const DrawerItem({
    required this.isBooking,
    required this.bookingText,
    required this.bookingAsset,
    required this.isBloodBank,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(62),
        color: isBooking
            ? Colors.white
            : isBloodBank
                ? AppColors.redColor
                : AppColors.darkBlueColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
        child: Row(
          children: [
            Container(
              child: SvgPicture.asset(
                bookingAsset,
              ),
              height: 6.w,
              width: 6.w,
            ),
            SizedBox(width: 3.w),
            Text(
              bookingText,
              style: CustomTextStyles.w600TextStyle(
                  size: 16,
                  color: isBooking ? Color(0xff1F1F29) : Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorsCardWidget extends StatelessWidget {
  final String imgUrl;
  final String Category;
  final String docName;
  final String loction;
  final String reviewCount;
  final bool isFav;
  final String rating;

  const DoctorsCardWidget(
      {super.key,
      required this.imgUrl,
      required this.Category,
      required this.docName,
      required this.loction,
      required this.reviewCount,
      this.isFav = false,
      required this.rating});

  Widget _buildDoctorAvatar(String? url, double size, BuildContext context) {
    final isValidUrl = url != null &&
        url.trim().isNotEmpty &&
        url.trim().toLowerCase() != 'null' &&
        url.contains('http') &&
        !url.contains('c894ac58-b8cd-47c0-94d1-3c4cea7dadab');

    if (isValidUrl) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: CachedNetworkImage(
          imageUrl: url.trim(),
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (context, url) => Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: LoadingWidget(),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: ThemeUtil.isDarkMode(context) ? Color(0xff2A2A2A) : Color(0xffE5E5E5),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Icon(
              Icons.person,
              size: size * 0.5,
              color: ThemeUtil.isDarkMode(context) ? Color(0xff5A5A5A) : Color(0xffA5A5A5),
            ),
          ),
        ),
      );
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: ThemeUtil.isDarkMode(context) ? Color(0xff2A2A2A) : Color(0xffE5E5E5),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Icon(
        Icons.person,
        size: size * 0.5,
        color: ThemeUtil.isDarkMode(context) ? Color(0xff5A5A5A) : Color(0xffA5A5A5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
            color: ThemeUtil.isDarkMode(context)
                ? Color(0xff151515)
                : Color(0xffEEF5FF),
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              _buildDoctorAvatar(imgUrl, 27.9.w, context),
              SizedBox(
                width: 2.w,
              ),
              Expanded(
                child: Container(
                  width: 51.28.w,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          docName,
                          style: CustomTextStyles.darkHeadingTextStyle(
                              color: ThemeUtil.isDarkMode(context)
                                  ? Color(0xffC8D3E0)
                                  : null),
                        ),
                        SizedBox(height: 0.5.h),
                        // Show expertise/specialty
                        Text(
                          Category.isNotEmpty ? Category : '',
                          style: CustomTextStyles.w600TextStyle(
                              size: 14, color: Color(0xff4B5563)),
                        ),
                        SizedBox(height: 0.5.h),
                        // Show location if available
                        if (loction.isNotEmpty)
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 12,
                                color: Color(0xff6B7280),
                              ),
                              SizedBox(width: 0.3.w),
                              Expanded(
                                child: Text(
                                  loction,
                                  style: CustomTextStyles.lightTextStyle(
                                      color: Color(0xff6B7280), size: 11),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        SizedBox(height: 0.5.h),
                        // Show stars and review count
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            SizedBox(width: 0.3.w),
                            Text(
                              rating,
                              style: CustomTextStyles.lightTextStyle(
                                  color: Color(0xff4B5563), size: 12)),
                            SizedBox(width: 0.5.w),
                            Text(
                              '| ${reviewCount} Reviews',
                              style: CustomTextStyles.lightTextStyle(
                                  color: Color(0xff6B7280), size: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DoctorCategory extends StatelessWidget {
  final String catrgory;
  final String DoctorCount;
  final Color bgColor;
  final Color fgColor;
  final String imagePath;
  bool isBloodBank;
  bool? isUser;
  bool isAppeal;
  List<String>? images;

  DoctorCategory(
      {super.key,
      required this.catrgory,
      required this.DoctorCount,
      required this.bgColor,
      required this.fgColor,
      this.isAppeal = false,
      required this.imagePath,
      this.isBloodBank = false,
      this.images,
      this.isUser = true});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: isUser == false ? 0 : 8.0),
      child: Container(
        width: isBloodBank ? 38.87.w : 37.54.w,
        decoration: BoxDecoration(
            color: bgColor, borderRadius: BorderRadius.circular(22.31)),
        child: Padding(
          padding: isBloodBank
              ? EdgeInsets.fromLTRB(15.44, 8, 12, 8)
              : EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: fgColor, borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: EdgeInsets.all(isBloodBank ? 5.0 : 8.0),
                  child: SvgPicture.asset(
                    imagePath,
                    width: isBloodBank ? 18 : null,
                    height: isBloodBank ? 18 : null,
                  ),
                ),
              ),
              SizedBox(height: isBloodBank ? 6 : 0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    catrgory,
                    style: CustomTextStyles.w600TextStyle(
                        color: AppColors.blackColor393,
                        size: isBloodBank ? 13 : 18.86,
                        letterspacing: -1),
                  ),
                  // Hide the count text for blood bank mode
                  if (!isBloodBank)
                    Text(
                      '${DoctorCount} Doctors',
                      style: CustomTextStyles.lightTextStyle(
                          color: AppColors.blackColor393,
                          size: 15.44),
                    ),
                ],
              ),
              // Remove round circles for blood bank mode - only show for user mode and not blood bank
              isUser == true && !isBloodBank
                  ? Builder(
                      builder: (context) {
                        // Remove any non-numeric characters (like '+') before parsing
                        final numericString = DoctorCount.replaceAll(RegExp(r'[^0-9]'), '');
                        final count = numericString.isNotEmpty ? int.tryParse(numericString) ?? 0 : 0;
                        final displayCount = count >= 3 ? 3 : count;
                        return Row(
                          children: [
                            for (var i = 0; i < displayCount; i++)
                              Container(
                                width: 3.h,
                                height: 3.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  border: Border.all(
                                    color: AppColors.whiteColor,
                                    width: 1,
                                  ),
                                ),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(images == null ||
                                          !images![i].contains('http')
                                      ? 'https://s3-alpha-sig.figma.com/img/03f8/d194/48dd31b8127b7f6577d5ff98da01cf59?Expires=1718582400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=lgLceP1ZBkEXbOBgkLxwPEqC~XNBIv8ttTKC8oLRSutfDk3qzEwbwicLgmk6ck-utlWYJsPIw-N4~zYhSpW9xy8F3RVnsS6c-JH7gXOAszbQREfqlywHKb~qxnVTLZEdGtniH7XzTgyNNaI6f67HuUYN~YSh0brcpTS2lolLBxHo0Aj77cTy~7My4KdTR52XEUTm-0ojlJL6H-KvF6hzPFZa4LjyV6x5XO8kCpIPfBSo~9OccwFKXGgGlxfLqR5yAgt3VChGyZlDYIkgdWc9hmceD2~WmVaQvS6HtzF0W4Mc0T26ON-R8JTQc~iOvfm7gHB-dJwxN0GOVe8q8B-wIA__'
                                      : images![i].toString()),
                                ),
                              ),
                            if (count >= 3)
                              Container(
                                width: 3.h,
                                height: 3.h,
                                decoration: BoxDecoration(
                                  color: Color(0xffD1C3E6),
                                  borderRadius: BorderRadius.circular(40),
                                  border: Border.all(
                                    color: AppColors.whiteColor,
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '+' + (count - 3).toString(),
                                    style: CustomTextStyles.lightTextStyle(
                                        size: 9.6, color: AppColors.blackColor393),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

// class HospitalName extends StatelessWidget {
//   const HospitalName({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       'Sunrise Health Clinic',
//       style: CustomTextStyles.darkHeadingTextStyle(
//           size: 12.67, color: Color(0xff4B5563)),
//     );
//   }
// }

class HorizontalDoctorCategories extends StatelessWidget {
  bool isBloodBank;

  HorizontalDoctorCategories({this.isBloodBank = false});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: isBloodBank ? bloodBankCategory.length : 5,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            if (isBloodBank) {
              index == 0
                  ? Get.to(
                      BloodDonationAppeal(
                        isBloodDontate: true,
                      ),
                      transition: Transition.native)
                  : index == 1
                      ? Get.to(BloodDonationAppeal(
                          isPlasmaDonate: true,
                        ))
                      : Get.to(AllDonorScreen(), transition: Transition.native);
            }
          },
          child: DoctorCategory(
            catrgory: isBloodBank ? bloodBankCategory[index] : 'Dental',
            DoctorCount: '$index',
            bgColor: isBloodBank
                ? bgColors[index % 2 == 0 ? 0 : 1]
                : ThemeUtil.isDarkMode(context)
                    ? bgColorsDoctorsDark[index % 2 == 0 ? 0 : 1]
                    : bgColorsDoctors[index % 2 == 0 ? 0 : 1],
            fgColor: isBloodBank
                ? fgColors[index % 2 == 0 ? 0 : 1]
                : fgColorsDoctors[index % 2 == 0 ? 0 : 1],
            imagePath: isBloodBank
                ? bloodBankCatImage[index % 2 == 0 ? 0 : 1]
                : 'Assets/icons/dental.svg',
            isBloodBank: isBloodBank,
          ),
        );
      },
    );
  }
}

// New category card widget for the new design
class DoctorCategoryCard extends StatelessWidget {
  final String categoryName;
  final int doctorCount;
  final bool isSelected;
  final List<String> doctorImages;
  final int categoryIndex;

  const DoctorCategoryCard({
    Key? key,
    required this.categoryName,
    required this.doctorCount,
    required this.isSelected,
    required this.doctorImages,
    required this.categoryIndex,
  }) : super(key: key);

  String? _getCategoryIconPath(String categoryName) {
    // Map category names to SVG icons
    final name = categoryName.toLowerCase();
    if (name.contains('dental') || name.contains('dentist')) {
      return 'Assets/icons/dental.svg';
    } else if (name.contains('cardio')) {
      return 'Assets/icons/heart.svg';
    } else if (name.contains('pediatric')) {
      return 'Assets/icons/health-care.svg';
    } else if (name.contains('neurolog')) {
      return 'Assets/icons/health-care.svg';
    } else if (name.contains('dermatolog')) {
      return 'Assets/icons/health-care.svg';
    } else if (name.contains('orthopedic')) {
      return 'Assets/icons/health-care.svg';
    } else if (name.contains('gynecolog')) {
      return 'Assets/icons/health-care.svg';
    } else if (name.contains('general') || name.contains('physician')) {
      return 'Assets/icons/hospital.svg';
    } else if (name.contains('family')) {
      return 'Assets/icons/health-care.svg';
    } else if (name.contains('emergency')) {
      return 'Assets/icons/health-care.svg';
    } else if (name.contains('surgeon')) {
      return 'Assets/icons/health-care.svg';
    } else if (name.contains('ent') || name.contains('ear') || name.contains('nose')) {
      return 'Assets/icons/health-care.svg';
    } else if (name.contains('eye') || name.contains('ophthalm')) {
      return 'Assets/icons/health-care.svg';
    } else if (name.contains('gastro')) {
      return 'Assets/icons/health-care.svg';
    } else if (name.contains('urolog') || name.contains('nephrolog')) {
      return 'Assets/icons/health-care.svg';
    } else if (name.contains('pulmon') || name.contains('chest')) {
      return 'Assets/icons/health-care.svg';
    } else if (name.contains('onco') || name.contains('cancer')) {
      return 'Assets/icons/health-care.svg';
    } else if (name.contains('endocrin') || name.contains('diabetes')) {
      return 'Assets/icons/health-care.svg';
    } else if (name.contains('hematolog') || name.contains('blood')) {
      return 'Assets/icons/blood.svg';
    } else if (name.contains('radio') || name.contains('sonolog') || name.contains('imaging')) {
      return 'Assets/icons/health-care.svg';
    } else if (name.contains('anesthes')) {
      return 'Assets/icons/health-care.svg';
    } else if (name.contains('physio') || name.contains('rehab')) {
      return 'Assets/icons/health-care.svg';
    } else if (name.contains('nutrition') || name.contains('diet')) {
      return 'Assets/icons/health-care.svg';
    } else if (name.contains('psych')) {
      return 'Assets/icons/health-care.svg';
    }
    // Default icon
    return 'Assets/icons/health-care.svg';
  }

  Color _getCategoryBgColor(int index) {
    final colors = [
      Color(0xFFE5E7EB), // Light gray
      Color(0xFFF3E8FF), // Light purple
      Color(0xFFE0F2FE), // Light blue
      Color(0xFFFEF3C7), // Light yellow
      Color(0xFFFCE7F3), // Light pink
    ];
    return colors[index % colors.length];
  }

  Color _getCategoryFgColor(int index) {
    final colors = [
      Color(0xFF9CA3AF), // Gray
      Color(0xFFC084FC), // Purple
      Color(0xFF60A5FA), // Blue
      Color(0xFFFBBF24), // Yellow
      Color(0xFFF472B6), // Pink
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = isSelected 
        ? _getCategoryFgColor(categoryIndex).withValues(alpha: 0.2)
        : _getCategoryBgColor(categoryIndex);
    final fgColor = _getCategoryFgColor(categoryIndex);
    
    return Container(
      width: 35.w,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: isSelected 
            ? Border.all(color: fgColor, width: 2)
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: fgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: SvgPicture.asset(
                  _getCategoryIconPath(categoryName) ?? 'Assets/icons/health-care.svg',
                  width: 6.w,
                  height: 6.w,
                  colorFilter: ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            SizedBox(height: 1.h),
            // Category name
            Text(
              categoryName,
              style: CustomTextStyles.w600TextStyle(
                color: AppColors.blackColor393,
                size: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 0.3.h),
            // Doctor count
            Text(
              '$doctorCount Doctors',
              style: CustomTextStyles.lightTextStyle(
                color: AppColors.blackColor393,
                size: 12,
              ),
            ),
            SizedBox(height: 1.h),
            // Doctor avatars
            if (doctorImages.isNotEmpty)
              Row(
                children: [
                  for (var i = 0; i < (doctorImages.length > 3 ? 3 : doctorImages.length); i++)
                    Container(
                      margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                        image: doctorImages[i].isNotEmpty && 
                               doctorImages[i].contains('http') &&
                               !doctorImages[i].contains('c894ac58-b8cd-47c0-94d1-3c4cea7dadab')
                            ? DecorationImage(
                                image: NetworkImage(doctorImages[i]),
                                fit: BoxFit.cover,
                                onError: (_, __) {},
                              )
                            : null,
                      ),
                      child: doctorImages[i].isEmpty || 
                             !doctorImages[i].contains('http') ||
                             doctorImages[i].contains('c894ac58-b8cd-47c0-94d1-3c4cea7dadab')
                          ? Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[300],
                              ),
                              child: Icon(Icons.person, size: 3.w, color: Colors.grey[600]),
                            )
                          : null,
                    ),
                  if (doctorCount > 3)
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFD1C3E6),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: Center(
                        child: Text(
                          '+${doctorCount - 3}',
                          style: CustomTextStyles.lightTextStyle(
                            size: 9,
                            color: AppColors.blackColor393,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class VerticalDoctorsList extends StatelessWidget {
  bool isSelectable;
  List<Doctor> doctorList;
  VerticalDoctorsList({required this.doctorList, required this.isSelectable});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: doctorList.length,
        itemBuilder: (context, index) {
          final doctorData = doctorList[index];
          return InkWell(
            onTap: () {
              final doctorId = doctorData.userId?.toString() ?? '';
              if (doctorId.isEmpty || doctorId == 'null') {
                // Show error or return early if doctor ID is invalid
                return;
              }
              isSelectable
                  ? showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmationDailog(
                          link_to_user_id: doctorId,
                        );
                      },
                    )
                  : Get.to(
                      DoctorDetailScreen2(
                        isFromHospital: false,
                        doctorId: doctorId,
                        docName: doctorData.name ?? 'Dr. Unknown',
                        location: doctorData.location ?? '',
                        Category: doctorData.expertise ?? '',
                      ),
                      transition: Transition.native);
            },
            child: DoctorsCardWidget(
              imgUrl: doctorData.image?.toString() ?? '',
              reviewCount: doctorData.reviews != null && doctorData.reviews!.isNotEmpty
                  ? doctorData.reviews!.length.toString()
                  : '0',
              docName: doctorData.name?.toString() ?? '',
              Category: (doctorData.expertise != null && doctorData.expertise!.isNotEmpty)
                  ? doctorData.expertise!
                  : '',
              loction: doctorData.location ?? '', // Show location
              rating: doctorData.averageRating != null && doctorData.averageRating! > 0
                  ? doctorData.averageRating!.toStringAsFixed(1)
                  : '0',
            ),
          );
        },
      ),
    );
  }
}

List<String> bloodBankCategory = [
  'Donate Blood',
  'Donate Plasma',
  'Appeal Blood'
];

List<String> bloodBankCatImage = [
  'Assets/images/blood.svg',
  'Assets/images/plasma.svg',
];
List bgColors = [AppColors.redLightColor, AppColors.yellowLightColor];
List fgColors = [AppColors.redLightDarkColor, AppColors.yellowLightDarkColor];

List bgColorsDoctors = [
  AppColors.lightBlueColore5e,
  AppColors.lightPurpleColore1e
];

List bgColorsDoctorsDark = [AppColors.purpleBlueColor, Color(0xff8B66C8)];

List fgColorsDoctors = [
  AppColors.lightBlueColord0d,
  AppColors.lightPurpleColord2c
];

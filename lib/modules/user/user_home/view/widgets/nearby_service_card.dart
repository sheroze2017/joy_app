import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/common/map/bloc/location_controller.dart';
import 'package:joy_app/modules/user/user_home/model/nearby_services_model.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:sizer/sizer.dart';

class NearbyServiceCard extends StatelessWidget {
  final NearbyPharmacy? pharmacy;
  final NearbyHospital? hospital;
  final NearbyDoctor? doctor;
  final BloodDonor? bloodDonor;
  final VoidCallback? onTap;

  NearbyServiceCard({
    Key? key,
    this.pharmacy,
    this.hospital,
    this.doctor,
    this.bloodDonor,
    this.onTap,
  }) : super(key: key);

  LocationController get locationController => Get.find<LocationController>();

  String get name {
    if (pharmacy != null) return pharmacy!.name ?? '';
    if (hospital != null) return hospital!.name ?? '';
    if (doctor != null) return doctor!.name ?? '';
    if (bloodDonor != null) return bloodDonor!.name ?? '';
    return '';
  }

  String get location {
    if (pharmacy != null) return pharmacy!.details?.location ?? pharmacy!.location ?? '';
    if (hospital != null) return hospital!.details?.location ?? hospital!.location ?? '';
    if (doctor != null) return doctor!.details?.location ?? doctor!.location ?? '';
    if (bloodDonor != null) {
      final loc = bloodDonor!.location ?? '';
      final city = bloodDonor!.city ?? '';
      return loc.isNotEmpty && city.isNotEmpty ? '$loc, $city' : (loc.isNotEmpty ? loc : city);
    }
    return '';
  }

  String get image {
    if (pharmacy != null) return pharmacy!.image ?? '';
    if (hospital != null) return hospital!.image ?? '';
    if (doctor != null) return doctor!.image ?? '';
    return '';
  }

  String? get lat {
    if (pharmacy != null) return pharmacy!.details?.lat;
    if (hospital != null) return hospital!.details?.lat;
    return null;
  }

  String? get lng {
    if (pharmacy != null) return pharmacy!.details?.lng;
    if (hospital != null) return hospital!.details?.lng;
    return null;
  }

  String get serviceType {
    if (pharmacy != null) return 'Pharmacy';
    if (hospital != null) return 'Hospital';
    if (doctor != null) return 'Doctor';
    if (bloodDonor != null) return 'Blood Donor';
    return '';
  }
  
  // Get average rating and review count
  String get ratingText {
    if (doctor != null) {
      final rating = doctor!.averageRating ?? 0.0;
      final reviewCount = doctor!.reviews?.length ?? 0;
      return '${rating.toStringAsFixed(1)} (${reviewCount} Reviews)';
    }
    if (pharmacy != null) {
      // For now, pharmacies don't have reviews in the model
      return '0.0 (0 Reviews)';
    }
    if (hospital != null) {
      // For now, hospitals don't have reviews in the model
      return '0.0 (0 Reviews)';
    }
    return '0.0 (0 Reviews)';
  }

  String get serviceIcon {
    if (pharmacy != null) return 'Assets/icons/pharmacy.svg';
    if (hospital != null) return 'Assets/icons/hospital.svg';
    if (bloodDonor != null) return 'Assets/icons/hospital.svg';
    return 'Assets/icons/hospital.svg';
  }

  String? get bloodGroup {
    if (bloodDonor != null) return bloodDonor!.bloodGroup;
    return null;
  }

  Widget _buildAvatarWidget(String? url, BuildContext context) {
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
          width: 35.71.w,
          height: 26.w,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => Container(
            width: 35.71.w,
            height: 26.w,
            decoration: BoxDecoration(
              color: ThemeUtil.isDarkMode(context) ? Color(0xff2A2A2A) : Color(0xffE5E5E5),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Icon(
              Icons.local_pharmacy,
              size: 20.w,
              color: ThemeUtil.isDarkMode(context) ? Color(0xff5A5A5A) : Color(0xffA5A5A5),
            ),
          ),
        ),
      );
    }
    return Container(
      width: 35.71.w,
      height: 26.w,
      decoration: BoxDecoration(
        color: ThemeUtil.isDarkMode(context) ? Color(0xff2A2A2A) : Color(0xffE5E5E5),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Icon(
        Icons.local_pharmacy,
        size: 20.w,
        color: ThemeUtil.isDarkMode(context) ? Color(0xff5A5A5A) : Color(0xffA5A5A5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.w, // Increased from 55.w to make cards wider
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffE5E7EB)),
        borderRadius: BorderRadius.circular(12),
        color: ThemeUtil.isDarkMode(context) ? Color(0xff121212) : Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Minimize vertical space
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 4.0), // Reduced bottom padding
              child: _buildAvatarWidget(image, context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: CustomTextStyles.darkHeadingTextStyle(
                color: ThemeUtil.isDarkMode(context) ? Colors.white : null,
                size: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              children: [
                SvgPicture.asset(
                  'Assets/icons/pindrop.svg',
                  width: 3.w,
                  height: 3.w,
                ),
                SizedBox(width: 0.5.w),
                Expanded(
                  child: Text(
                    location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.lightTextStyle(
                      color: Color(0xff6B7280),
                      size: 10.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (bloodDonor != null && bloodGroup != null)
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                children: [
                  Icon(Icons.bloodtype, size: 12, color: Colors.red),
                  SizedBox(width: 0.5.w),
                  Text(
                    bloodGroup!,
                    style: CustomTextStyles.lightTextStyle(
                      color: Color(0xff6B7280),
                      size: 10.8,
                    ),
                  ),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                children: [
                  Icon(Icons.star_outline, size: 12, color: Color(0xff6B7280)),
                  SizedBox(width: 0.5.w),
                  Text(
                    ratingText,
                    style: CustomTextStyles.lightTextStyle(
                      color: Color(0xff6B7280),
                      size: 10.8,
                    ),
                  ),
                ],
              ),
            ),
          Divider(
            color: Color(0xffE5E7EB),
            thickness: ThemeUtil.isDarkMode(context) ? 0.2 : 0.6,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 4), // Reduced bottom padding from 10 to 8, added top padding
            child: Row(
              children: [
                Row(
                  children: [
                    SvgPicture.asset('Assets/icons/routing.svg'),
                    SizedBox(width: 0.5.w),
                    Text(
                      lat != null && lng != null
                          ? (calculateDistance(
                                  double.tryParse(lat!) ?? 0.0,
                                  double.tryParse(lng!) ?? 0.0,
                                  locationController.latitude.value,
                                  locationController.longitude.value)
                              .toStringAsFixed(1) +
                              ' km/0min')
                          : 'N/A',
                      style: CustomTextStyles.lightTextStyle(
                        color: Color(0xff6B7280),
                        size: 10.8,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    SvgPicture.asset(serviceIcon),
                    SizedBox(width: 0.5.w),
                    Text(
                      serviceType,
                      style: CustomTextStyles.lightTextStyle(
                        color: Color(0xff6B7280),
                        size: 10.8,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // Radius of the earth in km
    var dLat = _toRad(lat2 - lat1);
    var dLon = _toRad(lon2 - lon1);
    var lat1Rad = _toRad(lat1);
    var lat2Rad = _toRad(lat2);

    var a = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLon / 2) * sin(dLon / 2) * cos(lat1Rad) * cos(lat2Rad);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var d = R * c;

    return d; // Distance in km
  }

  double _toRad(x) {
    return x * pi / 180;
  }
}

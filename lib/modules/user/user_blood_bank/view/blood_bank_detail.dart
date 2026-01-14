import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/common/profile/view/my_profile.dart';
import 'package:joy_app/core/utils/constant/constant.dart';
import 'package:joy_app/modules/blood_bank/model/all_donors_model.dart';
import 'package:joy_app/modules/blood_bank/view/component/donors_card.dart';
import 'package:joy_app/modules/user/user_blood_bank/view/widgets/donor_detail_sheet.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/social_media/friend_request/view/new_friend.dart';
import 'package:joy_app/Widgets/appbar/custom_appbar.dart';
import 'package:joy_app/widgets/button/rounded_button.dart';
import 'package:sizer/sizer.dart';

import '../model/all_bloodbank_model.dart';

class BloodBankDetailScreen extends StatefulWidget {
  final BloodBank donor;
  BloodBankDetailScreen({super.key, required this.donor});

  @override
  State<BloodBankDetailScreen> createState() => _BloodBankDetailScreenState();
}

class _BloodBankDetailScreenState extends State<BloodBankDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
          title: 'Blood Bank Detail',
          leading: Icon(Icons.arrow_back),
          actions: [],
          showIcon: true),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 1.5.h,
            ),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: (widget.donor.image!.contains('http') &&
                          !widget.donor.image!.contains('c894ac58-b8cd-47c0-94d1-3c4cea7dadab'))
                      ? Image.network(
                          widget.donor.image!,
                          width: 23.74.w,
                          height: 23.74.w,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 23.74.w,
                              height: 23.74.w,
                              decoration: BoxDecoration(
                                color: ThemeUtil.isDarkMode(context)
                                    ? Color(0xff2A2A2A)
                                    : Color(0xffE5E5E5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.person,
                                size: 15.w,
                                color: ThemeUtil.isDarkMode(context)
                                    ? Color(0xff5A5A5A)
                                    : Color(0xffA5A5A5),
                              ),
                            );
                          },
                        )
                      : Container(
                          width: 23.74.w,
                          height: 23.74.w,
                          decoration: BoxDecoration(
                            color: ThemeUtil.isDarkMode(context)
                                ? Color(0xff2A2A2A)
                                : Color(0xffE5E5E5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.person,
                            size: 15.w,
                            color: ThemeUtil.isDarkMode(context)
                                ? Color(0xff5A5A5A)
                                : Color(0xffA5A5A5),
                          ),
                        ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.donor.name.toString(),
                        style: CustomTextStyles.lightSmallTextStyle(
                            size: 24,
                            color: ThemeUtil.isDarkMode(context)
                                ? Colors.white
                                : Color(0xff1F2A37)),
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'Assets/icons/donationcount.svg',
                          ),
                          Text(
                            '  0',
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
            SizedBox(
              height: 3.h,
            ),
            Heading(title: 'Location', size: 14),
            Text(widget.donor.location.toString(),
                style: CustomTextStyles.lightTextStyle(size: 14.91)),
            SizedBox(
              height: 3.h,
            ),
            Row(
              children: [
                Expanded(
                  child: RoundedButton(
                    text: 'Contact Blood Bank',
                    onPressed: () {
                      makingPhoneCall(widget.donor.phone.toString());
                    },
                    backgroundColor: AppColors.redColor,
                    textColor: Color(0xffFFFFFF),
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

class _VerticalDonorsList extends StatelessWidget {
  final List<BloodDonor> donors;
  _VerticalDonorsList({required this.donors});
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8,
        childAspectRatio: 0.75, // Set the aspect ratio of the children
      ),
      itemCount: donors.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (BuildContext context) => DonorDetailSheet(
                donor: donors[index],
              ),
            );
          },
          child: DonorsCardWidget(
            color: donors[index].type == 'Plasma' ? bgColors[1] : bgColors[0],
            imgUrl: donors[index].image.toString(),
            docName: donors[index].name.toString(),
            Category: 'Blood ' + donors[index].bloodGroup.toString(),
            loction: donors[index].location.toString() +
                ' ' +
                donors[index].city.toString(),
            phoneNo: donors[index].phone.toString(),
            donId: donors[index].userId ?? 0,
          ),
        );
      },
    );
  }
}

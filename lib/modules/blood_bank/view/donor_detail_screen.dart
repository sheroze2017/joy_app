import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/common/profile/view/my_profile.dart';
import 'package:joy_app/core/utils/constant/constant.dart';
import 'package:joy_app/modules/blood_bank/model/all_donors_model.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/social_media/friend_request/view/new_friend.dart';
import 'package:joy_app/Widgets/appbar/custom_appbar.dart';
import 'package:joy_app/widgets/button/rounded_button.dart';
import 'package:sizer/sizer.dart';
import '../bloc/blood_bank_bloc.dart';
import 'component/donors_card.dart';

class DonorDetailScreen extends StatefulWidget {
  final BloodDonor donor;
  DonorDetailScreen({super.key, required this.donor});

  @override
  State<DonorDetailScreen> createState() => _DonorDetailScreenState();
}

class _DonorDetailScreenState extends State<DonorDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
          title: 'Donor Detail',
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
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    widget.donor.image!.contains('http')
                        ? widget.donor.image!
                        : CustomConstant.nullUserImage,
                    width: 23.74.w,
                    height: 23.74.w,
                    fit: BoxFit.cover,
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
            Heading(title: 'About me', size: 14),
            Text(
                'e veritatis et quasi architecto beatae vitae dicta sunt che explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur',
                style: CustomTextStyles.lightTextStyle(size: 12)),
            SizedBox(
              height: 3.h,
            ),
            Heading(title: 'Blood Group', size: 14),
            Text(widget.donor.bloodGroup.toString(),
                style: CustomTextStyles.lightTextStyle(size: 14.91)),
            SizedBox(
              height: 3.h,
            ),
            Heading(title: 'Age', size: 14),
            Text('null', style: CustomTextStyles.lightTextStyle(size: 14.91)),
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
                    text: 'Contact donor',
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
      itemBuilder: (context, index) {
        return DonorsCardWidget(
          color: donors[index].type == 'Plasma' ? bgColors[1] : bgColors[0],
          imgUrl: donors[index].image.toString(),
          docName: donors[index].name.toString(),
          Category: 'Blood ' + donors[index].bloodGroup.toString(),
          loction: donors[index].location.toString() +
              ' ' +
              donors[index].city.toString(),
          phoneNo: donors[index].phone.toString(),
          donId: donors[index].userId ?? 0,
        );
      },
    );
  }
}

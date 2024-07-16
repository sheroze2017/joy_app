import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/modules/blood_bank/model/all_donors_model.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/social_media/friend_request/view/new_friend.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:sizer/sizer.dart';

import '../bloc/blood_bank_bloc.dart';
import 'component/donors_card.dart';

class AllDonorScreen extends StatefulWidget {
  AllDonorScreen({super.key});

  @override
  State<AllDonorScreen> createState() => _AllDonorScreenState();
}

class _AllDonorScreenState extends State<AllDonorScreen> {
  BloodBankController _bloodBankController = Get.find<BloodBankController>();

  @override
  void initState() {
    super.initState();
    _bloodBankController.searchedDonors.value =
        _bloodBankController.allDonors.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
          title: 'All Donors',
          leading: Icon(Icons.arrow_back),
          actions: [],
          showIcon: true),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RoundedSearchTextField(
                onChanged: _bloodBankController.searchByBloodGroup,
                hintText: 'Search donors available',
                controller: TextEditingController()),
            SizedBox(
              height: 2.h,
            ),
            Text(
              '',
              style: CustomTextStyles.darkHeadingTextStyle(
                  color:
                      ThemeUtil.isDarkMode(context) ? Color(0xffC8D3E0) : null),
            ),
            SizedBox(
              height: 2.h,
            ),
            Expanded(
                child: Obx(
              () => _VerticalDonorsList(
                donors: _bloodBankController.searchedDonors.value,
              ),
            )),
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
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75, // Set the aspect ratio of the children
      ),
      itemCount: donors.length,
      itemBuilder: (context, index) {
        return DonorsCardWidget(
          color: donors[index].type == 'Plasma' ? bgColors[1] : bgColors[0],
          imgUrl: donors[index].image.toString(),
          docName: donors[index].name.toString(),
          Category: 'Blood ' + donors[index].bloodGroup.toString(),
          loction: donors[index].location.toString(),
          phoneNo: donors[index].phone.toString(),
        );
      },
    );
  }
}

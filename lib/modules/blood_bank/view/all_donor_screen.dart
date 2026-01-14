import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/modules/blood_bank/model/all_donors_model.dart';
import 'package:joy_app/modules/blood_bank/view/donor_detail_screen.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/social_media/friend_request/view/new_friend.dart';
import 'package:joy_app/Widgets/appbar/custom_appbar.dart';
import 'package:sizer/sizer.dart';

import '../bloc/blood_bank_bloc.dart';
import 'component/donors_card.dart';

class AllDonorScreen extends StatefulWidget {
  AllDonorScreen({super.key});

  @override
  State<AllDonorScreen> createState() => _AllDonorScreenState();
}

class _AllDonorScreenState extends State<AllDonorScreen> {
  BloodBankController _bloodBankController = Get.put(BloodBankController());

  @override
  void initState() {
    super.initState();
    // Defer observable updates to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load donors if not already loaded
      if (_bloodBankController.allDonors.isEmpty) {
        _bloodBankController.getallDonor();
      } else {
        _bloodBankController.searchedDonors.assignAll(_bloodBankController.allDonors);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
          title: 'All Donors',
          leading: Icon(Icons.arrow_back),
          actions: [],
          showIcon: true),
      body: RefreshIndicator(
        onRefresh: () async {
          _bloodBankController.getallDonor();
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RoundedSearchTextField(
                  onChanged: _bloodBankController.searchByBloodGroup,
                  hintText: 'Search donors available',
                  controller: TextEditingController()),
              SizedBox(
                height: 1.5.h,
              ),
              Obx(
                () => Text(
                  _bloodBankController.searchedDonors.length.toString() +
                      ' founds',
                  style: CustomTextStyles.darkHeadingTextStyle(
                      color: ThemeUtil.isDarkMode(context)
                          ? Color(0xffC8D3E0)
                          : null),
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Expanded(
                  child: Obx(
                () {
                  final donors = _bloodBankController.searchedDonors;
                  if (donors.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'No donors found',
                          style: CustomTextStyles.lightTextStyle(size: 16),
                        ),
                      ),
                    );
                  }
                  return _VerticalDonorsList(
                    donors: donors,
                  );
                },
              )),
            ],
          ),
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
        return InkWell(
          onTap: () {
            Get.to(DonorDetailScreen(donor: donors[index]));
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
            donId: donors[index].userId?.toString() ?? '',
          ),
        );
      },
    );
  }
}

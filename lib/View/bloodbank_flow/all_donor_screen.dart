import 'package:flutter/material.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/view/social_media/new_friend.dart';
import 'package:joy_app/widgets/custom_appbar.dart';
import 'package:sizer/sizer.dart';

import 'component/donors_card.dart';

class AllDonorScreen extends StatelessWidget {
  const AllDonorScreen({super.key});

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
                hintText: 'Search blood bank',
                controller: TextEditingController()),
            SizedBox(
              height: 2.h,
            ),
            Text(
              '532 found',
              style: CustomTextStyles.darkHeadingTextStyle(),
            ),
            SizedBox(
              height: 2.h,
            ),
            Expanded(
              child: VerticalDonorsList(),
            ),
          ],
        ),
      ),
    );
  }
}

class VerticalDonorsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75, // Set the aspect ratio of the children
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        return DonorsCardWidget(
          color: bgColors[index % 3 == 0 ? 0 : 1],
          imgUrl: '',
          docName: 'David Patel',
          Category: 'Blood Group B+',
          loction: 'Kohinoor City',
        );
      },
    );
  }
}

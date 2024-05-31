import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/view/Pharmacy_flow/add_medicine.dart';
import 'package:joy_app/view/social_media/new_friend.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:sizer/sizer.dart';

import '../user_flow/hospital_user/hospital_detail_screen.dart';
import '../user_flow/pharmacy_user/medicine_detail_screen.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
          title: 'Products',
          leading: Image(
            image: AssetImage('Assets/icons/arrow-left.png'),
            // height: 6.w,
            // width: .w,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: SvgPicture.asset('Assets/icons/cartred.svg'),
            ),
            InkWell(
              onTap: () {
                Get.to(AddMedicine());
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 24),
                child: SvgPicture.asset('Assets/icons/addrounded.svg'),
              ),
            ),
          ],
          showIcon: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            RoundedSearchTextField(
                hintText: 'Search', controller: TextEditingController()),
            SizedBox(
              height: 2.h,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(2, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: MedicineCard(
                            onPressed: () {
                              Get.to(
                                  MedicineDetailScreen(isPharmacyAdmin: true));
                            },
                            btnText: 'Edit',
                            imgUrl:
                                'https://i.guim.co.uk/img/media/20491572b80293361199ca2fc95e49dfd85e1f42/0_236_5157_3094/master/5157.jpg?width=1200&height=900&quality=85&auto=format&fit=crop&s=80ea7ebecd3f10fe721bd781e02184c3',
                            count: '10',
                            cost: '5',
                            name: 'Panadol',
                          ),
                        );
                      }),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}

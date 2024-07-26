import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/bloc/all_pharmacy_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/view/user_flow/pharmacy_user/mycart_screen.dart';
import 'package:sizer/sizer.dart';

import '../../../../social_media/friend_request/view/new_friend.dart';
import '../../../../../view/user_flow/hospital_user/hospital_detail_screen.dart';
import '../../../../../view/user_flow/pharmacy_user/medicine_detail_screen.dart';
import 'add_medicine.dart';

class ProductScreen extends StatefulWidget {
  final String userId;
  final bool isAdmin;
  ProductScreen({required this.userId, required this.isAdmin});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final pharmacyController = Get.find<AllPharmacyController>();

  @override
  void initState() {
    super.initState();
    //pharmacyController.getPharmacyProduct(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
          title: 'Products',
          leading: Image(
            image: AssetImage('Assets/icons/arrow-left.png'),
            color: ThemeUtil.isDarkMode(context) ? AppColors.whiteColor : null,
            // height: 6.w,
            // width: .w,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Color(0xffBABABA))),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: InkWell(
                    onTap: () {
                      widget.isAdmin
                          ? null
                          : Get.to(MyCartScreen(),
                              transition: Transition.native);
                    },
                    child: SvgPicture.asset(
                      'Assets/icons/cardreddot.svg',
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(AddMedicine(), transition: Transition.native);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 24),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Color(0xffBABABA))),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: SvgPicture.asset('Assets/icons/plus.svg'),
                    )),
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
                child: Obx(
              () => GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 3.0,
                    mainAxisSpacing: 3,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: pharmacyController.pharmacyProducts.length,
                  itemBuilder: (context, index) {
                    final data = pharmacyController.pharmacyProducts[index];
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: InkWell(
                              onTap: () {
                                Get.to(
                                    MedicineDetailScreen(
                                      product: data,
                                      isPharmacyAdmin: widget.isAdmin,
                                      productId: data.productId.toString(),
                                    ),
                                    transition: Transition.native);
                              },
                              child: MedicineCard(
                                categoryId: data.categoryId!.toInt(),
                                isUserProductScreen: true,
                                onPressed: () {
                                  widget.isAdmin
                                      ? Get.to(
                                          MedicineDetailScreen(
                                            product: data,
                                            isPharmacyAdmin: widget.isAdmin,
                                            productId:
                                                data.productId.toString(),
                                          ),
                                          transition: Transition.native)
                                      : print('');
                                },
                                btnText:
                                    widget.isAdmin ? "Edit" : "Add to Cart",
                                imgUrl: data.image.toString(),
                                count: data.quantity.toString(),
                                cost: data.price.toString(),
                                name: data.name.toString(),
                              ),
                            ),
                          )
                        ]);
                  }),
            ))
          ],
        ),
      ),
    );
  }
}

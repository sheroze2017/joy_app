import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/appbar/custom_appbar.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/bloc/all_pharmacy_bloc.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/modules/social_media/friend_request/view/new_friend.dart';
import 'package:sizer/sizer.dart';
import '../../user/user_hospital/view/hospital_detail_screen.dart';
import 'medicine_detail_screen.dart';
import 'checkout/mycart_screen.dart';

class PharmacyProductScreen extends StatefulWidget {
  final String userId;
  bool isHospital;
  PharmacyProductScreen({required this.userId, this.isHospital = false});

  @override
  State<PharmacyProductScreen> createState() => _PharmacyProductScreenState();
}

class _PharmacyProductScreenState extends State<PharmacyProductScreen> {
  final pharmacyController = Get.find<AllPharmacyController>();

  @override
  void initState() {
    super.initState();
    pharmacyController.getPharmacyProduct(true, widget.userId);
  }

  @override
  void dispose() {
    pharmacyController.searchPharmacyProducts.value =
        pharmacyController.pharmacyProducts.value;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
          title: 'Products',
          leading: Image(
            image: AssetImage(
              'Assets/icons/arrow-left.png',
            ),

            // height: 6.w,
            // width: .w,
          ),
          actions: [
            InkWell(
              onTap: () {
                Get.to(MyCartScreen(), transition: Transition.native);
              },
              child: Padding(
                padding: EdgeInsets.only(right: 16),
                child: Stack(
                  children: [
                    SvgPicture.asset('Assets/icons/cart.svg'),
                    Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          height: 1.5.h,
                          width: 1.5.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Color(0xffD65B5B)),
                          child: Center(
                              child: Obx(
                            () => Text(
                              pharmacyController.cartItems.length.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 6),
                            ),
                          )),
                        ))
                  ],
                ),
              ),
            )
          ],
          showIcon: true),
      body: RefreshIndicator(
        onRefresh: () async {
          pharmacyController.getPharmacyProduct(true, widget.userId);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              RoundedSearchTextField(
                hintText: 'Search',
                controller: TextEditingController(),
                onChanged: pharmacyController.searchByProduct,
              ),
              SizedBox(
                height: 2.h,
              ),
              Expanded(
                  child: Obx(
                () => pharmacyController.allProductLoader.value
                    ? Center(child: CircularProgressIndicator())
                    : pharmacyController.searchPharmacyProducts.length == 0
                        ? Center(
                            child: Text(
                              "No products found",
                              style: CustomTextStyles.lightTextStyle(),
                            ),
                          )
                        : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 3.0,
                              mainAxisSpacing: 3,
                              childAspectRatio:
                                  0.75, // Set the aspect ratio of the children
                            ),
                            itemCount: pharmacyController
                                .searchPharmacyProducts.length,
                            itemBuilder: (context, index) {
                              final data = pharmacyController
                                  .searchPharmacyProducts[index];
                              return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: InkWell(
                                        onTap: () {
                                          Get.to(
                                              MedicineDetailScreen(
                                                product: data,
                                                isPharmacyAdmin: false,
                                                productId:
                                                    data.productId.toString(),
                                              ),
                                              transition: Transition.native);
                                        },
                                        child: MedicineCard(
                                          categoryId: data.categoryId ?? 0,
                                          isUserProductScreen: true,
                                          onPressed: () {
                                            pharmacyController.addToCart(
                                                data, context);
                                          },
                                          btnText: "Add to Cart",
                                          imgUrl: data.image!.contains('http')
                                              ? data.image.toString()
                                              : 'https://i.guim.co.uk/img/media/20491572b80293361199ca2fc95e49dfd85e1f42/0_236_5157_3094/master/5157.jpg?width=1200&height=900&quality=85&auto=format&fit=crop&s=80ea7ebecd3f10fe721bd781e02184c3',
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
      ),
    );
  }
}

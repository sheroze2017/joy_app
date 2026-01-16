import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/bloc/all_pharmacy_bloc.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/models/pharmacy_product_model.dart';
import 'package:joy_app/common/map/bloc/location_controller.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/Widgets/appbar/custom_appbar.dart';
import 'package:joy_app/Widgets/button/rounded_button.dart';
import 'package:joy_app/Widgets/textfield/custom_textfield.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/widgets/loader/loader.dart';
import 'package:sizer/sizer.dart';

class MyCartScreen extends StatefulWidget {
  const MyCartScreen({super.key});

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

final pharmacyController = Get.find<AllPharmacyController>();

class _MyCartScreenState extends State<MyCartScreen> {
  final locationController = Get.find<LocationController>();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final currentLocation = locationController.location.value;
    if (currentLocation.isNotEmpty && currentLocation != 'Select Location') {
      _locationController.text = currentLocation;
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  // Calculate total quantity from all cart items
  int _calculateTotalQuantity() {
    return pharmacyController.cartItems.fold(
      0,
      (sum, item) => sum + (item.cartQuantity ?? 0),
    );
  }

  Future<void> _placeOrder() async {
    if (pharmacyController.cartItems.isEmpty) {
      Get.snackbar('Error', 'Cart is empty');
      return;
    }
    final enteredLocation = _locationController.text.trim();
    if (enteredLocation.isEmpty) {
      Get.snackbar('Error', 'Please enter delivery location');
      return;
    }

    // Get location data
    final lat = locationController.latitude.value;
    final lng = locationController.longitude.value;
    
    // Calculate totals
    final grandTotal = pharmacyController.calculateGrandTotal() + 100; // Including delivery charges
    final totalQuantity = _calculateTotalQuantity();
    final pharmacyId = pharmacyController.cartItems[0].pharmacyId?.toString() ?? '';
    
    // Use default values if location is not available
    final finalLat = lat != 0.0 ? lat : 24.8607; // Default Karachi coordinates
    final finalLng = lng != 0.0 ? lng : 67.0011;
    final finalLocation = enteredLocation;
    final placeId = 'place-123'; // Default place ID

    // Call place order API
    await pharmacyController.placeOrderPharmacy(
      context,
      grandTotal.toString(),
      'PENDING',
      totalQuantity.toString(),
      finalLocation,
      finalLat.toString(),
      finalLng.toString(),
      placeId,
      pharmacyController.cartItemsToJson(),
      pharmacyId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
          title: 'My Cart',
          leading: Image(
            image: AssetImage('Assets/icons/arrow-left.png'),
            // height: 6.w,
            // width: .w,
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Stack(
                children: [
                  SvgPicture.asset(
                    'Assets/icons/cart.svg',
                    color: ThemeUtil.isDarkMode(context)
                        ? AppColors.lightGreenColoreb1
                        : null,
                  ),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        height: 1.1.h,
                        width: 1.1.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Color(0xffD65B5B)),
                        child: Center(
                            child: Obx(
                          () => Text(
                            pharmacyController.cartItems.length.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 6),
                          ),
                        )),
                      ))
                ],
              ),
            )
          ],
          showIcon: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
          child: Column(
            children: [
              Divider(
                color: Color(0xffE5E7EB),
                thickness: 0.5,
              ),
              SizedBox(height: 2.h),
              Obx(() => ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: pharmacyController.cartItems.length,
                  itemBuilder: ((context, index) {
                    PharmacyProductData data =
                        pharmacyController.cartItems[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.lightGreenColor,
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: _buildProductImage(data.image ?? ''),
                                  ),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.name.toString(),
                                          style: CustomTextStyles
                                              .darkHeadingTextStyle(),
                                        ),
                                        Text(
                                          '${data.quantity} Tablets for ${data.price}\Rs',
                                          style: CustomTextStyles.w600TextStyle(
                                              size: 14,
                                              color: Color(0xff4B5563)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Divider(
                                color: AppColors.lightGreyColor,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: RoundedButtonSmall(
                                        isBold: true,
                                        isSmall: true,
                                        text:
                                            "Total ${double.parse(data.price.toString()) * data.cartQuantity!.toInt()}Rs",
                                        onPressed: () {},
                                        backgroundColor:
                                            ThemeUtil.isDarkMode(context)
                                                ? Color(0xff1F2228)
                                                : AppColors.lightGreyColor,
                                        textColor: ThemeUtil.isDarkMode(context)
                                            ? AppColors.lightGreenColoreb1
                                            : AppColors.darkGreenColor),
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 8.0, left: 16),
                                        child: InkWell(
                                          onTap: () {
                                            pharmacyController
                                                .removeFromCart(data);
                                            setState(() {});
                                          },
                                          child: Container(
                                            width: 7.6.w,
                                            height: 7.6.w,
                                            decoration: BoxDecoration(
                                                color: ThemeUtil.isDarkMode(
                                                        context)
                                                    ? Color(0xff1F2228)
                                                    : AppColors.whiteColor,
                                                border: Border.all(
                                                    color: Color(0xffBABABA)),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Center(
                                                child: SvgPicture.asset(
                                                    color: ThemeUtil.isDarkMode(
                                                            context)
                                                        ? AppColors.whiteColor
                                                        : null,
                                                    'Assets/icons/minus.svg')),
                                          ),
                                        ),
                                      ),
                                      Text(data.cartQuantity.toString(),
                                          style:
                                              CustomTextStyles.lightTextStyle(
                                                  size: 16,
                                                  color: Color(0xff000000))),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 16),
                                        child: InkWell(
                                          onTap: () {
                                            pharmacyController.addToCart(
                                                data, context);
                                            setState(() {});
                                          },
                                          child: Container(
                                            width: 7.6.w,
                                            height: 7.6.w,
                                            decoration: BoxDecoration(
                                                color: ThemeUtil.isDarkMode(
                                                        context)
                                                    ? Color(0xff1F2228)
                                                    : AppColors.whiteColor,
                                                border: Border.all(
                                                    color: Color(0xffBABABA)),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child:
                                                Center(child: Icon(Icons.add)),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          pharmacyController
                                              .removeproductCart(data);
                                        },
                                        child: SvgPicture.asset(
                                            'Assets/icons/trash-2.svg'),
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }))),
              Obx(() => ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: pharmacyController.cartItems.length,
                  itemBuilder: ((context, index) {
                    PharmacyProductData data =
                        pharmacyController.cartItems[index];
                    return NameCharges(
                      medName: data.name.toString(),
                      charges: (double.parse(data.price.toString()) *
                              double.parse(data.cartQuantity.toString()))
                          .toString(),
                    );
                  }))),
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Column(
                  children: [
                    NameCharges(
                      medName: 'Delivery Charges',
                      charges: '100\Rs',
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Delivery Location',
                        style: CustomTextStyles.w600TextStyle(
                            size: 14, color: AppColors.blackColor151),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    RoundedBorderTextField(
                      controller: _locationController,
                      hintText: 'Enter delivery location',
                      icon: '',
                      showLabel: false,
                    ),
                    SizedBox(height: 2.h),
                    Obx(
                      () => NameCharges(
                        medName: 'Grand Total',
                        charges:
                            (pharmacyController.calculateGrandTotal() + 100)
                                    .toString() +
                                '\Rs',
                        isTotal: true,
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => pharmacyController.cartItems.isEmpty
                                ? RoundedButtonSmall(
                                    isBold: true,
                                    isSmall: true,
                                    text: 'Place Order',
                                    onPressed: () {
                                      Get.snackbar('Error', 'Cart is empty');
                                    },
                                    backgroundColor: Colors.grey,
                                    textColor: Colors.white,
                                  )
                                : RoundedButtonSmall(
                                    isBold: true,
                                    isSmall: true,
                                    text: 'Place Order',
                                    onPressed: () {
                                      _placeOrder();
                                    },
                                    backgroundColor: ThemeUtil.isDarkMode(context)
                                        ? AppColors.lightGreenColoreb1
                                        : AppColors.darkGreenColor,
                                    textColor: ThemeUtil.isDarkMode(context)
                                        ? Color(0xff1F2228)
                                        : Color(0xffFFFFFF),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              )
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build product image with proper error handling
  Widget _buildProductImage(String imageUrl) {
    // Check if image URL is valid
    final isValidUrl = imageUrl.isNotEmpty &&
        imageUrl.contains('http') &&
        !imageUrl.contains('example.com') &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));

    if (!isValidUrl) {
      // Show default medicine icon
      return Container(
        width: 27.w,
        height: 27.w,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Icon(
          Icons.medical_services_outlined,
          size: 8.w,
          color: Colors.grey[600],
        ),
      );
    }

    // Use CachedNetworkImage for valid URLs
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: 27.w,
      height: 27.w,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        width: 27.w,
        height: 27.w,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Center(
          child: LoadingWidget(),
        ),
      ),
      errorWidget: (context, url, error) {
        // Always show default medicine icon on error
        return Container(
          width: 27.w,
          height: 27.w,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Icon(
            Icons.medical_services_outlined,
            size: 8.w,
            color: Colors.grey[600],
          ),
        );
      },
    );
  }
}

class NameCharges extends StatelessWidget {
  final String medName;
  final String charges;
  bool isTotal;

  NameCharges(
      {super.key,
      required this.medName,
      required this.charges,
      this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              medName,
              style: isTotal
                  ? CustomTextStyles.darkHeadingTextStyle(
                      size: 18, color: AppColors.lightBlack393)
                  : CustomTextStyles.lightSmallTextStyle(
                      size: 18, color: AppColors.lightBlack393),
            ),
            Spacer(),
            Text(
              charges,
              style: isTotal
                  ? CustomTextStyles.darkHeadingTextStyle(
                      size: 18, color: AppColors.lightBlack393)
                  : CustomTextStyles.lightSmallTextStyle(
                      size: 18, color: AppColors.lightBlack393),
            ),
          ],
        ),
        !isTotal
            ? Divider(
                color: Color(0xffE5E7EB),
                thickness: ThemeUtil.isDarkMode(context) ? 0.2 : 1,
              )
            : Container()
      ],
    );
  }
}

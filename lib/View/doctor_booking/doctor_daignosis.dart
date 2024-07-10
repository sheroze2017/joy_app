import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:joy_app/modules/user/user_doctor/model/all_user_appointment.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:pinput/pinput.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/Widgets/custom_textfield.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

class DoctorDaginosis extends StatefulWidget {
  String? patName;
  String? daignosis;
  String? prescription;
  UserAppointment details;
  DoctorDaginosis(
      {super.key,
      required this.patName,
      required this.daignosis,
      required this.prescription,
      required this.details});

  @override
  State<DoctorDaginosis> createState() => _ManageAppointmentState();
}

class _ManageAppointmentState extends State<DoctorDaginosis> {
  bool showPatientHistory = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _daignosisController = TextEditingController();
  final TextEditingController _prescriptionController = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _nameController.setText(widget.patName.toString());
    _daignosisController.setText(widget.daignosis.toString());
    _prescriptionController.setText(widget.prescription.toString());
    return WillPopScope(
        onWillPop: () async {
          showPatientHistory = !showPatientHistory;
          setState(() {});
          return true;
        },
        child: Scaffold(
          appBar: HomeAppBar(
              title: "Doctor's Reviews",
              leading: Container(),
              actions: [],
              showIcon: false),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 2.h,
                    ),
                    Text(
                      "Patient's Name",
                      style: CustomTextStyles.lightTextStyle(
                          color: ThemeUtil.isDarkMode(context)
                              ? Color(0xffDBDBDB)
                              : Color(0xff3D4859)),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    RoundedBorderTextField(
                        isenable: false,
                        controller: _nameController,
                        focusNode: _focusNode1,
                        nextFocusNode: _focusNode2,
                        hintText: 'James Robinson',
                        icon: ''),
                    SizedBox(
                      height: 2.h,
                    ),
                    Text(
                      "Your Daignosis",
                      style: CustomTextStyles.lightTextStyle(
                          color: ThemeUtil.isDarkMode(context)
                              ? Color(0xffDBDBDB)
                              : Color(0xff3D4859)),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    RoundedBorderTextField(
                        isenable: false,
                        focusNode: _focusNode2,
                        nextFocusNode: _focusNode3,
                        maxlines: true,
                        controller: _daignosisController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter daignosis';
                          } else {
                            return null;
                          }
                        },
                        hintText: 'Daignoses ',
                        icon: ''),
                    SizedBox(
                      height: 2.h,
                    ),
                    Text(
                      "Medications Prescribed",
                      style: CustomTextStyles.lightTextStyle(
                          color: ThemeUtil.isDarkMode(context)
                              ? Color(0xffDBDBDB)
                              : Color(0xff3D4859)),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    RoundedBorderTextField(
                      isenable: false,
                      focusNode: _focusNode3,
                      nextFocusNode: _focusNode4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Prescription';
                        } else {
                          return null;
                        }
                      },
                      maxlines: true,
                      hintText: 'Medication Prescription',
                      controller: _prescriptionController,
                      icon: '',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [],
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RoundedButtonSmall(
                              isSmall: true,
                              isBold: true,
                              text: 'Download',
                              onPressed: () {
                                downloadPDF(widget.details);
                              },
                              textColor: ThemeUtil.isDarkMode(context)
                                  ? Color(0xff00143D)
                                  : AppColors.lightGreyColor,
                              backgroundColor: ThemeUtil.isDarkMode(context)
                                  ? AppColors.whiteColor
                                  : Color(0xff033890)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void downloadPDF(UserAppointment details) async {
    await Permission.storage.request();
    print(await Permission.storage.isGranted);
    final PdfDocument document = PdfDocument();

    // Add a page
    final PdfPage page = document.pages.add();

    // Create a grid
    final PdfGrid grid = PdfGrid();

    // Add columns to the grid
    grid.columns.add(count: 3);

    // Add a header row to the grid
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.cells[0].value = 'Customer ID';
    headerRow.cells[1].value = 'Contact Name';
    headerRow.cells[2].value = 'Location';

    // Set header row font
    headerRow.style.font =
        PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);

    // Add data rows to the grid
    PdfGridRow row = grid.rows.add();
    row.cells[0].value = details.patientUserId.toString();
    row.cells[1].value = details.patientName;
    row.cells[2].value = details.location;

    // Draw the grid on the page
    grid.style.cellPadding = PdfPaddings(left: 5, top: 5);
    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(
        0,
        0,
        page.getClientSize().width,
        page.getClientSize().height,
      ),
    );

    // Save the document as bytes
    final List<int> bytes = await document.save();

    // Dispose the document
    document.dispose();

    // Get the directory for saving the file
    final Directory? directory = await getDownloadsDirectory();
    final String path = directory!.path;

    // Create the file and write the bytes
    final File file = File('$path/PDFTable.pdf');
    await file.writeAsBytes(bytes);
// Add a PDF page and draw text.

    // Show a message or handle further actions (e.g., open the file)
    print('PDF saved to: $path/PDFTable.pdf');
  }

  _makingPhoneCall(String phoneNo) async {
    var url = Uri.parse("tel:${phoneNo}");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  openwhatsapp(whatsapp) async {
    var androidUrl =
        "whatsapp://send?phone=$whatsapp&text='Hi, hope you are doing well \nLet we start the meeting to discuss your health issues.'";
    var iosUrl =
        "https://wa.me/$whatsapp?text=${Uri.parse('Hi, hope you are doing well \nLet we start the meeting to discuss your health issues.')}";

    // android , web
    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {}
    // }
  }
}

class TimerWidget extends StatefulWidget {
  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Duration _remainingTime = Duration(minutes: 30, seconds: 0);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: _remainingTime,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds > 0) {
        setState(() {
          _remainingTime -= Duration(seconds: 1);
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = _formatDuration(_remainingTime);

    return Center(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 40.w,
              width: 40.w,
              child: CircularProgressIndicator(
                value: _animation.value,
                strokeWidth: 10,
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.darkBlueColor),
                backgroundColor: Colors.white,
              ),
            ),
            Text(
              formattedTime,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w500,
                color: ThemeUtil.isDarkMode(context)
                    ? AppColors.whiteColor
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

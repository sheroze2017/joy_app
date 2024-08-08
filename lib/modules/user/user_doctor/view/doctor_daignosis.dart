import 'dart:async';
import 'dart:io';
import 'package:joy_app/modules/user/user_doctor/model/all_user_appointment.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart' as open_file;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

//Local imports

import 'package:pinput/pinput.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/Widgets/appbar/custom_appbar.dart';
import 'package:joy_app/Widgets/textfield/custom_textfield.dart';
import 'package:joy_app/Widgets/button/rounded_button.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

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
                                generateInvoice(widget.details);
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

  Future<void> generateInvoice(UserAppointment details) async {
    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
        pen: PdfPen(PdfColor(142, 170, 219)));
    final PdfGrid grid = getGrid();
    final PdfLayoutResult result =
        drawHeader(page, pageSize, grid, widget.details);
    drawFooter(page, pageSize);
    final List<int> bytes = document.saveSync();
    document.dispose();
    await saveAndLaunchFile(bytes, 'Invoice.pdf');
  }

  PdfLayoutResult drawHeader(
      PdfPage page, Size pageSize, PdfGrid grid, UserAppointment details) {
    page.graphics.drawRectangle(
        brush: PdfSolidBrush(PdfColor(91, 126, 215)),
        bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 90));
    page.graphics.drawString(
        'JOY', PdfStandardFont(PdfFontFamily.helvetica, 30),
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(25, 0, pageSize.width, 90),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);
    final DateFormat format = DateFormat.yMMMMd('en_US');
    final String invoiceNumber =
        'Appointment Number: ${details.appointmentId}\r\n\r\nDoctor Name: ${details.doctorDetails!.doctorName.toString()}\r\n\r\nDoctor Email: ${details.doctorDetails!.doctorEmail.toString()}\r\n\r\nDoctor Phone: ${details.doctorDetails!.doctorPhone.toString()}\r\n\r\nDate: ${details.date} ${details.time.toString()}';
    final Size contentSize = contentFont.measureString(invoiceNumber);
    String address =
        '''Patient Name: \r\n\r\n${details.patientName.toString()}, 
        \r\n\r\nLocation: ${details.location.toString()}, 
        \r\n\r\nDaignosis: ${details.diagnosis}, \r\n\r\nMedication Prescribed: ${details.medications} ''';

    PdfTextElement(text: invoiceNumber, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120,
            contentSize.width + 30, pageSize.height - 120));

    return PdfTextElement(text: address, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(30, 120,
            pageSize.width - (contentSize.width + 30), pageSize.height - 120))!;
  }

  void drawFooter(PdfPage page, Size pageSize) {
    final PdfPen linePen =
        PdfPen(PdfColor(142, 170, 219), dashStyle: PdfDashStyle.custom);
    linePen.dashPattern = <double>[3, 3];
    page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100),
        Offset(pageSize.width, pageSize.height - 100));

    const String footerContent = '''Any Questions? support@joy-app.com''';

    page.graphics.drawString(
        footerContent, PdfStandardFont(PdfFontFamily.helvetica, 9),
        format: PdfStringFormat(alignment: PdfTextAlignment.right),
        bounds: Rect.fromLTWH(pageSize.width - 30, pageSize.height - 70, 0, 0));
  }

  PdfGrid getGrid() {
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 5);
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    return grid;
  }

  void addProducts(String productId, String productName, double price,
      int quantity, double total, PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = productId;
    row.cells[1].value = productName;
    row.cells[2].value = price.toString();
    row.cells[3].value = quantity.toString();
    row.cells[4].value = total.toString();
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

Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  String? path;
  if (Platform.isAndroid ||
      Platform.isIOS ||
      Platform.isLinux ||
      Platform.isWindows) {
    final Directory directory =
        await path_provider.getApplicationSupportDirectory();
    path = directory.path;
  } else {
    path = await PathProviderPlatform.instance.getApplicationSupportPath();
  }
  final File file =
      File(Platform.isWindows ? '$path\\$fileName' : '$path/$fileName');
  await file.writeAsBytes(bytes, flush: true);
  if (Platform.isAndroid || Platform.isIOS) {
    //Launch the file (used open_file package)
    await open_file.OpenFile.open('$path/$fileName');
  } else if (Platform.isWindows) {
    await Process.run('start', <String>['$path\\$fileName'], runInShell: true);
  } else if (Platform.isMacOS) {
    await Process.run('open', <String>['$path/$fileName'], runInShell: true);
  } else if (Platform.isLinux) {
    await Process.run('xdg-open', <String>['$path/$fileName'],
        runInShell: true);
  }
}

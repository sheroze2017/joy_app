import 'package:flutter/material.dart';
import 'package:joy_app/Widgets/chat_appbar.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

class DirectMessageScreen extends StatelessWidget {
  const DirectMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(username: 'Awais Arshad', status: 'Offline'),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              MyMessage(
                message: 'Hi hope you are doing well',
              ),
              YourMessage(
                message: 'Im fine how about you will come tomorrow for meeting',
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyMessage extends StatelessWidget {
  final String message;

  const MyMessage({super.key, required this.message});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: Image.network(
            'https://via.placeholder.com/50',
            width: 5.h,
            height: 5.h,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          width: 2.w,
        ),
        Container(
          width: 56.4.w,
          decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.06),
              borderRadius: BorderRadius.circular(24)),
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Your Message dsf dsf sdf sdfsd fsdf sdf',
                  style: CustomTextStyles.lightTextStyle(
                      color: Colors.black, size: 16))),
        )
      ],
    );
  }
}

class YourMessage extends StatelessWidget {
  final String message;

  const YourMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Spacer(),
        Container(
          width: 56.4.w,
          decoration: BoxDecoration(
              color: Color(0xff1C2A3A),
              borderRadius: BorderRadius.circular(24)),
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(message,
                  style: CustomTextStyles.lightTextStyle(
                      color: Colors.white, size: 16))),
        ),
        SizedBox(
          width: 2.w,
        ),
        Image(image: AssetImage('Assets/icons/read.png'))
      ],
    );
  }
}

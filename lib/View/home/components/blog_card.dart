import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/view/home/my_profile.dart';
import 'package:sizer/sizer.dart';

class MyCustomWidget extends StatefulWidget {
  bool? isReply;
  bool? showImg;
  String postName;
  String text;
  String imgPath;
  String recentName;
  String likeCount;
  bool isLiked;

  MyCustomWidget(
      {this.isReply = false,
      this.showImg = true,
      this.text = '',
      this.imgPath = '',
      this.likeCount = '',
      this.recentName = '',
      this.isLiked = false,
      this.postName = ''});

  @override
  State<MyCustomWidget> createState() => _MyCustomWidgetState();
}

class _MyCustomWidgetState extends State<MyCustomWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwyF78CgXqp5uX0g-SvGy4uLB2Qlg8Up3fhYYVlx9Vag&s'),
            ),
            SizedBox(width: 2.w), // Adjust as needed
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.postName.toString(),
                  style: CustomTextStyles.w600TextStyle(
                      letterspacing: 0.5,
                      size: 13.21,
                      color: Color(0xff19295C)),
                ),
                Row(
                  children: [
                    SvgPicture.asset('Assets/icons/world.svg'),
                    SizedBox(
                      width: 1.w,
                    ),
                    Text(
                      '2 Hours ago',
                      style: CustomTextStyles.lightTextStyle(size: 8.25),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
        SizedBox(height: 1.h),
        Text(
          widget.text.toString(),
          style: CustomTextStyles.lightTextStyle(
              color: Color(0xff2D3F7B), size: 11.56),
        ),
        SizedBox(height: 1.h),
        widget.showImg == true
            ? Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage('Assets/images/hospital.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : Container(),
        SizedBox(height: 2.h), // Adjust as needed
        Row(
          children: [
            InkWell(
              onTap: () {
                widget.isLiked = !widget.isLiked;
                setState(() {});
              },
              child: CircleButton(
                isActive: widget.isLiked,
                img: 'Assets/images/like.png',
                color: widget.isLiked ? Color(0XFF1C2A3A) : Color(0xFFF9FAFB),
              ),
            ),
            SizedBox(width: 10), // Adjust as needed
            CircleButton(
              img: 'Assets/images/message.png',
              color: Color(0xFFF9FAFB),
            ),
            SizedBox(width: 10), // Adjust as needed
            CircleButton(
              img: 'Assets/images/send.png',
              color: Color(0xFFF9FAFB),
            ),
            Spacer(),
            LikeCount(
              like: '32.1K',
              name: 'Ali',
            ),

            Divider(
              color: Color(0xffE5E7EB),
            ),
          ],
        ),
        SizedBox(
          height: 1.5.h,
        ),
        widget.isReply == true
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 13,
                    backgroundImage: NetworkImage(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwyF78CgXqp5uX0g-SvGy4uLB2Qlg8Up3fhYYVlx9Vag&s'),
                  ),
                  SizedBox(width: 2.w), // Adjust as needed

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mark Ramos',
                        style: CustomTextStyles.w600TextStyle(
                            letterspacing: 0.5,
                            size: 13.21,
                            color: Color(0xff19295C)),
                      ),
                      Row(
                        children: [
                          Text(
                            'Greet work! Well done girl. 👏🏽',
                            style: CustomTextStyles.lightTextStyle(size: 11.28),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Row(
                        children: [
                          Text('Like',
                              style: CustomTextStyles.darkHeadingTextStyle(
                                  size: 10, color: Color(0xff60709D))),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Text('Reply',
                                style: CustomTextStyles.darkHeadingTextStyle(
                                    size: 10, color: Color(0xff60709D))),
                          ),
                          Text('2m',
                              style: CustomTextStyles.lightTextStyle(
                                  size: 10, color: Color(0xff60709D)))
                        ],
                      ),
                    ],
                  )
                ],
              )
            : Container(),
        SizedBox(height: 1.h), // Adjust as needed
      ],
    );
  }
}

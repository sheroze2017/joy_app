import 'package:flutter/material.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';

class MultiTimeSelector extends StatefulWidget {
  final List<String> times;
  final void Function(List<String>) onConfirm;

  const MultiTimeSelector(
      {Key? key, required this.times, required this.onConfirm})
      : super(key: key);

  @override
  _MultiTimeSelectorState createState() => _MultiTimeSelectorState();
}

class _MultiTimeSelectorState extends State<MultiTimeSelector> {
  List<String> selectedTimes = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        'Select Hour',
        style: CustomTextStyles.w600TextStyle(color: Color(0xff1C2A3A)),
      ),
      content: Wrap(
        alignment: WrapAlignment.center,
        spacing: 10.0,
        runSpacing: 10.0,
        children: widget.times.map((time) {
          final isSelected = selectedTimes.contains(time);
          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  selectedTimes.remove(time);
                } else {
                  selectedTimes.add(time);
                }
              });
            },
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xff1C2A3A) : Color(0xffF9FAFB),
                borderRadius: BorderRadius.circular(6.17),
              ),
              child: Text(
                time,
                style: CustomTextStyles.w600TextStyle(
                  size: 10.7,
                  color: isSelected ? Colors.white : Color(0xff6B7280),
                ),
              ),
            ),
          );
        }).toList(),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: RoundedButton(
                  text: "Confirm",
                  onPressed: () {
                    // Pass selected times to the callback function
                    widget.onConfirm(selectedTimes);
                    Navigator.pop(context);
                  },
                  backgroundColor: Color(0xff1C2A3A),
                  textColor: AppColors.whiteColor),
            ),
          ],
        ),
      ],
    );
  }
}

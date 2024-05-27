import 'package:flutter/material.dart';

class CustomTimeDialog extends StatefulWidget {
  final List<String> availableTimes;
  final List<String> selectedTimes;
  final Function(List<String>) onSelected;

  CustomTimeDialog(
      {required this.availableTimes,
      required this.selectedTimes,
      required this.onSelected});

  @override
  _CustomTimeDialogState createState() => _CustomTimeDialogState();
}

class _CustomTimeDialogState extends State<CustomTimeDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          Text(
            "Select Hours",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: widget.availableTimes.length,
            itemBuilder: (BuildContext context, int index) {
              final time = widget.availableTimes[index];
              final isSelected = widget.selectedTimes.contains(time);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      widget.selectedTimes.remove(time);
                    } else {
                      widget.selectedTimes.add(time);
                    }
                    widget.onSelected(widget.selectedTimes);
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    time,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

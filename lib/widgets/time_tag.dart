import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../controllers/cab_sharing_controller.dart';
import 'package:get/get.dart';


class TimeTag extends StatefulWidget {
  const TimeTag({
    super.key,
  });

  @override
  State<TimeTag> createState() => _TimeTagState();
}

class _TimeTagState extends State<TimeTag> {
  String time = 'Time';

  /// GetX Controllers
  final CabSharingController cabSharingController = Get.put(CabSharingController());

  @override
  Widget build(BuildContext context) {
    return InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onTap: () {
          showCupertinoModalPopup(
            context: context,
            builder: (_) => Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white
              ),
              height: 300,
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                    ),
                    height: 200,
                    child: CupertinoDatePicker(
                      initialDateTime: DateTime.now(),
                      onDateTimeChanged: (DateTime newDateTime) {
                        print(newDateTime);
                        setState(() {
                          String formattedDateTime = DateFormat('dd MMM HH:mm').format(newDateTime);
                          time = formattedDateTime;
                          cabSharingController.dateTime.value = formattedDateTime;
                        });
                      },
                      mode: CupertinoDatePickerMode.dateAndTime,
                    ),
                  ),

                  // Close the modal
                  CupertinoButton(
                    child: const Text('Done'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
            ),
          );
        },
        child:
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.black.withOpacity(0.1),
            // color: Color.fromRGBO(255, 114, 33, 0.3),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 5,
                ),
                const Icon(
                  Icons.time_to_leave,
                  color: Color.fromRGBO(0, 0, 0, 0.7),
                  size: 15,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  time,
                  style: const TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 0.7), fontSize: 12),
                ),
                const SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        )
    );

  }
}

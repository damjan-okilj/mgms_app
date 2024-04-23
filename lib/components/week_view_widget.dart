import 'package:MGMS/tasks/calendar_detail.dart';
import 'package:MGMS/tasks/task_detail.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeekViewWidget extends StatelessWidget {
  final GlobalKey<WeekViewState>? state;
  final double? width;
  final EventController controller;

  const WeekViewWidget({super.key, this.state, this.width, required this.controller});

  @override
  Widget build(BuildContext context) {
    return MonthView(
      onEventTap: (event, date) => {
        Navigator.push(context, CupertinoPageRoute(builder: (context) => CalendarDetail(task: event.event,)))
      },
      controller: controller,
      key: state,
      width: width,
    );
  }
}
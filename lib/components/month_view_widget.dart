import 'package:MGMS/api/api.dart';
import 'package:MGMS/tasks/calendar_detail.dart';
import 'package:MGMS/tasks/calendar_new_task.dart';
import 'package:MGMS/tasks/task_detail.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MonthViewWidget extends StatelessWidget {
  final GlobalKey<WeekViewState>? state;
  final double? width;
  final EventController controller;

  const MonthViewWidget({super.key, this.state, this.width, required this.controller});

  @override
  Widget build(BuildContext context) {
    List<User> users = [];
    fetchUsers().then((value) {
      users.addAll(value);
    });
    return MonthView(
      onEventTap: (event, date) => {
        Navigator.push(context, CupertinoPageRoute(builder: (context) => CalendarDetail(task: event.event,)))
      },
      onCellTap: (events, date) => {
        Navigator.push(context, CupertinoPageRoute(builder: (context) => CalendarNewTask(date: date, users: users,)))
      },
      controller: controller,
      useAvailableVerticalSpace: true,
      key: state,
      cellAspectRatio: 1,
      width: MediaQuery.of(context).size.width,
    );
  }
}
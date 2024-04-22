import 'dart:html';

import 'package:MGMS/components/common_card.dart';
import 'package:MGMS/views/home/web_view.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:MGMS/api/api.dart';
import 'package:MGMS/constants/color_constants.dart';
import 'package:MGMS/helpers/ui_helper.dart';
import 'package:MGMS/tasks/task_detail.dart';
import 'package:MGMS/widgets/custom_scaffold.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Task> allTasks = [];
  List<User> users = [];
  EventController calendar_controller = EventController();

  @override
  void initState() {
    fetchTasks().then((value) => setState(() {
          allTasks.addAll(value);
        }));
    fetchUsers().then((value) => setState(() {
          users = value;
        }));
    buildCalendarEvents();    // TODO: implement initState
    super.initState();
  }

  void buildCalendarEvents() {
    for (var task in allTasks) {
      calendar_controller.add((CalendarEventData(
          title: task.name, date: DateTime.parse(task.due_time))));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) =>
                        WebHomePage(controller: calendar_controller)));
          },
          child: const Icon(CupertinoIcons.calendar),
        ),
        body: CustomScaffold(
            onRefresh: () async {
              await Future<void>.delayed(const Duration(milliseconds: 1000));
              var task = await fetchTasks();
              setState(() {
                allTasks = task;
              });
            },
            title: "Tasks",
            children: allTasks
                .map((e) => CommonCard(
                      task: e,
                      users: users,
                    ))
                .toList()));
  }
}

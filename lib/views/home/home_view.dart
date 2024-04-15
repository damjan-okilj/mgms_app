import 'package:MGMS/components/common_card.dart';
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

  @override
  void initState() {
    fetchTasks().then((value) => setState(() {
          allTasks.addAll(value);
        }));
    fetchUsers().then((value) => setState(() {
          users = value;
        }));
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      onRefresh: () async {
        await Future<void>.delayed(const Duration(milliseconds: 1000));
        var task = await fetchTasks();
        setState(() {
          if (allTasks.length != task.length) {
            allTasks = task;
          }
        });
      },
      title: "Tasks",
      children: allTasks
          .map((e) => CommonCard(task: e, users: users,)
        ).toList()
    );
  }
}

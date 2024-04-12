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
          .map(
            (e) => Container(
              child: Card(
                child: Column(
                  children: [
                    CupertinoListTile(
                      leading: Icon(Icons.task, color: Colors.black),
                      title:
                          Text(e.name, style: TextStyle(color: Colors.black)),
                      subtitle: Text(
                        'Status: ${e.type}',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => TaskDetail(task: e, users: users,)));
                      },
                    ),
                  ],
                ),
              ),
              margin: const EdgeInsets.only(bottom: 10),
              width: UIHelper.deviceWidth,
              height: 100,
              decoration: BoxDecoration(
                color: ColorConstants.lightBackgroundColorActivated,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
            ),
          )
          .toList(),
    );
  }
}

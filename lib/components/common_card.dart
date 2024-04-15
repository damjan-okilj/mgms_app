import 'dart:math';

import 'package:MGMS/api/api.dart';
import 'package:MGMS/services/theme_service.dart';
import 'package:MGMS/tasks/task_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonCard extends StatefulWidget {
  final Color? color;
  final double radius;
  final Widget? child;
  final Task task;
  final List<User> users;

  const CommonCard({Key? key, this.color, this.radius = 16, this.child, required this.task, required this.users})
      : super(key: key);
  @override
  _CommonCardState createState() => _CommonCardState();
}

class _CommonCardState extends State<CommonCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
    child: Material(
    borderRadius: BorderRadius.circular(20),
    child: InkWell(
      onTap: () {
        Navigator.push(context, CupertinoPageRoute(builder: (context) => TaskDetail(task: widget.task, users: widget.users,)));
      },
    child: Container(
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.task.name
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.black,
                    size: 16,
                  ),
                ],
              ),
            ),
            Text(
              widget.task.description
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.task.type
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 4, 0),
                        child: Icon(
                          CupertinoIcons.calendar
                        ),
                      ),
                      Text(
                        widget.task.due_time,
                        textAlign: TextAlign.end,
                      ),
                    ]
                      ),
                    ],
              )
                  ),
                ],
              ),
            ),
    ))
    ));
  }
}
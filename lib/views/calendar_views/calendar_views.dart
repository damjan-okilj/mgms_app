import 'dart:math';

import 'package:MGMS/components/month_view_widget.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

class CalendarViews extends StatelessWidget {

  const CalendarViews({super.key, required this.controller});
  final EventController controller;

  final _breakPoint = 490.0;

  @override
  Widget build(BuildContext context) {
    final availableWidth = MediaQuery.of(context).size.width;
    final width = min(_breakPoint, availableWidth);
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.grey,
      child: Center(
        child: MonthViewWidget(
          controller: controller,
          width: width,
        ),
      ),
    );
  }
}

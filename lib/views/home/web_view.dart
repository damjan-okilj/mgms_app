import 'package:MGMS/views/calendar_views/calendar_views.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../../enumerations.dart';

class WebHomePage extends StatefulWidget {
  WebHomePage(
      {this.selectedView = CalendarView.week, required this.controller});
  final EventController controller;

  final CalendarView selectedView;

  @override
  _WebHomePageState createState() => _WebHomePageState();
}

class _WebHomePageState extends State<WebHomePage> {
  late var _selectedView = widget.selectedView;

  void _setView(CalendarView view) {
    if (view != _selectedView && mounted) {
      setState(() {
        _selectedView = view;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: CalendarViews(
              controller: widget.controller,
              key: ValueKey(MediaQuery.of(context).size.width),
            ),
          ),
        ],
      ),
    );
  }
}

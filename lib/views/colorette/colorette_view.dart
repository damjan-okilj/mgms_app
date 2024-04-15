import 'package:MGMS/components/common_card.dart';
import 'package:MGMS/views/colorette/colorette_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:MGMS/api/api.dart';
import 'package:MGMS/constants/color_constants.dart';
import 'package:MGMS/helpers/ui_helper.dart';
import 'package:MGMS/tasks/task_detail.dart';
import 'package:MGMS/widgets/custom_scaffold.dart';

class ColoretteView extends StatefulWidget {
  const ColoretteView({super.key});

  @override
  State<ColoretteView> createState() => _ColoretteViewState();
}

class _ColoretteViewState extends State<ColoretteView> {
  List<Measure> measures = [];

  @override
  void initState() {
    fetchMeasures().then((value) => setState(() {
          measures.addAll(value);
        }));
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      onRefresh: () async {
        await Future<void>.delayed(const Duration(milliseconds: 1000));
        var measure = await fetchMeasures();
        setState(() {
          if (measures.length != measure.length) {
            measures = measure;
          }
        });
      },
      title: "Tasks",
      children: measures
          .map((e) => GestureDetector(onTap: () {
            Navigator.push(context, CupertinoPageRoute(builder: (context) => ColoretteDetails(measures:e.measures)));
          },child:buildCupertinoFormRow('Colorette measures for: ', e.date))
        ).toList()
    );
  }

  Widget buildCupertinoFormRow(
    String prefix,
    String helper, {
    bool selected = false,
  }) {
    return CupertinoFormRow(
      prefix: Text(prefix),
      helper: Text(helper),
      child: selected
          ? const Icon(
              CupertinoIcons.check_mark,
              color: Color.fromARGB(255, 45, 118, 234),
              size: 20,
            )
          : Container(),
    );
  }
}

import 'package:dropdown_cupertino/dropdown_cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:template_app_bloc/api/api.dart';
import 'package:template_app_bloc/helpers/ui_helper.dart';

class TaskDetail extends StatefulWidget {
  final Task task;

  TaskDetail({super.key, required this.task});

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  TextEditingController status_controller = TextEditingController();
  List<String> list = [
        'DONE',
        'NOT_DONE',
        'NEEDS_REVIEW',
        'IN_REVIEW',
        'BLOCKED'
      ];

  @override
  Widget build(BuildContext context) {
    if (widget.task.canEdit == true) {
      list.add('FINISHED');
    }
    status_controller.text = widget.task.type;
    final levelIndicator = Container(
      child: Container(
        child: LinearProgressIndicator(
            backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
            value: 50,
            valueColor: AlwaysStoppedAnimation(Colors.green)),
      ),
    );

    final coursePrice = Container(
      width: UIHelper.deviceWidth,
      padding: const EdgeInsets.all(7.0),
      decoration: new BoxDecoration(
          border: new Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5.0)),
      child: new Text(
        // "\$20",
        widget.task.assigned_by.email.toString(),
        style: TextStyle(color: Colors.white),
      ),
    );

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 120.0),
        Icon(
          Icons.task,
          color: Colors.white,
          size: 40.0,
        ),
        SizedBox(height: 10.0),
        Text(
          widget.task.name,
          style: TextStyle(color: Colors.white, fontSize: 45.0),
        ),
        SizedBox(height: 30.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(flex: 1, child: levelIndicator),
            Expanded(
                flex: 6,
                child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      widget.task.type,
                      style: TextStyle(color: Colors.white),
                    ))),
            Expanded(flex: 1, child: coursePrice)
          ],
        ),
      ],
    );

    void showSheet(List<String> status) {
      showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) => CupertinoActionSheet(
                title: Text('Pick Status'),
                actions: status
                    .map((e) => CupertinoActionSheetAction(
                        onPressed: () {
                          setState(() {
                            status_controller.text = e;
                            print(status_controller.text);
                            Navigator.pop(context);
                          });
                          ;
                        },
                        child: Text(e)))
                    .toList(),
              ));
    }

    Widget buildForm() {
      return Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            shadowColor: Colors.black12,
            child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: SizedBox(
                  child: Center(
                      child: CupertinoTextFormFieldRow(
                    controller: status_controller,
                    prefix: const Text(
                      'Status:',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: TextStyle(color: Colors.black),
                    onTap: () => {showSheet(list)},
                  )),
                )),
          ),
          Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shadowColor: Colors.black12,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: SizedBox(
                    height: 45,
                    child: Center(
                      child: CupertinoTextFormFieldRow(
                        prefix: const Text(
                          'Name:',
                          style: TextStyle(color: Colors.black),
                        ),
                        style: TextStyle(color: Colors.black),
                        initialValue: widget.task.name,
                        readOnly: widget.task.canEdit ? false : true,
                      ),
                    )),
              )),
          Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shadowColor: Colors.black12,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: SizedBox(
                    height: 45,
                    child: Center(
                      child: CupertinoTextFormFieldRow(
                        prefix: const Text(
                          'Description:',
                          style: TextStyle(color: Colors.black),
                        ),
                        style: const TextStyle(color: Colors.black),
                        initialValue: widget.task.description,
                        readOnly: widget.task.canEdit ? false : true,
                      ),
                    )),
              )),
          Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shadowColor: Colors.black12,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: SizedBox(
                    height: 45,
                    child: Center(
                      child: MultiSelectDropDown<String>(
                        onOptionSelected: (List<ValueItem> selectedOptions) {},
                        options: [
                          ValueItem(
                              label: 'damjan.okilj@studen-global.com',
                              value: 'damjan.okilj@studen-global.com')
                        ],
                        fieldBackgroundColor: Colors.white,
                        selectionType: SelectionType.multi,
                      ),
                    )),
              )),
        ],
      );
    }

    final topContent = Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("zrna.jpg"),
                fit: BoxFit.fill,
              ),
            )),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
          child: Center(
            child: topContentText,
          ),
        ),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        )
      ],
    );

    final bottomContentText = Text(
      widget.task.description,
      style: TextStyle(fontSize: 18.0),
    );

    final readButton = Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: ElevatedButton(
          onPressed: () => {
            showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: const Text("Update Task"),
                    content: buildForm(),
                    actions: [
                      CupertinoDialogAction(
                        child: const Text("Cancel"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                })
          },
          child: Text("Update", style: TextStyle(color: Colors.black)),
        ));
    final bottomContent = Container(
        // height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        // color: Theme.of(context).primaryColor,
        padding: EdgeInsets.all(40.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    shadowColor: Colors.black12,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: SizedBox(
                          child: Center(
                              child: CupertinoTextFormFieldRow(
                            controller: status_controller,
                            prefix: const Text(
                              'Status:',
                              style: TextStyle(color: Colors.black),
                            ),
                            style: TextStyle(color: Colors.black),
                            onTap: () => {showSheet(list)},
                          )),
                        )),
                  ),
                  Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      shadowColor: Colors.black12,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: SizedBox(
                            height: 45,
                            child: Center(
                              child: CupertinoTextFormFieldRow(
                                prefix: const Text(
                                  'Name:',
                                  style: TextStyle(color: Colors.black),
                                ),
                                style: TextStyle(color: Colors.black),
                                initialValue: widget.task.name,
                                readOnly: widget.task.canEdit ? false : true,
                              ),
                            )),
                      )),
                  Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      shadowColor: Colors.black12,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: SizedBox(
                            height: 45,
                            child: Center(
                              child: CupertinoTextFormFieldRow(
                                prefix: const Text(
                                  'Description:',
                                  style: TextStyle(color: Colors.black),
                                ),
                                style: const TextStyle(color: Colors.black),
                                initialValue: widget.task.description,
                                readOnly: widget.task.canEdit ? false : true,
                              ),
                            )),
                      )),
                  Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      shadowColor: Colors.black12,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: SizedBox(
                            height: 45,
                            child: Center(
                              child: MultiSelectDropDown<String>(
                                onOptionSelected:
                                    (List<ValueItem> selectedOptions) {},
                                options: [
                                  ValueItem(
                                      label: 'damjan.okilj@studen-global.com',
                                      value: 'damjan.okilj@studen-global.com')
                                ],
                                fieldBackgroundColor: Colors.white,
                                selectionType: SelectionType.multi,
                              ),
                            )),
                      )),
                ],
              ),
              readButton
            ],
          ),
        ));
    return Scaffold(
      body: Column(
        children: [topContent, bottomContent],
      ),
    );
  }
}

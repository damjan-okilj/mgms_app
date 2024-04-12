import 'package:dropdown_cupertino/dropdown_cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:MGMS/api/api.dart';
import 'package:MGMS/helpers/ui_helper.dart';
import 'package:MGMS/views/profile/widgets/status_text_field.dart';

class NewTask extends StatefulWidget {
  NewTask({super.key, required this.users});

  List<User> users = [];
  @override
  State<NewTask> createState() => _NewTaskState();
  final List<String> list = [
    'DONE',
    'NOT_DONE',
    'NEEDS_REVIEW',
    'IN_REVIEW',
    'BLOCKED'
  ];
}

class _NewTaskState extends State<NewTask> {
  final ScrollController _scrollController = ScrollController();
  TextEditingController name_controller = TextEditingController();
  TextEditingController description_controller = TextEditingController();
  TextEditingController status_controller = TextEditingController();
  TextEditingController date_controller = TextEditingController();
  String dateInput = '';
  List<ValueItem> selected = [];


  @override
  Widget build(BuildContext context) {
    final levelIndicator = Container(
      child: Container(
        child: LinearProgressIndicator(
            backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
            value: 50,
            valueColor: AlwaysStoppedAnimation(Colors.green)),
      ),
    );

    void _showDatePicker(BuildContext context, String? due_time) async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2010),
        lastDate: DateTime(2025),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xfff9e3dd), // <-- SEE HERE
                onPrimary: Color.fromARGB(255, 9, 107, 187), // <-- SEE HERE
                onSurface: Colors.black, // <-- SEE HERE
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
      );
      if (pickedDate != null) {
        showTimePicker(context: context, initialTime: TimeOfDay.now())
            .then((selectedTime) {
          if (selectedTime != null) {
            DateTime selected = DateTime(pickedDate.year, pickedDate.month,
                pickedDate.day, selectedTime.hour, selectedTime.minute);
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            date_controller.text = formattedDate;
            dateInput = formattedDate;
          }
        });
      }
    }

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
          "Create Task",
          style: TextStyle(color: Colors.white, fontSize: 45.0),
        ),
        SizedBox(height: 30.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[],
        ),
      ],
    );

    void showSheet(List<String> status) async {
      showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) => CupertinoActionSheet(
                title: Text('Pick Status'),
                actions: status
                    .map((e) => CupertinoActionSheetAction(
                        onPressed: () {
                          setState(() {
                            status_controller.text = e;
                            Navigator.pop(context);
                          });
                          ;
                        },
                        child: Text(e)))
                    .toList(),
              ));
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
      ],
    );

    final bottomContentText = Text(
      "widget.task.description,",
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
                    title: const Text("Are you sure you want to create new task"),
                    actions: [
                      CupertinoDialogAction(
                        child: const Text("Create"),
                        onPressed: () async {
                          List<String> assignes = [];
                          for(var data in selected){
                            assignes.add(data.value);
                          }
                          CreateTaskDTO data = CreateTaskDTO(
                            assigned_to: assignes,
                            name: name_controller.text,
                            description: description_controller.text,
                            type: status_controller.text,
                            due_time: date_controller.text
                          );
                          var result = await createTask(data);
                          Navigator.pop(context);
                          showCupertinoDialog(context: context, builder: (context){
                            return CupertinoAlertDialog(
                              content: Text(result),
                              actions: [CupertinoDialogAction(child: const Text('Ok'), onPressed: () {
                                Navigator.pop(context);
                              },)],
                            );
                          });
                        },
                      ),
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
          child: Text("Create", style: TextStyle(color: Colors.black)),
        ));
    Widget bottomContent() {
      return Container(
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
                        shadowColor: Colors.white,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: SizedBox(
                              child: Center(
                                  child: StatusTextFieldWidget(
                            status: widget.list,
                            initialStatus: 'Status',
                            textEditingController: status_controller,
                            onStatusChanged: (status) {
                              status_controller.text = status;
                              setState(() {});
                            },
                          ))),
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
                                  controller: name_controller,
                                  prefix: const Text(
                                    'Name:',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  style: TextStyle(color: Colors.black),
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
                                  controller: description_controller,
                                  prefix: const Text(
                                    'Description:',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  style: const TextStyle(color: Colors.black),
                                ),
                              )),
                        )),
                    Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        shadowColor: Colors.black12,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0, right: 0),
                          child: SizedBox(
                              height: 45,
                              child: Center(
                                child: MultiSelectDropDown<String>(
                                  onOptionSelected:
                                      (List<ValueItem> selectedOptions) {
                                        selected = selectedOptions;
                                        print(selected);
                                      },
                                  onOptionRemoved: (index, ValueItem removedOption){ 
                                    selected.remove(removedOption);
                                  },
                                  options: widget.users.map((e) => 
                                    ValueItem(label: '${e.first_name} ${e.last_name}', value: e.email)
                                  ).toList(),
                                  fieldBackgroundColor: Colors.white,
                                  selectionType: SelectionType.multi,
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
                                  prefix: Text(
                                    "Due Time: ",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  controller: date_controller,
                                  onTap: () {
                                    _showDatePicker(context, '');
                                  },
                                ),
                              )),
                        )),
                  ],
                ),
                readButton
              ],
            ),
          ));
    }

    ;
    return SingleChildScrollView(
      child: Column(
        children: [
          topContent,
          SingleChildScrollView(
            child: bottomContent(),
          )
        ],
      ),
    );
  }
}

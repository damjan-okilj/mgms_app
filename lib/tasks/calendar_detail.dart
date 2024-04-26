import 'package:MGMS/components/comments_field.dart';
import 'package:dropdown_cupertino/dropdown_cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:MGMS/api/api.dart';
import 'package:MGMS/helpers/ui_helper.dart';
import 'package:MGMS/views/profile/widgets/status_text_field.dart';

class CalendarDetail extends StatefulWidget {
  final dynamic task;
  final List<User> users;
  CalendarDetail({super.key, required this.task, required this.users});
  @override
  State<CalendarDetail> createState() => _CalendarDetailState();
  List<String> list = [
    'DONE',
    'NOT_DONE',
    'NEEDS_REVIEW',
    'IN_REVIEW',
    'BLOCKED'
  ];
}

class _CalendarDetailState extends State<CalendarDetail> {
  TextEditingController status_controller = TextEditingController();
  String? _selectedStatus;
  String dateInput = '';
  List<String> pickedUsers = [];

  @override
  void initState() {
    status_controller.text = widget.task.type;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dateInput = widget.task.due_time;
    _selectedStatus = widget.task.type;
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
            dateInput = formattedDate;
          }
        });
      }
    }

    final coursePrice = ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 50),
        child: Container(
          padding: const EdgeInsets.only(bottom: 1.0),
          decoration: new BoxDecoration(
              border: new Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(5.0)),
          child: InkWell(
              onTap: () => {_showDatePicker(context, widget.task.due_time)},
              child: Text(
                // "\$20",
                'Due Time: ${dateInput}',
                style: const TextStyle(color: Colors.white),
              )),
        ));

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
          style: TextStyle(color: Colors.white, fontSize: 20.0),
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
          ],
        ),
        const Spacer(),
        SizedBox(
          height: 19,
          child: coursePrice,
        )
      ],
    );

    void showSheet(List<String> status) {
      if (widget.task.canEdit == true) {
        status.add('FINISHED');
      }
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

    Widget buildForm() {
      if (widget.task.canEdit == true) {
        widget.list.add("FINISHED");
      }
      return Column(
        children: [
          Card(
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            shadowColor: Colors.transparent,
            child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: SizedBox(
                  child: Center(
                      child: StatusTextFieldWidget(
                    status: widget.list,
                    initialStatus: _selectedStatus,
                    textEditingController: status_controller,
                    onStatusChanged: (status) => {_selectedStatus = status},
                  )),
                )),
          ),
          Card(
              shape: OutlineInputBorder(
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
              shape: OutlineInputBorder(
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
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shadowColor: Colors.black12,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: SizedBox(
                    height: 45,
                    child: Center(
                      child: MultiSelectDropDown<String>(
                        selectedOptions: widget.task.assigned_to
                            .map((e) => ValueItem(
                                label: '${e.first_name} ${e.last_name}',
                                value: e.email))
                            .toList(),
                        onOptionSelected: (List<ValueItem> selectedOptions) {
                          selectedOptions.map((e) => pickedUsers.add(e.value));
                          print(pickedUsers);
                        },
                        onOptionRemoved: (index, ValueItem selectedOption) {
                          pickedUsers.remove(selectedOption.value);
                        },
                        options: widget.users
                            .map((e) => ValueItem(
                                label: '${e.first_name} ${e.last_name}',
                                value: e.email))
                            .toList(),
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
                    title: const Text("Update status"),
                    content: const Text("Update status?"),
                    actions: [
                      CupertinoDialogAction(
                        child: const Text("Yes"),
                        onPressed: () {
                          updateTaskStatus(
                              StatusDTO(type: status_controller.text),
                              widget.task.slug);
                          Navigator.pop(context);
                        },
                      ),
                      CupertinoDialogAction(
                        child: const Text(
                          "No",
                          style: TextStyle(color: Colors.red),
                        ),
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
    Widget bottomContent() {
      List<ValueItem<String>> valueItems = [];
      for (var user in widget.task.assigned_to) {
        valueItems.add(ValueItem(
            label: '${user.first_name} ${user.last_name}', value: user.email));
      }
      print(valueItems);
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
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        shadowColor: Colors.transparent,
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: SizedBox(
                              child: Center(
                                  child: StatusTextFieldWidget(
                            status: widget.list,
                            initialStatus: widget.task.type,
                            textEditingController: status_controller,
                            onStatusChanged: (status) {
                              setState(() {
                                status_controller.text = status;
                                _selectedStatus = status;
                              });
                            },
                          ))),
                        )),
                    Card(
                        shape: OutlineInputBorder(
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
                        shape: OutlineInputBorder(
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
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        shadowColor: Colors.black12,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0, right: 0),
                          child: SizedBox(
                              height: 45,
                              child: Center(
                                child: MultiSelectDropDown<String>(
                                  selectedOptions: valueItems,
                                  onOptionSelected:
                                      (List<ValueItem> selectedOptions) {
                                    selectedOptions
                                        .map((e) => pickedUsers.add(e.value));
                                    print(pickedUsers);
                                  },
                                  onOptionRemoved:
                                      (index, ValueItem selectedOption) {
                                    pickedUsers.remove(selectedOption.value);
                                  },
                                  options: widget.users
                                      .map((e) => ValueItem(
                                          label:
                                              '${e.first_name} ${e.last_name}',
                                          value: e.email))
                                      .toList(),
                                  fieldBackgroundColor: Colors.white,
                                  selectionType: SelectionType.multi,
                                ),
                              )),
                        )),
                  ],
                ),
                readButton,
                CommentsList(
                  comments: widget.task.comments,
                  slug: widget.task.slug,
                )
              ],
            ),
          ));
    }

    ;
    return Material(
        child: SingleChildScrollView(
      child: Column(
        children: [
          topContent,
          SingleChildScrollView(
            child: bottomContent(),
          )
        ],
      ),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:todole/controllers/taskcontroller.dart';
import 'package:todole/data/taskdb.dart';
import 'package:todole/interface/theme.dart';
import 'package:todole/interface/widget/button.dart';
import 'package:todole/interface/widget/input1.dart';
import 'package:todole/interface/widget/input2.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(hours: 2)))
      .toString();

  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList = [0, 5, 10, 15, 20];
  String _selectedRepeat = "None";
  List<String> repeatList = [
    "None",
    "Daily",
    "Weekly",
    "Yearly",
  ];
  int _selectedColor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white24,
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Task",
                style: headingStyle,
              ),
              MyInputField(
                  hint: "Enter your title",
                  title: '',
                  controller: _titleController),
              MyInputField(
                  title: '',
                  hint: "Enter your note",
                  controller: _noteController),
              MyInputFieldWithWidget(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  icon: const Icon(
                    Icons.calendar_today_rounded,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    print("Calender says hello");
                    _getDateFromUser();
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyInputFieldWithWidget(
                      title: "Start Time",
                      hint: _startTime,
                      widget: IconButton(
                        icon: const Icon(
                          Icons.access_time_filled_rounded,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          debugPrint("Start Time pressed");
                          _getTimeFromUser(isStartTime: true);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: MyInputFieldWithWidget(
                      title: "End Time",
                      hint: _endTime,
                      widget: IconButton(
                        icon: const Icon(
                          Icons.access_time_filled_rounded,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          debugPrint("End Time pressed");
                          _getTimeFromUser(isStartTime: false);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              MyInputFieldWithWidget(
                title: "Remind",
                hint: "$_selectedRemind minutes early",
                widget: DropdownButton(
                    icon: const Icon(
                      Icons.arrow_drop_down_rounded,
                      color: Colors.grey,
                    ),
                    iconSize: 50,
                    alignment: AlignmentDirectional.centerStart,
                    underline: Container(
                      height: 0,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRemind = int.parse(newValue!);
                      });
                    },
                    elevation: 4,
                    style: subTitleStyle,
                    items:
                        remindList.map<DropdownMenuItem<String>>((int value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(value.toString()),
                      );
                    }).toList()),
              ),
              MyInputFieldWithWidget(
                title: "Repeat",
                hint: _selectedRepeat,
                widget: DropdownButton(
                    icon: const Icon(
                      Icons.arrow_drop_down_rounded,
                      color: Colors.grey,
                    ),
                    iconSize: 50,
                    underline: Container(
                      height: 0,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRepeat = newValue!;
                      });
                    },
                    elevation: 4,
                    style: subTitleStyle,
                    items: repeatList
                        .map<DropdownMenuItem<String>>((String? value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value!,
                            style: const TextStyle(color: Colors.grey)),
                      );
                    }).toList()),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPallete(),
                  MyButton(label: "Create Task", onTap: () => _validateData())
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _validateData() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar("Required field", "Please enter title and note",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.purple[900],
          icon: Icon(Icons.warning_amber_rounded,
              color: Colors.purple[900], size: 30));
    }
  }

  _addTaskToDb() async {
   int value = await _taskController.addTask(
        task: Task(
      title: _titleController.text,
      note: _noteController.text,
      date: DateFormat.yMd().format(_selectedDate),
      startTime: _startTime,
      endTime: _endTime,
      remind: _selectedRemind,
      repeat: _selectedRepeat,
      priority: _selectedColor,
      isCompleted: 0,
    ));
    print("My ID is $value");
  }

  _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Priority", style: titleStyle),
        const SizedBox(
          height: 4,
        ),
        Wrap(
          children: List<Widget>.generate(
            3,
            (int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = index;
                    debugPrint("Index : $_selectedColor");
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CircleAvatar(
                      child: _selectedColor == index
                          ? const Icon(
                              Icons.done_rounded,
                              color: Colors.white,
                              size: 20,
                            )
                          : Container(),
                      radius: 20,
                      backgroundColor: index == 0
                          ? Colors.green
                          : index == 1
                              ? Colors.redAccent
                              : Colors.yellow),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0, // pembatas antara appbar dan main screen
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage("assets/logo_small.png"),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2100),
    );

    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
        print(_selectedDate);
      });
    } else {
      debugPrint("Invalid Data!");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var _pickedTime = await _showTimePicker(isStartTime: isStartTime);
    //String _formatedTime = _pickedTime.format(context);
    String _formatedTime = _pickedTime.format(context);

    if (_pickedTime == null) {
      debugPrint("Time is invalid");
    } else if (isStartTime) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else if (!isStartTime) {
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

  _showTimePicker({required bool isStartTime}) {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: isStartTime
          ? TimeOfDay(
              hour: int.parse(_startTime.split(":")[0]),
              minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
            )
          : TimeOfDay(
              hour: int.parse(_endTime.split(":")[0]),
              minute: int.parse(_endTime.split(":")[1].split(" ")[0]),
            ),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
  }
}

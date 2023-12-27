import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:muhaslti/model/Class.dart';
import 'package:muhaslti/model/Level.dart';
import 'package:muhaslti/model/Student.dart';
import 'package:muhaslti/view/CreateStudent.dart';
import 'package:muhaslti/view/loadingPage.dart';
import 'package:muhaslti/view/showSubjects.dart';
import 'package:provider/provider.dart';
import '../model/Employee.dart';


class ShowStudentList extends StatefulWidget {
  const ShowStudentList({Key? key}) : super(key: key);

  @override
  State<ShowStudentList> createState() => _ShowStudentListState();
}

class _ShowStudentListState extends State<ShowStudentList> {
  List<Student> students = [];
  List<Level> levels = [];
  List<Class> classes = [];
  late Color myColor;

  List<Class> currentClasses = [];

  Level? selectedLevel;
  Class? selectedClass;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    myColor = Theme.of(context).primaryColor;
    Employee employee = Provider.of<Employee>(context);
    return Scaffold(
        body: Stack(children: [
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromARGB(255, 255, 255, 255),
                        width: 5,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                      color: myColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 0,
                        right: 0,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          const Text(
                            'قائمة الطلاب',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontFamily: 'ElMessiri'),
                          ),
                          const SizedBox(
                            height: 17,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildFutureDropDownLevels(employee),
                              const SizedBox(
                                width: 40,
                              ),
                              buildFutureDropDownClasses(employee)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  flex: 3,
                  child: Container(child: buildFutureListViewStudents(employee)),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20.0,
            left: 20.0,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateStudent()));
              },
              backgroundColor: myColor,
              child: Icon(Icons.add, color: Colors.white),
            ),
          ),
        ]));
  }

  Widget buildFutureDropDownLevels(Employee employee) {
    return FutureBuilder<List<Level>>(
        future: employee.getLevels(),
        builder: (context, snapshot) {
          if (levels.isNotEmpty) return buildDropDownLevels();
          if (snapshot.connectionState == ConnectionState.done) {
            levels = snapshot.data ?? [];

            if (levels.isNotEmpty) selectedLevel = levels[0];
          } else {
            return LoadingScreen();
          }
          return buildDropDownLevels();
        });
  }

  Widget buildFutureDropDownClasses(Employee employee) {
    return FutureBuilder<List<Class>>(
        future: employee.getClasses(),
        builder: (context, snapshot) {
          if (classes.isNotEmpty) return buildDropDownClasses();
          if (snapshot.connectionState == ConnectionState.done) {
            classes = snapshot.data ?? [];
            if (classes.isNotEmpty) selectedClass = classes[0];
          } else {
            return LoadingScreen();
          }
          return buildDropDownClasses();
        });
  }

  Widget buildFutureListViewStudents(Employee employee) {
    return FutureBuilder<List<Student>>(
        future: employee
            .getStudents((selectedClass == null) ? -1 : selectedClass!.ID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            students = snapshot.data ?? [];
          } else {
            return LoadingScreen();
          }
          return buildListViewStudents();
        });
  }

  void filterClasses() {
    currentClasses = [];
    selectedClass = null;
    if (selectedLevel == null) {
      return;
    }

    for (Class _class in classes) {
      if (_class.levelName == selectedLevel?.levelName) {
        currentClasses.add(_class);
      }
    }
    if (currentClasses.isNotEmpty) selectedClass = currentClasses[0];
  }

  // Design
  Widget buildDropDownLevels() {
    return DropdownButton<Level>(
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Color.fromARGB(223, 251, 247, 247),
      ),
      items: levels
          .map((Level level) => DropdownMenuItem<Level>(
        value: level,
        child: Text(
          level.levelName,
          style: TextStyle(fontFamily: 'ElMessiri'),
        ),
      ))
          .toList(),
      onChanged: (selectedLevel) {
        setState(() {
          this.selectedLevel = selectedLevel;
          filterClasses();
        });
      },
      hint: const Text(
        'تحديد المرحلة',
        style: TextStyle(fontFamily: 'ElMessiri'),
      ),
      underline: Container(
        height: 2,
        color: const Color.fromARGB(197, 255, 255, 255),
      ),
      value: selectedLevel,
    );
  }

  Widget buildDropDownClasses() {
    return DropdownButton<Class>(
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Color.fromARGB(223, 251, 247, 247),
      ),
      items: currentClasses
          .map((Class _class) => DropdownMenuItem<Class>(
        value: _class,
        child: Text(
          _class.className,
          style: const TextStyle(fontFamily: 'ElMessiri'),
        ),
      ))
          .toList(),
      hint: const Text(
        'تحديدالشعبة',
        style: TextStyle(fontFamily: 'ElMessiri'),
      ),
      value: selectedClass,
      underline: Container(
        height: 2,
        color: const Color.fromARGB(197, 255, 255, 255),
      ),
      onChanged: (selectedClass) {
        setState(() {
          this.selectedClass = selectedClass;
        });
      },
    );
  }

  Widget buildListViewStudents() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: students.length,
      itemBuilder: (context, index) {
        Student student = students[index];
        return Column(
          children: [
            ListTile(
              title: Text(student.studentName ?? '',
                  style: const TextStyle(fontFamily: 'ElMessiri', fontSize: 17)),
              subtitle: Text(
                '${student.levelName ?? ''}',
                style: const TextStyle(fontFamily: 'ElMessiri'),
              ),
              leading: const CircleAvatar(
                  backgroundImage: AssetImage(
                    'images/student.png',
                  )),

              trailing: const Icon(
                Icons.abc,
                size: 40,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:(context)=>  ShowSubjects(student: student,),
                    )
                );
              },
            ),
            const SizedBox(
              height: 10.0,
              child: Divider(
                color: Color.fromARGB(106, 0, 0, 0),
                height: 7,
                endIndent: 0,
                indent: 60,
              ),
            ),
          ],
        );
      },
    );
  }
}

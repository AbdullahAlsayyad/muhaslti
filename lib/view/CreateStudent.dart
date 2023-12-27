import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:muhaslti/model/Employee.dart';
import 'package:provider/provider.dart';
import '../model/Level.dart';
import 'loadingPage.dart';

class CreateStudent extends StatefulWidget {
  const CreateStudent({super.key});

  @override
  State<CreateStudent> createState() => _CreateStudentState();
}

class _CreateStudentState extends State<CreateStudent> {
  late Color myColor;
  late Color mysColor;
  var height, width;
  List<Level> levels = [];
  Level? selectedLevel;

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController parentNameController = TextEditingController();
  TextEditingController studentNameController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    myColor = Theme.of(context).primaryColor;
    mysColor = Theme.of(context).primaryColorDark;
    Employee employee = Provider.of<Employee>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: myColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                height: height * 0.25,
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 35, left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {},
                            child: const Icon(
                              Icons.add_circle,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: myColor,
                            ),
                          )
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 15, left: 0, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'إضافة طالب جديد',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'ElMessiri',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                height: height * 0.75,
                width: width,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: studentNameController,
                        decoration: InputDecoration(
                          labelText: 'اسم الطالب',
                          labelStyle: TextStyle(
                            fontFamily: 'ElMessiri',
                          ),
                          contentPadding: EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: buildFutureDropDownLevels(employee),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: parentNameController,
                        decoration: InputDecoration(
                          labelText: 'اسم ولي الامر',
                          labelStyle: TextStyle(
                            fontFamily: 'ElMessiri',
                          ),
                          contentPadding: EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: phoneNumberController,
                        decoration: InputDecoration(
                          labelText: 'رقم هاتف ولي الأمر',
                          labelStyle: TextStyle(
                            fontFamily: 'ElMessiri',
                          ),
                          contentPadding: EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: birthDateController,
                        decoration: InputDecoration(
                          labelText: 'تاريخ الميلاد',
                          labelStyle: TextStyle(
                            fontFamily: 'ElMessiri',
                          ),
                          contentPadding: EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        createStudent(employee);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        elevation: 10,
                        shadowColor: myColor,
                        minimumSize: const Size(150, 40),
                      ),
                      child: Text(
                        'اضافة',
                        style: TextStyle(fontFamily: 'ElMessiri'),
                      ),

                    ),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
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

  // Widget buildDropDownLevels() {
  //   return DropdownButton<Level>(
  //     icon: Icon(
  //       Icons.arrow_drop_down,
  //       color: Color.fromARGB(223, 0, 0, 0),
  //     ),
  //     items: levels
  //         .map((Level level) => DropdownMenuItem<Level>(
  //       value: level,
  //       child: Text(
  //         level.levelName,
  //         style: TextStyle(fontFamily: 'ElMessiri'),
  //       ),
  //     ))
  //         .toList(),
  //     onChanged: (selectedLevel) {
  //       setState(() {
  //         this.selectedLevel = selectedLevel;
  //       });
  //     },
  //     hint: Text(
  //       'تحديد المرحلة',
  //       style: TextStyle(fontFamily: 'ElMessiri'),
  //     ),
  //     underline: Container(
  //       height: 2,
  //       color: Color.fromARGB(197, 0, 0, 0),
  //     ),
  //     value: selectedLevel,
  //   );
  // }
  Widget buildDropDownLevels() {
    return InputDecorator(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
          borderSide: BorderSide(color: Colors.black),
        ),

      ),
      child: DropdownButton<Level>(
        icon: null,
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
          });
        },
        hint: Text(
          'تحديد المرحلة',
          style: TextStyle(fontFamily: 'ElMessiri'),
        ),
        underline: Container(
          height: 0,
        ),
        value: selectedLevel,
      ),
    );
  }

  void createStudent(Employee employee) {
    if (employee.type != EmployeeType.registrar) return;
    if (studentNameController.text.isEmpty || phoneNumberController.text.isEmpty
        || parentNameController.text.isEmpty || birthDateController.text.isEmpty || selectedLevel == null) return;
    employee.createStudent(selectedLevel!.ID, parentNameController.text, phoneNumberController.text, studentNameController.text, birthDateController.text, onResult: (result) {
      if (result == 0) Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "تمت الاضافة بنجاح",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: mysColor,
          textColor: Colors.white,
          fontSize: 12.0);
    });
  }
}

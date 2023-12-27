import 'package:flutter/material.dart';
import 'package:muhaslti/model/Employee.dart';
import 'package:muhaslti/view/CreateEmployee.dart';

import 'package:provider/provider.dart';

import '../model/Manager.dart';
import 'loadingPage.dart';

class ShowEmployees extends StatefulWidget {
  ShowEmployees({Key? key}) : super(key: key);

  @override
  _ShowEmployeesState createState() => _ShowEmployeesState();
}

class _ShowEmployeesState extends State<ShowEmployees> {
  late Color myColor;
  String dropdownValue = 'أستاذ ';
  late Color mysColor;

  List<Employee> _employees = [];
  List<Employee> _filteredEmployees = [];

  Future<List<Employee>> getEmployees(Employee employee) async {
    if (employee.type != EmployeeType.manager) {
      return _employees;
    }
    List<Employee> employees =
    await Manager.byEmployee(employee).getEmployees();
    return employees;
  }

  @override
  Widget build(BuildContext context) {
    final Employee employee = Provider.of<Employee>(context);

    myColor = Theme.of(context).primaryColor;
    mysColor = Theme.of(context).primaryColorDark;

    if (_filteredEmployees.isEmpty) {
      _filteredEmployees = _employees;
    }

    return FutureBuilder<List<Employee>>(
        future: getEmployees(employee),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.connectionState == ConnectionState.done) {
            _employees = snapshot.data ?? [];
          }
          void _updateFilteredEmployees(String selectedValue) {
            setState(() {
              dropdownValue = selectedValue;
              _filteredEmployees = _employees.where((employee) {
                if (dropdownValue == 'أستاذ ' && employee.type == EmployeeType.teacher) {
                  return true;
                } else if (dropdownValue == 'مشرف' && employee.type == EmployeeType.supervisor) {
                  return true;
                } else if (dropdownValue == 'مسجل' && employee.type == EmployeeType.registrar) {
                  return true;
                }else if (dropdownValue == 'وكيل' && employee.type == EmployeeType.manager) {
                  return true;
                }
                return false;
              }).toList();
            });
          }
          return Scaffold(
            body: Stack(
              children: [
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
                            padding: const EdgeInsets.only(left: 0,right: 15,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 3),
                                    Image(
                                        image: AssetImage('images/staff.png'),
                                        width: 40),
                                    SizedBox(height: 0),
                                    Text(
                                      'نوع الموظف',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontFamily: 'ElMessiri'
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: DropdownButton<String>(
                                        value: dropdownValue,
                                        icon: Icon(
                                          Icons.arrow_drop_down,
                                          color: Color.fromARGB(
                                              223, 251, 247, 247),
                                        ),
                                        iconSize: 25,
                                        elevation: 30,
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                              222, 255, 255, 255),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        underline: Container(
                                          height: 2,
                                          color: const Color.fromARGB(
                                              197, 255, 255, 255),
                                        ),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _updateFilteredEmployees( newValue ?? 'أستاذ');

                                          });
                                        },
                                        items: [
                                          DropdownMenuItem<String>(
                                            value: 'أستاذ ',
                                            child: Text(
                                              'أستاذ ',
                                              style: TextStyle(
                                                  color: Colors.black,fontFamily: 'ElMessiri'),
                                            ),
                                          ),
                                          DropdownMenuItem<String>(
                                            value: 'مشرف',
                                            child: Text(
                                              'مشرف',
                                              style: TextStyle(
                                                  color: Colors.black,fontFamily: 'ElMessiri'),
                                            ),
                                          ),
                                          DropdownMenuItem<String>(
                                            value: 'مسجل',
                                            child: Text(
                                              'مسجل',
                                              style: TextStyle(
                                                  color: Colors.black,fontFamily: 'ElMessiri'),
                                            ),
                                          ),
                                          DropdownMenuItem<String>(
                                            value: 'وكيل',
                                            child: Text(
                                              'وكيل',
                                              style: TextStyle(
                                                  color: Colors.black,fontFamily: 'ElMessiri'),
                                            ),
                                          ),

                                        ],


                                      ),

                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          child: ListView.builder(
                            itemCount: _filteredEmployees.length,
                            itemBuilder: (BuildContext context, index) {
                              return Dismissible(
                                key:
                                Key(_filteredEmployees[index].IDCardNumber),
                                child: _buildListTile(index),
                                background: _buildeEdit(),
                                secondaryBackground: _buildInfo(),
                                movementDuration:
                                Duration(milliseconds: 300), // تقليل السحب
                                onDismissed: (DismissDirection direction) {
                                  if (direction ==
                                      DismissDirection.endToStart) {
                                    _InfoEmployee(index);
                                  } else if (direction ==
                                      DismissDirection.startToEnd) {
                                    _EditEmployee(index);
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20.0,
                  left: 20.0,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateEmployee()));
                    },
                    backgroundColor: myColor,
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        });
  }

  ListTile _buildListTile(int index) {
    return ListTile(
      title: Text(
        '${_filteredEmployees[index].employeeName}',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,fontFamily: 'ElMessiri'),
      ),
      subtitle: Text(_filteredEmployees[index].type.toString(),style: TextStyle(fontFamily: 'ElMessiri'),),
      leading: Image(
        image: AssetImage('images/employees.png'),
        width: 30,
      ),
      trailing: Icon(
        Icons.work,
      ),
      onTap: () {
        _InfoEmployee(index);
      },
    );
  }

  void _InfoEmployee(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: BorderSide(color: Colors.white70, width: 2.0),
          ),
          title: Text(
            'بيانات الموظف',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900,fontFamily: 'ElMessiri'),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                title: Text('اسم الموظف',
                    style:
                    TextStyle(fontSize: 17, fontWeight: FontWeight.w700,fontFamily: 'ElMessiri')),
                subtitle: Text('${_filteredEmployees[index].employeeName}'),
              ),
              Divider(height: 1, thickness: 1),
              ListTile(
                leading: Icon(
                  Icons.credit_card,
                  color: Colors.black,
                ),
                title: Text('رقم البطاقة',
                    style:
                    TextStyle(fontSize: 17, fontWeight: FontWeight.w700,fontFamily: 'ElMessiri')),
                subtitle: Text('${_filteredEmployees[index].IDCardNumber}'),
              ),
              Divider(height: 1, thickness: 1),
              ListTile(
                leading: Icon(
                  Icons.work,
                  color: Colors.black,
                ),
                title: Text('النوع',
                    style:
                    TextStyle(fontSize: 17, fontWeight: FontWeight.w700,fontFamily: 'ElMessiri')),
                subtitle: Text(' ${_filteredEmployees[index].type}'),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('إغلاق',style: TextStyle(fontFamily: 'ElMessiri'),),
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                elevation: 7,
                shadowColor: myColor,
                minimumSize: const Size(90, 27),
              ),
            ),
          ],
        );
      },
    );
  }

  void _EditEmployee(int index) {
    // اضافة الكود الخاص بتحرير الموظف هنا
  }

  Container _buildeEdit() {
    return Container(
      color: Colors.green,
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Container _buildInfo() {
    return Container(
      color: Colors.grey,
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.info,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

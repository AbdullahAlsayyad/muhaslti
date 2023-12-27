import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../model/Employee.dart';
import '../model/Manager.dart';

class CreateEmployee extends StatefulWidget {
  CreateEmployee({super.key});

  @override
  State<CreateEmployee> createState() => _CreateEmployeeState();
}

class _CreateEmployeeState extends State<CreateEmployee> {
  late Color myColor;
  late Color mysColor;

  var height, width;

  TextEditingController IDCardNumber = TextEditingController();
  TextEditingController employeeName = TextEditingController();
  String type = 'أستاذ';
  var newEmployees;

  @override
  Widget build(BuildContext context) {
    Employee currentEmployee = Provider.of<Employee>(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    myColor = Theme.of(context).primaryColor;
    mysColor = Theme.of(context).primaryColorDark;

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
                      padding: EdgeInsets.only(top: 20, left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'اضافة موظف جديد',
                            style: TextStyle(
                              fontSize: 35,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: IDCardNumber,
                        decoration: InputDecoration(
                          labelText: 'رقم البطاقة',
                          contentPadding: EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: employeeName,
                        decoration: InputDecoration(
                          labelText: 'اسم الموظف',
                          contentPadding: EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'النوع',
                          contentPadding: EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: DropdownButton<String>(
                          value: type,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.black, fontSize: 15),
                          underline: Container(
                            height: 0,
                            color: Color.fromARGB(129, 2, 0, 5),
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              type = newValue!;
                            });
                          },
                          items: ['أستاذ', 'مشرف', 'مسجل', 'وكيل']
                              .map<DropdownMenuItem<String>>(
                                (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(value),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        createEmployee(currentEmployee, context);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        elevation: 10,
                        shadowColor: myColor,
                        minimumSize: const Size(150, 50),
                      ),
                      child: const Text("Add Employee"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void createEmployee(currentEmployee, BuildContext context) {
    EmployeeType type = EmployeeType.none;

    if (this.type == 'أستاذ') {
      type = EmployeeType.teacher;
    } else if (this.type == 'مشرف') {
      type = EmployeeType.supervisor;
    } else if (this.type == 'مسجل') {
      type = EmployeeType.registrar;
    } else if (this.type == 'وكيل') {
      type = EmployeeType.manager;
    }

    Employee newEmployee = Employee(
      ID: -1,
      employeeName: employeeName.text,
      IDCardNumber: IDCardNumber.text,
      type: type,
    );

    createEmployeeDB(currentEmployee, newEmployee, context);
  }

  void createEmployeeDB(
      Employee currentEmployee, Employee newEmployee, BuildContext context) {
    if (currentEmployee.type != EmployeeType.manager) {
      Fluttertoast.showToast(
          msg: "حدث خطا في الاضافة",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 0,
          backgroundColor: mysColor,
          textColor: Colors.white,
          fontSize: 12.0);
    }

    Manager manager = Manager.byEmployee(currentEmployee);
    manager.createEmployee(
        Employee(
            ID: -1,
            employeeName: newEmployee.employeeName,
            IDCardNumber: newEmployee.IDCardNumber,
            type: newEmployee.type), onResult: (result) {
      if (result == NewEmployeeResult.successfully) {
        Fluttertoast.showToast(
            msg: "تمت الاضافة بنجاح",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: mysColor,
            textColor: Colors.white,
            fontSize: 12.0);

        Navigator.pop(context);
      } else if (result == NewEmployeeResult.nameExists) {
        Fluttertoast.showToast(
            msg: "الاسم موجود مسبقاً",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: mysColor,
            textColor: Colors.white,
            fontSize: 12.0);
      }
    });
  }
}

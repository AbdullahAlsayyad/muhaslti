import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:muhaslti/model/Employee.dart';
import 'package:muhaslti/view/ShowStudents.dart';
import 'package:provider/provider.dart';

import 'ShowEmployees.dart';
import 'initialize_system.dart';

// ignore: must_be_immutable
class Dashborad extends StatelessWidget {
  late Color myColor;
  late Color mysColor;
  var height, width;
  List imgSrc = [
    "images/students.png",
    "images/staff.png",
    "images/homework.png",
    "images/gear.png"
  ];

  bool builded = false;



  List titles = ["الطلاب ", "الموظفين", "المرفقات", "النظام"];
  List<Widget> page = [ShowStudentList(), ShowEmployees(), ShowEmployees(),InitializeSystem()];

  Dashborad({super.key});

  void handleGridItemTap(int index) {
    print('Pressed item: ${imgSrc[index]}');
  }

  @override
  Widget build(BuildContext context) {
    myColor = Theme.of(context).primaryColor;
    mysColor = Theme.of(context).primaryColorDark;
    Employee employee = Provider.of<Employee>(context);
    if (!builded) {
      Fluttertoast.showToast(
          msg: ' مرحباً ${employee.employeeName}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: myColor,
          textColor: Colors.white,
          fontSize: 16.0);
      builded = true;
    }
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: myColor,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(),
              height: height * 0.25,
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 0, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        InkWell(
                          onTap: () {
                            Provider.of<Employee>(context, listen: false).updateColor();
                          },


                          child: SafeArea(

                            child: const Icon(

                              Icons.dashboard,
                              color: Colors.white,
                              size: 50,
                            ),
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
                    padding: EdgeInsets.only(top: 20, left: 15, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'الصفحة الرئيسية',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                            fontFamily: 'ElMessiri',
                          ),
                        )
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
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.1,
                    mainAxisSpacing: 25),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: imgSrc.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onLongPress: () {},
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => page[index]));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(131, 0, 0, 0),
                              spreadRadius: 1,
                              blurRadius: 6,
                            ),
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            imgSrc[index],
                            width: 100,
                          ),
                          Text(
                            titles[index],
                            style: const TextStyle(
                                color: Color.fromARGB(255, 79, 75, 75),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'ElMessiri'),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

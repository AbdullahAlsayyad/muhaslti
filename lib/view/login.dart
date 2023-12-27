

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:muhaslti/model/Employee.dart';
import 'package:muhaslti/view/Dashboard.dart';
import 'package:muhaslti/view/main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/Account.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Color myColor;
  late Color mysColor;
  late Size mediaSize;
  TextEditingController UserController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberUser = false;



  @override
  Widget build(BuildContext context) {

    myColor = Theme.of(context).primaryColor;
    mysColor = Theme.of(context).primaryColor;
    mediaSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: myColor,
          body: ListView(children: [
            _buildTop(),
            _buildBottom(context),
          ]),
        ),
      ),
    );
  }

  Widget _buildTop() {
    return Expanded(
      child: SizedBox(
        width: mediaSize.width,
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15.0, top: 20, right: 10),
              child: Text(
                "محصلتي",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  fontFamily: 'ElMessiri',
                ),
              ),
            ),
            Icon(
              Icons.school,
              size: 50,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottom(BuildContext context) {
    return Expanded(
      flex: 2,
      child: SizedBox(
        width: mediaSize.width,
        child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                  bottomLeft: Radius.circular(40))),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: _buildForm(context),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "مرحباً",
            style: TextStyle(
              color: myColor,
              fontSize: 32,
              fontFamily: 'ElMessiri',
            ),
          ),
          _buildGreyText("الرجاء ادخال المعلومات للدخول"),
          const SizedBox(height: 50),
          TextFormField(
              controller: UserController,
              decoration: InputDecoration(
                labelText: ' اسم المستخدم',
                labelStyle: TextStyle(
                  fontFamily: 'ElMessiri',
                ),
                contentPadding: EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              )
          ),
          const SizedBox(height: 20),
          _buildInputField(passwordController, isPassword: true),
          const SizedBox(height: 20),
          _buildRememberForgot(),
          const SizedBox(height: 20),
          _buildLoginButton(context),
          const SizedBox(height: 20),
          _buildOtherLogin(),
        ],
      ),
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.grey,
        fontFamily: 'ElMessiri',
      ),
    );
  }

  bool obsText = true;
  bool isUsernameExists = false;

  Widget _buildInputField(TextEditingController controller,
      {isPassword = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'كلمة المرور',
        labelStyle: TextStyle(
          fontFamily: 'ElMessiri',
        ),
        contentPadding: EdgeInsets.all(12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            obsText ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              obsText = !obsText;
            });
          },
        )
            : null,
      ),
      obscureText: isPassword && obsText,
    );
  }

  Widget _buildRememberForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
                value: rememberUser,
                onChanged: (value) {
                  setState(() {
                    rememberUser = value!;
                  });
                }),
            _buildGreyText("تذكرني "),
          ],
        ),
        TextButton(
            onPressed: () {}, child: _buildGreyText("لقد نسيت كلمة المرور"))
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        login(UserController.text, passwordController.text);
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 20,
        shadowColor: myColor,
        minimumSize: const Size.fromHeight(60),
      ),
      onLongPress: () {
        _showPopupForIP(context);
      },
      child:   const Text(
            "دخول",
            style: TextStyle(
              fontFamily: 'ElMessiri',
            ),
      )
     ,
    );
  }

  Widget _buildOtherLogin() {
    return Center(
        child: Column(
          children: [
            _buildGreyText("تابعنا للمزيد"),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Tab(icon: Image.asset("images/facebook.png")),
                Tab(icon: Image.asset("images/twitter.png")),
                Tab(icon: Image.asset("images/google.png")),
              ],
            ),
            SizedBox(
              height: 40,
            )
          ],
        ));
  }

  Future<void> login(String username, String password) async {
    await Account.login(username, password,
            (account, accountResult) => onResultLogin(account, accountResult));
  }

  Future<void> onResultLogin(
      Account account, AccountResult accountResult) async {
    if (accountResult == AccountResult.failedProcess) {
      Fluttertoast.showToast(
          msg: "لايوجد اتصال بالشبكة",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 0,
          backgroundColor: mysColor,
          textColor: Colors.white,
          fontSize: 12.0);
    } else if (accountResult == AccountResult.wrongUsernameOrPassword) {
      Fluttertoast.showToast(
          msg: "خطا في اسم المستخدم او كلمة المرور",
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 0,
          backgroundColor: mysColor,
          textColor: Colors.white,
          fontSize: 12.0);
    } else if (accountResult == AccountResult.successfully) {
      if (account.isEmployee) {
        Employee employee = await Employee.byID(account.userID);
        showEmployee(employee);
      }
    }
  }

  void showEmployee(Employee employee) {
    if (employee == Employee.emptyEmployee) {
      Fluttertoast.showToast(
        msg: "خطا غير معروف",
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 0,
        backgroundColor: mysColor,
        textColor: Colors.white,
        fontSize: 12.0,
        toastLength: Toast.LENGTH_SHORT,
      );

      return;
    }
    Provider.of<Employee>(context, listen: false).updateEmployee(employee);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Dashborad()));
  }

  void showParent(Account account) {}

  void _showPopupForIP(BuildContext context) {

    final TextEditingController textEditingController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter base URL'),
          content: TextField(
            controller: textEditingController,
            decoration: const InputDecoration(
                labelText: 'URL or IP', hintText: 'Example: 192.168.1.111'),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                final text = textEditingController.text;
                if (Settings.settings.containsKey('ip')) {
                  Settings.settings['ip'] = text;
                  Settings.saveSettings();
                }
                Navigator.of(context).pop(); // Close the pop-up
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    textEditingController.text = Settings.settings.containsKey('ip') ? Settings.settings['ip'] : "";
  }




}

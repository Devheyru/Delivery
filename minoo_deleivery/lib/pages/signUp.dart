import 'package:flutter/material.dart';
import 'package:minoo_deleivery/pages/home.dart';
import 'package:minoo_deleivery/services/widgit_support.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              padding: EdgeInsets.only(top: 30),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xaa6f6f6f),
                // 0xaa6f6f6f
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => Home()),
                            (route) => false,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          height: 40,

                          padding: EdgeInsets.all(5),
                          child: Icon(
                            Icons.arrow_back,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: MediaQuery.of(context).size.height * 0.24,
                      width: MediaQuery.of(context).size.width / 2,
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 3.2,
                left: 20.0,
                right: 20.0,
              ),
              child: Material(
                borderRadius: BorderRadius.circular(20.0),

                elevation: 3.0,
                child: Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.65,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.0),
                        Center(
                          child: Text(
                            "SignUp",
                            style: AppWidget.leadingTextStyle(),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text('Name:', style: AppWidget.signUpTextStyle()),
                        SizedBox(height: 5.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFececf8),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter name",
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text('Email:', style: AppWidget.signUpTextStyle()),

                        SizedBox(height: 5.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFececf8),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter email",
                              prefixIcon: Icon(Icons.mail_outline),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text('Password:', style: AppWidget.signUpTextStyle()),

                        SizedBox(height: 5.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFececf8),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter password",
                              prefixIcon: Icon(Icons.password_outlined),
                            ),
                          ),
                        ),
                        SizedBox(height: 30.0),
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            height: MediaQuery.of(context).size.height / 18,
                            decoration: BoxDecoration(
                              color: Color(0xfff59e0b),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "SignUp",
                                style: AppWidget.whiteBoldTextFieldStyle(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
                              style: AppWidget.simpleOnboardingTextStyle(),
                            ),
                            TextButton(
                              isSemanticButton: false,
                              onPressed: () {
                                Navigator.pushNamed(context, '/logIn');
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

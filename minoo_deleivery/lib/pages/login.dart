import 'package:flutter/material.dart';
import 'package:minoo_deleivery/pages/signUp.dart';
import 'package:minoo_deleivery/services/widgit_support.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                color: const Color(0xaa6f6f6f),
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
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/home',
                            (Route<dynamic> route) =>
                                false, // remove ALL previous routes
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          height: 40,

                          padding: EdgeInsets.all(5),
                          child: const Icon(
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
                top: MediaQuery.of(context).size.height / 3.3,
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
                        const SizedBox(height: 20.0),
                        Center(
                          child: Text(
                            "LogIn",
                            style: AppWidget.leadingTextStyle(),
                          ),
                        ),

                        const SizedBox(height: 10.0),
                        Text('Email:', style: AppWidget.signUpTextStyle()),

                        const SizedBox(height: 5.0),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFececf8),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: TextField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter email",
                              prefixIcon: Icon(Icons.mail_outline),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Text('Password:', style: AppWidget.signUpTextStyle()),

                        const SizedBox(height: 5.0),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFececf8),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: TextField(
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter password",
                              prefixIcon: Icon(Icons.password_outlined),
                            ),
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              isSemanticButton: false,
                              onPressed: () {},
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            height: MediaQuery.of(context).size.height / 18,
                            decoration: BoxDecoration(
                              color: const Color(0xfff59e0b),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "LogIn",
                                style: AppWidget.whiteBoldTextFieldStyle(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account?',
                              style: AppWidget.simpleOnboardingTextStyle(),
                            ),
                            TextButton(
                              isSemanticButton: false,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Signup(),
                                  ),
                                );
                              },
                              child: Text(
                                'SignUp',
                                style: const TextStyle(
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

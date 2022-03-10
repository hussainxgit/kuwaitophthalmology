import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import '/services/api_services.dart';
import '/views/auth/sign_up_view.dart';

import '../../widgets/custom_messages.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final ApiServices _apiServices = ApiServices();

  final TextEditingController _email = TextEditingController();

  String? _emailError;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(
                          height: 50,
                        ),
                        const Text(
                          "Don't worry,",
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          "Lost your password ?, Hussain got your back ;)",
                          style: TextStyle(
                              fontSize: 20, color: Colors.grey.shade400),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),
                    Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _email,
                          decoration: InputDecoration(
                            errorText: _emailError,
                            labelText: "Email ID",
                            labelStyle: TextStyle(
                                fontSize: 14, color: Colors.grey.shade400),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                )),
                          ),
                        ),
                        const SizedBox(
                          height: 46,
                        ),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: (isLoading) ? null : () => submit(),
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                      const EdgeInsets.all(0)),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              )),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [Colors.lightBlue, Colors.blueAccent],
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                constraints: const BoxConstraints(
                                    minHeight: 50, maxWidth: double.infinity),
                                child: (isLoading)
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 1.5,
                                        ))
                                    : const Text(
                                        "Forgot Password",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => const SignupPage());
                          },
                          child: GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: const Text(
                              "Go Back",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  submit() {
    _apiServices.userForgotPassword(_email.text).then((value) {
      setState(() {
        isLoading = true;
      });
      setState(() {
        if (value.onError && value.errorCode == 'user-not-found') {
          _emailError = "Couldn't find your email, Please check your email";
        } else if (value.onError && value.errorCode == 'user-disabled') {
          _emailError =
              "Your account has been disabled, Please contact Mr.Hussain.";
        } else if (value.onError && value.errorCode == 'invalid-email') {
          _emailError = "Invalid email, Please check your email.";
        } else if (value.onSuccess) {
          showCustomSnackBar(
              context, 'Rest password email sent, please check your email');
          Get.back();
        }
      });
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _email.dispose();
  }
}

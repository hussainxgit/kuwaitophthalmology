import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';
import '/services/data_services.dart';
import '/views/auth/forgot_password.dart';
import '/views/auth/sign_up_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final DataServices _dataServices = Get.find();

  final TextEditingController _email = TextEditingController();

  final TextEditingController _password = TextEditingController();

  String? _emailError;

  String? _passwordError;

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
                          "Welcome,",
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          "Sign in to continue!",
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
                          height: 16,
                        ),
                        TextFormField(
                          controller: _password,
                          decoration: InputDecoration(
                            errorText: _passwordError,
                            labelText: "Password",
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
                          height: 12,
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => const ForgotPassword());
                            },
                            child: const Text(
                              "Forgot Password ?",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
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
                                        "Sign in",
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => const SignupPage());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Text(
                              "I'm a new user.",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Sign up",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            )
                          ],
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

  submit() async {
    setState(() {
      isLoading = true;
    });
    _dataServices.signInUser(_email.text, _password.text).then((value) {
      setState(() {
        if (value.onError && value.errorCode == 'user-not-found') {
          _emailError = "We couldn't find this email, Please check your email.";
        }
        if (value.onError && value.errorCode == 'invalid-email') {
          _emailError = "Invalid email, Please check your email.";
        }
        if (value.onError && value.errorCode == 'user-disabled') {
          _emailError =
              "Your account has been disabled, Please contact Mr.Hussain.";
        }
        if (value.onError && value.errorCode == 'wrong-password') {
          _passwordError =
              "Wrong password, if you don't remembering it you can rest it.";
        }
      });
      setState(() {
        isLoading = false;
      });
      if (value.onSuccess) {
        Get.back();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _email.dispose();
    _password.dispose();
  }
}

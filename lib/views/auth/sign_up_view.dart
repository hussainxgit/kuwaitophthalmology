import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import '/models/doctor_user.dart';
import '/services/data_services.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _email = TextEditingController();

  final TextEditingController _password = TextEditingController();

  final TextEditingController _residencyYear = TextEditingController();

  final TextEditingController _name = TextEditingController();

  final TextEditingController _phone = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final DataServices _dataServices = DataServices();

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
                        "Create Account,",
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Sign up to get started !",
                        style: TextStyle(
                            fontSize: 20, color: Colors.grey.shade400),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: "Full Name",
                            labelStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w600),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: _email,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Email ID",
                            labelStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w600),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: _phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: "Phone",
                            labelStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w600),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: _residencyYear,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your residency year';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Residency year",
                            labelStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w600),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: _password,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 in length';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w600),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          height: 50,
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
                                        "Sign up",
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          "I'm already a member.",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: const Text(
                            "Sign in.",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      _dataServices
          .signUpUser(
              DoctorUser(
                  name: _name.text,
                  email: _email.text,
                  phone: _phone.text,
                  roles: ['resident'],
                  rotationYear: 'R' + _residencyYear.text),
              _password.text)
          .whenComplete(() => Get.back());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _residencyYear.dispose();
    _password.dispose();
  }
}

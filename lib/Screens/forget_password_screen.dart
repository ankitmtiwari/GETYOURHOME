import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_your_home/services/authentication_services.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

  bool _isLoading=false;

  final _resetPasswordFormKey = GlobalKey<FormState>();

  final RegExp emailRegex = RegExp(r"""
^[r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]""");

  final TextEditingController _emailController = TextEditingController();

  User? user=FirebaseAuth.instance.currentUser;
  String? email;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    email=user?.email.toString();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forget Password"),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Form(
                key: _resetPasswordFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      textInputAction: TextInputAction.next,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (!emailRegex.hasMatch(value!)) {
                          return 'Please enter valid email';
                        }
                      },
                      decoration: InputDecoration(
                        // labelText: "Email",
                        hintText: "Please Enter Registered Email ID",
                        prefixIcon: const Icon(Icons.email),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0,),
                    MaterialButton(
                        height: MediaQuery.of(context).size.height * 0.06,
                        minWidth: MediaQuery.of(context).size.width * 0.3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child:  _isLoading==true?
                        const CircularProgressIndicator(color: Colors.white,):
                        const Text(
                          "Send Link",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        textColor: Colors.white,
                        color: Colors.green,
                        elevation: 5.0,
                        onPressed: () {
                          if (_resetPasswordFormKey.currentState!.validate()) {
                            setState(() {
                              _isLoading=!_isLoading;
                            });
                            String _email =
                            _emailController.text.toString().trim();
                            

                              Fluttertoast.showToast(msg: "Please Wait..");
                              Authentication().sendResetLink(_email).whenComplete(() => Navigator.pop(context));



                          }
                        })
                  ],
                ),

              ),
            ),
          ),
        ),
      ),
    );
  }
}

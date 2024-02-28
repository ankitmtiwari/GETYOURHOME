
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_your_home/Screens/authentication_screens/register_screen.dart';
import 'package:get_your_home/Screens/forget_password_screen.dart';
import 'package:get_your_home/services/authentication_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //login form key to access and validate form
  final _loginFormKey = GlobalKey<FormState>();

  //regular expression for validation of email format
  final RegExp emailRegex = RegExp(r"""
^[r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]""");

  //text controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //show / hide password
  bool _isObscure = true;

  //submitting or not . for showing progress circle
  bool _loginStarted = false;


  @override
  Widget build(BuildContext context) {

    //get the instance of the available device height and width
    double deviceHeight=MediaQuery.of(context).size.height;
    double deviceWidth=MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
              key: _loginFormKey,
              //autovalidateMode: AutovalidateMode.disabled,
              child: Padding(
                //Padding to the whole form/Column
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //App Logo on the top
                    Container(
                      color: Colors.white,
                      child: Image.asset(
                        'assets/GetYourHomeLogo.jpg',
                        height: deviceHeight * 0.5,
                        width: deviceWidth * 0.8,
                        alignment: Alignment.center,
                      ),
                      alignment: Alignment.center,
                    ),
                    
                    //Email Field
                    SizedBox(
                      //Size of the Email Field Box/Container
                      width: deviceWidth * 0.95,
                      height: deviceHeight * 0.1,
                      child: TextFormField(
                        controller: _emailController,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          //match with the standard email format regEx
                          if (!emailRegex.hasMatch(value!)) {
                            return 'Please enter valid email';
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Email",
                          prefixIcon: const Icon(Icons.email),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: deviceHeight * 0.001,
                    ),
                    
                    //Password Field
                    SizedBox(
                      //Size of the Password Field Box/Container
                      width: deviceWidth * 0.95,
                      height: deviceHeight * 0.1,
                      child: TextFormField(
                          controller: _passwordController,
                          textInputAction: TextInputAction.done,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return 'This field is required';
                            }
                            if (value.trim().length < 8) {
                              return 'Password must be at least 8 characters in length';
                            }
                            if (!value.contains(RegExp(r'[A-Z]'))) {
                              return 'Password must contain at least one character';
                            }
                            // Return null if the entered password is valid
                            return null;
                          },
                          obscureText: _isObscure,
                          style: const TextStyle(),
                          decoration: InputDecoration(
                            //  labelText: "Password",
                            hintText: "Password",
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                                icon: Icon(
                                  //if password is hidden then show open eye icon
                                    _isObscure ? Icons.visibility
                                    //if password is shown then show close eye icon
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    //change the state every time the eye icon clicked
                                    _isObscure = !_isObscure;
                                  });
                                }),

                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            //errorBorder: OutlineInputBorder(),
                          )),
                    ),
                    
                    //Center the Login Button
                    Center(
                      child: MaterialButton(
                        //Size of the Login Button
                          height: deviceHeight * 0.06,
                          minWidth: deviceWidth * 0.3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: 
                          //if the button is clicked and login is started then show the progress indicator
                        _loginStarted
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                        //if the login is not started then show the Login Text
                              : const Text(
                                  "Log In",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                          textColor: Colors.white,
                          color: Colors.black,
                          elevation: 5.0,
                          onPressed: () {
                            //if the login form is valid
                            //all input are valid 
                            if (_loginFormKey.currentState!.validate()) {
                              //then set login start as true
                              setState(() {
                                _loginStarted = true;
                              });

                              String _email =
                                  _emailController.text.toString().trim();
                              String _pass =
                                  _passwordController.text.toString().trim();

                              //call the Login Method
                              Authentication()
                                  .login(_email, _pass).then((value) => setState((){
                                    _loginStarted=false;
                              }));
                            }
                          }),
                    ),

                    //Create Account Text
                    Padding(
                      //padding to the text
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                          text: TextSpan(children: [
                        const TextSpan(
                            text: "Create New Account? ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            )),
                        TextSpan(
                            text: "Click here",
                            style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterPage()));
                              }),
                      ])),
                    ),

                    //Forget Password Text
                    Padding(
                      //padding to the text
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                          text: TextSpan(
                              children: [
                            TextSpan(
                                text: "Forget Password ?",
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const ForgetPassword()));
                                  }),
                          ])),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

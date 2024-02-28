import 'package:flutter/material.dart';
import 'package:get_your_home/Screens/BottomNavigationBarScreens/main_home_screen.dart';
import 'package:get_your_home/services/authentication_services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //form key here
  final _registerFormKey = GlobalKey<FormState>();

  //reg exp for validation
  final RegExp emailRegex = RegExp(r"""
^[r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]""");
  final RegExp nameRegex = RegExp(r"^[a-zA-z]{3}");
  final RegExp phoneRegex = RegExp(r'^[0-9]{10}$');

//text controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cnfPasswordController = TextEditingController();

  //show or hide password
  bool _isObscure = true;
  //password
  String _password = "";
  //submitting or not . for showing progress circle
  bool _registrationStarted=false;

  @override
  Widget build(BuildContext context) {

    //get the instance of the available device height and width
    double deviceHeight=MediaQuery.of(context).size.height;
    double deviceWidth=MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
              key: _registerFormKey,

              child: Padding(
                //Padding to the whole form
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // logo on the top
                    //first element in the column
                    Container(
                      color: Colors.white,
                      child: Image.asset(
                        'assets/GetYourHomeLogo.jpg',
                        height: deviceHeight * 0.25,
                        width: deviceWidth * 0.4,
                        alignment: Alignment.center,
                      ),
                      alignment: Alignment.center,
                    ),

                    //First name Text Field
                    SizedBox(
                      width: deviceWidth * 0.95,
                      height: deviceHeight * 0.1,
                      child: TextFormField(
                        controller: _firstNameController,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (!nameRegex.hasMatch(value!)) {
                            return 'Please Enter Valid Name';
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "First Name",
                          prefixIcon: const Icon(Icons.account_box),
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

                    //Last name Text Field
                    SizedBox(
                      width: deviceWidth * 0.95,
                      height: deviceHeight * 0.1,
                      child: TextFormField(
                        controller: _lastNameController,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (!nameRegex.hasMatch(value!)) {
                            return 'Pleas Enter Valid Name';
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Last Name",
                          prefixIcon: const Icon(Icons.account_box),
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
                    //Phone Number Text Field
                    SizedBox(
                      width: deviceWidth * 0.95,
                      height: deviceHeight * 0.1,
                      child: TextFormField(
                        controller: _phoneController,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (!phoneRegex.hasMatch(value!)) {
                            return 'Please enter valid phone number';
                          }
                        },
                        decoration: InputDecoration(
                          // labelText: "Email",
                          hintText: "Phone no.",
                          prefixIcon: const Icon(Icons.call),
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
                    //E-mail Text Field
                    SizedBox(
                      width: deviceWidth * 0.95,
                      height: deviceHeight * 0.1,
                      child: TextFormField(
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
                    //Password Text Field
                    SizedBox(
                      width: deviceWidth * 0.95,
                      height: deviceHeight * 0.1,
                      child: TextFormField(
                          onChanged: (value) => _password = value,
                          controller: _passwordController,
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return 'This field is required';
                            }
                            if (value.trim().length < 8) {
                              return 'Password must be at least 8 characters in length';
                            }
                            if (!value.contains(RegExp(r'[a-zA-Z]'))) {
                              return 'Password must contain at least character';
                            }
                            // Return null if the entered password is valid
                            return null;
                          },
                          obscureText: _isObscure,
                          style: const TextStyle(),
                          decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: const Icon(Icons.vpn_key),
                            suffixIcon: IconButton(
                                icon: Icon(_isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
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
                    SizedBox(
                      height: deviceHeight * 0.001,
                    ),
                    //Confirm Password Text Field
                    SizedBox(
                      width: deviceWidth * 0.95,
                      height: deviceHeight * 0.1,
                      child: TextFormField(
                          controller: _cnfPasswordController,
                          textInputAction: TextInputAction.done,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: _isObscure,
                          validator: (value) {
                            if (_password != value) {
                              return 'Password and Confirm Password must be same';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Confirm Password",
                            prefixIcon: const Icon(Icons.vpn_key),
                            suffixIcon: IconButton(
                                icon: Icon(_isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
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
                    SizedBox(
                      height: deviceHeight * 0.001,
                    ),

                    //Center the Register Button
                    Center(
                      child: MaterialButton(
                        //Size of the Button
                          height: deviceHeight * 0.06,
                          minWidth: deviceWidth * 0.3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child:  _registrationStarted==true?
                              const CircularProgressIndicator(color: Colors.white,):
                          const Text(
                            "Register",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          textColor: Colors.white,
                          color: Colors.black,
                          elevation: 5.0,
                          onPressed: () {
                            if (_registerFormKey.currentState!.validate()) {
                              setState(() {
                                _registrationStarted=true;
                              });
                              String _email =
                                  _emailController.text.toString().trim().toLowerCase();
                              String _password =
                                  _passwordController.text.toString().trim();
                              String _fName =
                                  _firstNameController.text.toString().trim();
                              String _lName =
                                  _lastNameController.text.toString().trim();
                              String _phoneNo =
                                  _phoneController.text.toString().trim();

                              //Call the register Method
                              Authentication().register(_email, _password,_fName
                                  , _lName,_phoneNo).whenComplete(() => Navigator
                                  .pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const MainHomePage())
                              ));
                            }
                          }),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

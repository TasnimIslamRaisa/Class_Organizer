import 'package:class_organizer/models/user.dart';
import 'package:class_organizer/onboarding/get_start.dart';
import 'package:class_organizer/ui/Home_Screen.dart';
import 'package:class_organizer/ui/screens/auth/SignInScreen.dart';
import 'package:class_organizer/utility/unique.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../db/database_helper.dart';
import '../../../models/u_data.dart';
import '../../../preference/logout.dart';
import '../../../style/app_color.dart';
import '../../../utility/app_constant.dart';
import '../../widgets/background_widget.dart';
import 'package:uuid/uuid.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passWordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool showPassWord = false;
  bool registrationInProgress = false;
  String? selectedRole;
  int uType = 0;


@override
  void initState() {
    super.initState();
    checkLoginStatus();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        //BackgroundWidget
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child:  Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 120,
                  ),
                  Text(
                    "Join With Us",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "emailaddress@gmail.com",
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return "Enter Your Email ";
                      }
                      if (AppConstant.emailRegExp.hasMatch(value!) == false) {
                        return "Enter a valid email address";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: firstNameController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: "First Name",
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return "Enter Your First Name ";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: lastNameController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: "Last Name",
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return "Enter Your Last name ";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: mobileController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: "Mobile",
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return "Enter Your Phone Number ";
                      }
                      if (AppConstant.phoneRegExp.hasMatch(value!) ==
                          false) {
                        return "Enter a valid mobile number";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: passWordController,
                    obscureText: showPassWord == false,
                    decoration: InputDecoration(
                      hintText: "Password",
                      suffixIcon: IconButton(
                        onPressed: () {
                          showPassWord = !showPassWord;
                          if (mounted) {
                            setState(() {});
                          }
                        },
                        icon: Icon(showPassWord
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return "Enter Your Password ";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: showPassWord == false,
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showPassWord = !showPassWord;
                          });
                        },
                        icon: Icon(showPassWord
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return "Confirm Your Password ";
                      }
                      if (value != passWordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(
                    height: 16,
                  ),
                  DropdownButtonFormField<String>(

                    decoration: InputDecoration(
                      labelText: 'Sign Up As',
                      suffixStyle: const TextStyle(
                        color: AppColors.subtitleColor,
                      ),
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    items: const [
                      DropdownMenuItem(value: '3', child: Text('Student',)),
                      DropdownMenuItem(value: '2', child: Text('Teacher')),
                      DropdownMenuItem(value: '1', child: Text('Admin')),
                      // Add more departments as needed
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedRole = value;
                      });
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return "Select Any Option ";
                      }
                      // if (value != passWordController.text) {
                      //   return "Passwords do not match";
                      // }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  Visibility(
                    visible: !registrationInProgress,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formkey.currentState?.validate() ?? false) {
                          registerUser();
                        }
                      },
                      child: const Icon(Icons.arrow_right),
                    ),

                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  Center(
                    child: Column(
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textColor,
                                letterSpacing: 0.4),
                            text: "Have an account?",
                            children: [
                              TextSpan(
                                text: "  Sign-In",
                                style: const TextStyle(
                                  color: AppColors.primaryColor,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    onTabSignInButton();
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //),


          ),
        ),
      ),
    );
  }

  void onTabSignInButton() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context)=>const SignInScreen()),
        (route)=>false,
    );
  }

void showSnackBarMsg(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: const Duration(seconds: 2),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

  Future<void> registerUser() async {
    registrationInProgress = true;
    if (mounted) {
      setState(() {});
    }

    // sqlite

    User? existingUser = await DatabaseHelper().getUserByPhone(mobileController.text.trim());

  if (existingUser != null) {

    if (mounted) {
      showSnackBarMsg(context, 'User already registered');
    }
    registrationInProgress = false;
    if (mounted) {
      setState(() {});
    }
    return;
  }


var uuid = Uuid();

String uniqueId = Unique().generateUniqueID();

if(selectedRole=="3"){
  uType = 3;
}else if(selectedRole=="2"){
  uType = 2;
}else{
  uType = 1;
}

User newUser = User(
  uniqueid: uniqueId,
  uname: "${firstNameController.text.trim()} ${lastNameController.text.trim()}",
  phone: mobileController.text.trim(),
  pass: passWordController.text.trim(),
  email: emailController.text.trim(),
  userid: uuid.v4(),
  utype: uType,
  status: 1,
);

int result = await DatabaseHelper().insertUser(newUser);

    // Map<String, dynamic> requestInput = {
    //   "email": emailController.text.trim(),
    //   "firstName": firstNameController.text.trim(),
    //   "lastName": lastNameController.text.trim(),
    //   "mobile": mobileController.text.trim(),
    //   "password": passWordController.text,
    //   "photo": ""
    // };
    // NetworkResponse response =
    //     await NetworkCaller.postRequest(Urls.registration, body: requestInput);
    registrationInProgress = false;
    if (mounted) {
      setState(() {});
    }

  if (result > 0) {
    if (mounted) {
      showSnackBarMsg(context, 'Registration Successful');

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GetStart()),
        );
      }
    });

    }
    clearfield();
  } else {
    if (mounted) {
      showSnackBarMsg(context, 'Registration Failed');
    }
  }


    // if (response.isSuccess) {
    //   if (mounted) {
    //     showSnackBarMsg(context, 'Registration Successful');
    //   }
    //   clearfield();
    // } else {
    //   if (mounted) {
    //     showSnackBarMsg(context, 'Registration Failed');
    //   }
    // }
  }

  void clearfield() {
    emailController.clear();
    firstNameController.clear();
    lastNameController.clear();
    mobileController.clear();
    passWordController.clear();
  }

void checkLoginStatus() async {

  bool isLoggedIn = await Logout().isLoggedIn();

  if (isLoggedIn) {

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  } else {
    // User is not logged in, stay on the sign-in screen
  }
}

  @override
  void dispose() {
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    mobileController.dispose();
    passWordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}

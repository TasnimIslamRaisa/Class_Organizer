import 'dart:async';
import 'dart:convert';
import 'package:class_organizer/models/user.dart' as local;
import 'package:class_organizer/onboarding/get_start.dart';
import 'package:class_organizer/ui/Home_Screen.dart';
import 'package:class_organizer/ui/screens/auth/SignInScreen.dart';
import 'package:class_organizer/utility/unique.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../../db/database_helper.dart';
import '../../../models/school.dart';
import '../../../preference/logout.dart';
import '../../../style/app_color.dart';
import '../../../utility/app_constant.dart';
import '../../../web/internet_connectivity.dart';
import '../../widgets/background_widget.dart';
import 'package:uuid/uuid.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

final _auth = FirebaseAuth.instance;
final _databaseRef = FirebaseDatabase.instance.ref();
  

  List<School> _schoolList = [
    School(sName: 'University of Chittagong',sId: "1111"),
    School(sName: 'Chittagong Independent University'),
    School(sName: 'East Delta University'),
    School(sName: 'University of Creative Technology Chittagong'),
    School(sName: 'University Of Science & Technology Chattogram (USTC)'),
    School(sName: 'Asian University for Women'),
    School(sName: 'Port City International University'),
    School(sName: 'International Islamic University Chittagong'),
    School(sName: 'Southern University Bangladesh'),
    School(sName: 'Premier University, Chittagong'),
    School(sName: 'Chittagong University of Engineering and Technology (CUET)'),
    School(sName: 'Chattogram Veterinary and Animal Sciences University'),
    School(sName: 'Chattogram Medical University BITID'),
    School(sName: 'Institute of Education and Research (IER)'),
    School(sName: 'Rangamati Science & Technology University'),
    School(sName: 'Noakhali Science and Technology University'),
    School(sName: 'Comilla University'),
    School(sName: 'Chandpur Science and Technology University'),
    School(sName: 'Chattogram Cantonment Public College'),
    School(sName: 'Chittagong College'),
    School(sName: 'Government College of Commerce, Chattogram'),
    School(sName: 'Govt. Hazi Muhammad Mohsin College, Chattogram'),
    School(sName: 'Hazera-Taju Degree College'),
    School(sName: 'Agrabad Mohila College'),
    School(sName: 'Government City College, Chattogram'),
    School(sName: 'Chittagong Government Model School and College'),
    School(sName: 'Ispahani Public School and College'),
    School(sName: 'Islamia College, Chattogram'),
    School(sName: 'Omargani M.E.S. University College'),
    School(sName: 'National University, Bangladesh'),
    School(sName: 'North South University'),
    School(sName: 'BRAC University'),
  ];

  bool _isLoading = true;
  School? _selectedSchool;


  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passWordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController autoCompleteController = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  bool showPassWord = false;
  bool registrationInProgress = false;
  String? selectedRole;
  int uType = 0;


  bool isConnected = false;
  late StreamSubscription subscription;
  final internetChecker = InternetConnectivity();
  StreamSubscription<InternetConnectionStatus>? connectionSubscription;
  
  String? sId = "";

@override
  void initState() {
    super.initState();
    checkLoginStatus();
   _loadSchoolData();
   
    startListening();
    checkConnection();
    subscription = internetChecker.checkConnectionContinuously((status) {
      setState(() {
        isConnected = status;
      });
    });

  }

  void checkConnection() async {
    bool result = await internetChecker.hasInternetConnection();
    setState(() {
      isConnected = result;
    });
  }


    StreamSubscription<InternetConnectionStatus> checkConnectionContinuously() {
      return InternetConnectionChecker().onStatusChange.listen((InternetConnectionStatus status) {
        if (status == InternetConnectionStatus.connected) {
          isConnected = true;
          print('Connected to the internet');
           _loadSchoolData();
        } else {
          isConnected = false;
          print('Disconnected from the internet');
          // _loadSchoolData();
        }
      });
    }

    void startListening() {
      connectionSubscription = checkConnectionContinuously();
    }

    void stopListening() {
      connectionSubscription?.cancel();
    }

   Future<void> _loadSchoolData() async {

        if(await InternetConnectionChecker().hasConnection){
              setState(() {
          _isLoading = true;
        });
        
        DatabaseReference schoolRef = _databaseRef.child('schools');

        schoolRef.once().then((DatabaseEvent event) {
          final dataSnapshot = event.snapshot;

          if (dataSnapshot.exists) {
            final Map<dynamic, dynamic> schoolsData = dataSnapshot.value as Map<dynamic, dynamic>;

            setState(() {
              _schoolList = schoolsData.entries.map((entry) {
                Map<String, dynamic> schoolMap = {
                  'sName': entry.value['sName'],
                  'sId': entry.value['sId']
                };
                return School.fromMap(schoolMap);
              }).toList();
              _isLoading = false;
            });
          } else {
            print('No school data available.');
            setState(() {
              _isLoading = false;
            });
          }
        }).catchError((error) {
          print('Failed to load school data: $error');
          setState(() {
            _isLoading = false;
          });
        });
    }else{
          setState(() {
            _isLoading = true;
          });
      showSnackBarMsg(context, "You are in Offline mode now, Please, connect Internet!");
          setState(() {
            _isLoading = false;
          });
     final String response = await rootBundle.loadString('assets/schools.json');
     final data = json.decode(response) as List<dynamic>;
     setState(() {
       _schoolList = data.map((json) => School.fromJson(json)).toList();
       _isLoading = false;
     });
    }


   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        //BackgroundWidget
        child: _isLoading 
        ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
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

                  // CustomAutoCompleteDropdownField(
                  //   hintText: "Search School here...",
                  //   suggestions: ['Apple', 'Banana', 'Cherry', 'Date', 'Elderberry'],
                  //   controller: autoCompleteController,
                  // ),
                  DropdownSearch<School>(
                    items: _schoolList,
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: 'Select School/College',
                        prefixIcon: Icon(Icons.school),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    onChanged: (School? selected) {
                      setState(() {
                        _selectedSchool = selected;
                        sId = _selectedSchool!.sId;
                      });
                    },
                    selectedItem: _selectedSchool,
                    popupProps: PopupProps.menu(
                      showSearchBox: true, // Enables the search box
                      itemBuilder: (context, item, isSelected) => ListTile(
                        title: Text(item.sName!),
                        //subtitle: Text("sId: ${item.sId}"),
                      ),
                    ),
                    dropdownBuilder: (context, selectedItem) {
                      return Text(selectedItem?.sName ?? "No School Selected");
                    },
                  ),
                  
                    if (_selectedSchool != null)
                    // Text(
                    //   "Selected School: ${_selectedSchool!.sName}, sId: ${_selectedSchool!.sId}",
                    //   style: TextStyle(fontSize: 16),
                    // ),
                  

                  const SizedBox(
                    height: 8,
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


      var uuid = Uuid();

      String uniqueId = Unique().generateUniqueID();

      if(selectedRole=="3"){
        uType = 3;
      }else if(selectedRole=="2"){
        uType = 2;
      }else{
        uType = 1;
      }



    if(await InternetConnectionChecker().hasConnection){

          try {

              List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(emailController.text.trim());

              if (signInMethods.isNotEmpty) {
                showSnackBarMsg(context, 'Email is already registered.');
                return;
              }

              DatabaseReference usersRef = _databaseRef.child("users");
              DatabaseEvent event = await usersRef.orderByChild("phone").equalTo(mobileController.text.trim()).once();
              DataSnapshot snapshot = event.snapshot;

              if (snapshot.exists) {
                showSnackBarMsg(context, 'Phone number is already registered.');
                return;
              }

          UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passWordController.text.trim(),
          );

          User? firebaseUser = userCredential.user;

          if (firebaseUser != null) {

                  local.User newUser = local.User(
                    uniqueid: uniqueId,
                    sid: sId,
                    uname: "${firstNameController.text.trim()} ${lastNameController.text.trim()}",
                    phone: mobileController.text.trim(),
                    pass: passWordController.text.trim(),
                    email: emailController.text.trim(),
                    userid: firebaseUser.uid,
                    utype: uType,
                    status: 1,
                  );

            await _databaseRef.child("users").child(firebaseUser.uid).set(newUser.toMap());

            print("User successfully signed up and saved to database");

          }
        } catch (e) {
          print("Signup failed: $e");
        }

    }

                  // sqlite

              local.User? existingUser = await DatabaseHelper().getUserByPhone(mobileController.text.trim());

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

                    local.User newUser = local.User(
                      uniqueid: uniqueId,
                      sid: sId,
                      uname: "${firstNameController.text.trim()} ${lastNameController.text.trim()}",
                      phone: mobileController.text.trim(),
                      pass: passWordController.text.trim(),
                      email: emailController.text.trim(),
                      userid: uuid.v4(),
                      utype: uType,
                      status: 1,
                    );

              int result = await DatabaseHelper().insertUser(newUser);


                  registrationInProgress = false;
                  if (mounted) {
                    setState(() {});
                  }

                if (result > 0) {
                  if (mounted) {
                    showSnackBarMsg(context, 'Registration Successful');

                  Future.delayed(const Duration(seconds: 1), () {
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


  // Custom Dropdown displayed when item is selected
  Widget _customDropDown(BuildContext context, School? item) {
    if (item == null) {
      return Text("No School Selected", style: TextStyle(color: Colors.grey));
    }
    return ListTile(
      leading: Icon(Icons.school, color: Colors.blue),
      title: Text(item.sName!, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("sId: ${item.sId}"),
    );
  }

  // Custom Popup item in the dropdown list
  Widget _customPopupItemBuilder(BuildContext context, School item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: isSelected ? Colors.blue : Colors.transparent),
        borderRadius: BorderRadius.circular(5),
        color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
      ),
      child: ListTile(
        leading: Icon(Icons.school),
        title: Text(item.sName!),
        subtitle: Text("sId: ${item.sId}"),
      ),
    );
  }




  @override
  void dispose() {
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    mobileController.dispose();
    passWordController.dispose();
    confirmPasswordController.dispose();

    stopListening();
    subscription.cancel();
    super.dispose();
  }
}
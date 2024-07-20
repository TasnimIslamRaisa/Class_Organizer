import 'package:class_organizer/preference/preferences.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

late bool _passwordVisible = false;

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
  
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
  
}

class LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    preference();
        _passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SafeArea(
          child: Scaffold(
        backgroundColor: Colors.blue,
        body: ListView(
          children: [
            const SizedBox(
              height: 2,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Container(
                    child: Lottie.asset(
                      'animation/edu1.json',
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height / 2.2,
                      reverse: true,
                      repeat: true,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Hi!",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        " Student",
                        style: TextStyle(
                            fontSize: 33,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    "Sign in to Continiue.",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2.4,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60)),
                      ),
                      child: Column(
                        children: [
                          Form(
                            key: _formKey,
                              child: Column(
                            children: [
                              const SizedBox(
                                height: 45,
                              ),
                              TextFormField(
                                textAlign: TextAlign.start,
                                keyboardType: TextInputType.phone,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                ),
                                decoration: const InputDecoration(
                                  labelText: "Mobile Number / Email",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  isDense: true,
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    height: 0.5,
                                  ),
                                  hintStyle: TextStyle(
                                    fontSize: 17,
                                    color: Colors.yellow,
                                    height: 0.7,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 0.7,
                                  )),
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Colors.black,
                                  )),
                                  disabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Colors.black,
                                  )),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 0.7,
                                  )),
                                  errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Color.fromARGB(255, 146, 24, 24),
                                    width: 1.2,
                                  )),
                                  focusedErrorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Color.fromARGB(255, 146, 24, 24),
                                    width: 1.2,
                                  )),
                                ),
                                validator: (value) {
                                  RegExp regExp = new RegExp(
                                      r'^\+?(\d{1,3})?[-. \(\)]?(\d{1,4})?[-. \(\)]?\d{1,4}[-. ]?\d{1,4}[-. ]?\d{1,9}$');
                                  if(value==null|| value.isEmpty){
                                    return "Please enter your mobile number...";
                                  }else if(!regExp.hasMatch(value)){
                                    return "Pleasel enter a valid phone number..";
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              TextFormField(
                                obscureText: _passwordVisible,
                                textAlign: TextAlign.start,
                                keyboardType: TextInputType.visiblePassword,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                ),
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  isDense: true,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                    icon: Icon(_passwordVisible
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_off_outlined),
                                    iconSize: 20,
                                  ),
                                  labelStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    height: 0.5,
                                  ),
                                  hintStyle: const TextStyle(
                                    fontSize: 17,
                                    color: Colors.yellow,
                                    height: 0.7,
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 0.7,
                                  )),
                                  border: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Colors.black,
                                  )),
                                  disabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Colors.black,
                                  )),
                                  focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 0.7,
                                  )),
                                  errorBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Color.fromARGB(255, 146, 24, 24),
                                    width: 1.2,
                                  )),
                                  focusedErrorBorder:
                                      const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                    color: Color.fromARGB(255, 146, 24, 24),
                                    width: 1.2,
                                  )),
                                ),
                                validator: (value) {
                                  
                                },
                              ),
                              const SizedBox(height: 18,),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: InkWell(
                                  onTap: (){
                                    if(_formKey.currentState!.validate()){
                                      
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 10,right: 10),
                                    padding: EdgeInsets.only(right: 18),
                                    width: double.infinity,
                                    height: 50.0,
                                    decoration:  BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Colors.blue,Colors.amber],
                                        begin: FractionalOffset(0.4, 0.3),
                                        end: FractionalOffset(0.7, 0.0),
                                        stops: [0.0,1.8],
                                        tileMode: TileMode.clamp,
                                  
                                      ),
                                      borderRadius: BorderRadius.circular(30)
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                      Spacer(),
                                      Text("Sign In",style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500,
                                        
                                      ),),
                                      Spacer(),
                                      Icon(Icons.arrow_forward_outlined,size: 30,color: Colors.white,),
                                    ],),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10,),
                              const Align(
                                alignment: Alignment.bottomRight,
                                child: Text("Forgot Password",style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                ),textAlign: TextAlign.end,),
                              )
                            ],
                          ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
  
  preference() async {
      if(await Preferences.checkInstalled()){
        print("Installed");
      }else{
        print("Not Installed");
      }
  }
}
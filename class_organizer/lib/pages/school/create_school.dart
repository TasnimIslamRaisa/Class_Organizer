import 'package:class_organizer/admin/panel/admin_panel.dart';
import 'package:class_organizer/db/database_helper.dart';
import 'package:class_organizer/pages/login/admin_login.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../../models/school.dart';
import 'package:uuid/uuid.dart';

import '../../models/user.dart';
import '../../preference/logout.dart';
import '../../utility/unique.dart';

class CreateSchool extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateSchoolState();
  }
}

class CreateSchoolState extends State<CreateSchool> {
  User? _user, _user_data;
  final _formKey = GlobalKey<FormState>();
  String? sid;
  School? school;

  final balanceController = TextEditingController();
  final urlController = TextEditingController();
  final schoolName = TextEditingController();
  final schoolPhone = TextEditingController();
  final schoolAddress = TextEditingController();
  final schoolEmail = TextEditingController();
  final schoolPassword = TextEditingController();
  final schoolEiin = TextEditingController();
  final schoolItEmail = TextEditingController();
  final schoolTrx = TextEditingController();


  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    Logout logout = Logout();
    User? user = await logout.getUserDetails(key: 'user_data');
    Map<String, dynamic>? userMap = await logout.getUser(key: 'user_logged_in');
    User user_data = User.fromMap(userMap!);
    setState(() {
      _user = user;
      _user_data = user_data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFc1e2ff),
        elevation: 0,
        toolbarHeight: 50.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrZfe9fcdM0-kufy411mFjWm7PoCbzkV9iWA&s',
                  width: 150,
                  height: 150,
                ),
              ),
              SizedBox(height: 20),
              // Title Text
              Center(
                child: Text(
                  'Create School',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(height: 30),
              // Text Fields
              CustomTextField(hintText: 'School Name',controller: schoolName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter school ';
                  }
                  return null;
                },
              ),
              CustomEmailField(hintText: 'School Email',controller: schoolEmail,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              CustomPhoneField(hintText: 'Phone Number',controller: schoolPhone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
                  if (!phoneRegex.hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              CustomPasswordField(hintText: 'Password',controller: schoolPassword,
              
              ),
              CustomTextField(hintText: 'School Address',controller: schoolAddress,
              
              ),
              CustomTextField(hintText: 'EIIN No',controller: schoolEiin,
              
              ),
              CustomEmailField(hintText: 'IT Email',controller: schoolItEmail,
              
              ),
              CustomURLField(hintText: 'Website Url',controller: urlController,),
              // CustomTextField(hintText: 'IT Phone One'),
              CustomBalanceTkField(
                hintText: "Enter your balance",
                controller: balanceController,
              ),
              CustomTextField(hintText: 'Trx Number',controller: schoolTrx,
              
              ),
              SizedBox(height: 20),
              // Submit Button
              Center(
                child: customButton(
                  label: 'Submit',
                  onPressed: () {
                    
                  // if (_formKey.currentState?.validate() ?? false) {
                    
                    saveSchool();

                  // }

                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Shortcut function to generate custom styled buttons
  Widget customButton(
      {required String label, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // Button color
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

void showSnackBarMsg(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: const Duration(seconds: 2),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
  
void saveSchool() async {

  var uuid = Uuid();

  String uniqueId = Unique().generateUniqueID();

  final newSchool = School(


    sId: uuid.v4(),
    uniqueId: uniqueId,
    sName: schoolName.text,
    sEmail: schoolEmail.text,
    sPhone: schoolPhone.text,
    sPass: schoolPassword.text,
    sAdrs: schoolAddress.text,
    sEiin: schoolEiin.text,
    sItEmail: schoolItEmail.text,
    sWeb: urlController.text,
    sFundsBal: balanceController.text,
    sVerification: schoolTrx.text,
  );
  setState(() {
    school = newSchool;
    sid = newSchool.sId;
  });

  final result = await DatabaseHelper().insertSchool(newSchool);

  if (result > 0) {

    setUserSid(_user ??_user_data);

    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(content: Text('School saved successfully!')),
    );

    if (mounted) {
      setState(() {});
    }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AdminLogin(),
        ),
      );

  } else {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to save school')),
    );
  }
}

  Future<void> setUserSid(User? user) async {
  if (user != null) {

    int result = await DatabaseHelper().updateUser(user);
    
    if (result > 0){
      setState(() {
        _user = user;
        _user_data = user;
      });
      await Logout().clearUser(key: "user_logged_in", key_key: "user_data");
      await Logout().saveUser(user.toMap(), key: "user_logged_in");
      await Logout().saveUserDetails(user,key: "user_data");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User updated successfully')),
      );
    }

  } else {
    print("User is null.");
  }
  }

}



class CustomURLField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  const CustomURLField({
    Key? key,
    required this.hintText,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.url,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFf1e3b6),
          hintText: hintText,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          final urlPattern =
              r'^(https?:\/\/)?([\w\d\-]+\.)+\w{2,}(\/.*)?$';
          final isValidURL = RegExp(urlPattern).hasMatch(value ?? '');

          if (value == null || value.isEmpty) {
            return 'Please enter a valid URL';
          } else if (!isValidURL) {
            return 'Please enter a valid URL format';
          }
          return null;
        },
      ),
    );
  }
}


class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator; // Add validator parameter

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.validator, // Receive validator in the constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller, // Use the passed controller
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFf1e3b6),
          hintText: hintText,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator, // Use the passed validator
      ),
    );
  }
}

class CustomBalanceTkField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  const CustomBalanceTkField({
    Key? key,
    required this.hintText,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFf1e3b6),
          hintText: hintText,
          prefixText: 'Tk ',
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a valid balance';
          } else if (double.tryParse(value) == null) {
            return 'Please enter a valid number';
          } else if (double.parse(value) < 0) {
            return 'Balance cannot be negative';
          }
          return null;
        },
      ),
    );
  }
}


class CustomPasswordField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller; // Add controller parameter

  const CustomPasswordField({
    Key? key,
    required this.hintText,
    required this.controller,
  }) : super(key: key);

  @override
  _CustomPasswordFieldState createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: widget.controller, // Use the passed controller
        obscureText: _obscureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFf1e3b6),
          hintText: widget.hintText,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
      ),
    );
  }
}

class CustomPhoneField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller; // Controller for text input
  final String? Function(String?)? validator; // Validator function

  const CustomPhoneField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.validator, // Receive validator function
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller, // Use the passed controller
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFf1e3b6),
          hintText: hintText,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator, // Apply the validator function
      ),
    );
  }
}

class CustomEmailField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller; // Controller for text input
  final String? Function(String?)? validator; // Validator function

  const CustomEmailField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.validator, // Receive validator function
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller, // Use the passed controller
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFf1e3b6),
          hintText: hintText,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator, // Apply the validator function
      ),
    );
  }
}


class CustomAutoCompleteDropdownField extends StatefulWidget {
  final String hintText;
  final List<String> suggestions;
  final TextEditingController controller; // Add controller as a parameter

  const CustomAutoCompleteDropdownField({
    Key? key,
    required this.hintText,
    required this.suggestions,
    required this.controller, // Receive the controller
  }) : super(key: key);

  @override
  _CustomAutoCompleteDropdownFieldState createState() =>
      _CustomAutoCompleteDropdownFieldState();
}

class _CustomAutoCompleteDropdownFieldState
    extends State<CustomAutoCompleteDropdownField> {
  List<String> _filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    _filteredSuggestions = widget.suggestions;
  }

  void _filterSuggestions(String input) {
    setState(() {
      _filteredSuggestions = widget.suggestions
          .where((item) =>
              item.toLowerCase().contains(input.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            controller: widget.controller, // Use the passed controller
            onChanged: _filterSuggestions,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFf1e3b6),
              hintText: widget.hintText,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        if (_filteredSuggestions.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredSuggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_filteredSuggestions[index]),
                  onTap: () {
                    setState(() {
                      widget.controller.text = _filteredSuggestions[index];
                      _filteredSuggestions = [];
                    });
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}


class CustomFileChooserField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller; // Add controller as a parameter

  const CustomFileChooserField({
    Key? key,
    required this.hintText,
    required this.controller, // Receive the controller
  }) : super(key: key);

  @override
  _CustomFileChooserFieldState createState() => _CustomFileChooserFieldState();
}

class _CustomFileChooserFieldState extends State<CustomFileChooserField> {
  String? fileName;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        fileName = result.files.single.name;
        widget.controller.text = fileName!; // Update the controller with the selected file name
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: _pickFile,
        child: InputDecorator(
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFf1e3b6),
            hintText: widget.hintText,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          child: Text(
            fileName ?? widget.hintText,
            style: TextStyle(
              color: fileName == null ? Colors.grey : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

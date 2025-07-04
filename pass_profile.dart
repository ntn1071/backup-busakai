import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class ProfileScreenDriv extends StatefulWidget {
  final Function? onProfileImageUpdated; // Callback to notify the main screen
  final String userId; // Add the email parameter

  const ProfileScreenDriv({super.key, this.onProfileImageUpdated, required this.userId});

  @override
  _ProfileScreenDriv createState() => _ProfileScreenDriv();
}

class _ProfileScreenDriv extends State<ProfileScreenDriv> {
  // User data
  String fullName = '';
  String email = '';
  String mobile = '';
  String middleName = ''; // Middle Name
  String lastName = '';   // Last Name
  String extension = '';  // Extension
  String password = '';   // Password
  bool isEditable = false; // Controls field editability
  bool isPasswordVisible = false; // Controls password visibility

  // Controllers for text fields
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _extensionController = TextEditingController();
  final _passwordController = TextEditingController();

  // Profile picture
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load the user data from SharedPreferences
    _loadProfileImage(); // Load saved profile image if any
  }

  // Load user data from SharedPreferences using user_id
  _loadUserData() async {
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    

    String? userId = prefs.getString('user_id');
    setState(() {
      print('Loaded User Data: ${prefs.getKeys()}');
      print('User ID: ${widget.userId}');

      fullName = prefs.getString('${widget.userId}_userType_first_name') ?? ''; 
      
      print('First Name Value: ${prefs.getString('${userId}_userType_first_name')}');

      email = prefs.getString('${widget.userId}_userType_username') ?? '';
      mobile = prefs.getString('${widget.userId}_userType_user_phone') ?? '';
      middleName = prefs.getString('${widget.userId}_userType_middle_name') ?? '';
      lastName = prefs.getString('${widget.userId}_userType_last_name') ?? '';
      extension = prefs.getString('${widget.userId}_userType_user_extension') ?? '';
      password = prefs.getString('${widget.userId}_userType_password') ?? '';

// Initialize text controllers with the fetched data
      _fullNameController.text = fullName;
      _emailController.text = email;
      _mobileController.text = mobile;
      _middleNameController.text = middleName;
      _lastNameController.text = lastName;
      _extensionController.text = extension;
      _passwordController.text = password;
    });
    }

  // Load profile image from shared preferences
  _loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('${widget.userId}_profile_picture_path');
    if (imagePath != null) {
      setState(() {
        _profileImage = File(imagePath);
      });
    }
  }

  // Save profile image path in shared preferences
  _saveProfileImage(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('${widget.userId}_profile_picture_path', imagePath); // Corrected key
  }

  // Pick an image from gallery or camera
  _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      _saveProfileImage(pickedFile.path);

      // Notify the main screen (BusPassengerAppHome) to reload the profile image
      if (widget.onProfileImageUpdated != null) {
        widget.onProfileImageUpdated!(); // Call the callback to update the main screen
      }
    } else {
      // If the user cancels or fails to pick an image, you can handle it here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected')),
      );
    }
  }

  // Save user profile data
  Future<void> _saveUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    if (userId != null) {
       // Remove old email-related data

String newEmail = _emailController.text.toString();
      prefs.remove('${email}_user_id');
      prefs.remove('${newEmail}_user_id');
      prefs.remove('${widget.userId}_userType_username');
      prefs.remove('${widget.userId}_userType_password');
      prefs.remove('${widget.userId}_userType_first_name');
      prefs.remove('${widget.userId}_userType_last_name');
      prefs.remove('${widget.userId}_userType_middle_name');
      prefs.remove('${widget.userId}_userType_user_phone');
      prefs.remove('${widget.userId}_userType_user_extension');
      prefs.remove('${widget.userId}_profile_picture_path');
      

      prefs.setString('${newEmail}_user_id', widget.userId);
      prefs.setString('${widget.userId}_userType_first_name', fullName);
      prefs.setString('${widget.userId}_userType_username', newEmail);
      prefs.setString('${widget.userId}_userType_user_phone', mobile);
      prefs.setString('${widget.userId}_userType_middle_name', middleName);
      prefs.setString('${widget.userId}_userType_last_name', lastName);
      prefs.setString('${widget.userId}_userType_user_extension', extension);
      prefs.setString('${widget.userId}_userType_password', password);

      if (_profileImage != null) {
        prefs.setString('${widget.userId}_profile_picture_path', _profileImage!.path);
      }
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully.')),
    );
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _fullNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _extensionController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () {
              // Handle logout button press
              ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logged Out')),
                      );
                      Navigator.pushReplacementNamed(context, '/login'); // Adjust the route as needed
            },
          ),
          
        ],
         
        backgroundColor: const Color.fromARGB(255, 227, 234, 241),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Cover and Avatar
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 130,
                    margin: const EdgeInsets.symmetric(horizontal: 91),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 48, 84, 111),
                      borderRadius: BorderRadius.circular(80),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: MediaQuery.of(context).size.width / 2 - 70,
                    child: GestureDetector(
                      onTap: _pickImage, // Allow tapping to change the image
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.transparent,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : const AssetImage('assets/pass_pfp.png')
                                as ImageProvider,
                        child: _profileImage == null
                            ? const Icon(
                                Icons.person,
                                size: 80,
                                color: Color.fromARGB(255, 151, 199, 142),
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Profile Fields
              _buildProfileField('First Name', _fullNameController),
              _buildProfileField('Middle Name', _middleNameController),
              _buildProfileField('Last Name', _lastNameController),
              _buildProfileField(
                                    'Extension',
                                    _extensionController,
                                    dropdownItems: [' ','JR', 'SR.', 'III', 'IV'], // Add your dropdown items here
                                  ),
              _buildProfileField('Email Address', _emailController),
              _buildProfileField('Mobile Number', _mobileController),
              
              const SizedBox(height: 16),

              // Password Field with Show/Hide
              TextField(
                controller: _passwordController,
                enabled: isEditable,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: isEditable ? Colors.blue : Colors.grey,
                  ),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                ),
                style: TextStyle(
                  color: isEditable ? Colors.black : Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 16),

              // Edit/Save Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (isEditable) {
                        // Save updated info
                        fullName = _fullNameController.text;
                        email = _emailController.text;
                        mobile = _mobileController.text;
                        middleName = _middleNameController.text;
                        lastName = _lastNameController.text;
                        extension = _extensionController.text;
                        password = _passwordController.text;
                        _saveUserProfile();  // Save profile without going back
                      }
                      isEditable = !isEditable;
                    });
                  },
                  child: Text(isEditable ? 'Save' : 'Edit Profile'),
                ),
              ),

              const SizedBox(height: 32),

              
            ],
          ),
        ),
      ),
    );
  }

  // Method to build each profile field
  Widget _buildProfileField(String label, TextEditingController controller, {List<String>? dropdownItems}) {
  if (dropdownItems != null) {
    // Return a DropdownButtonFormField if dropdownItems are provided
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: controller.text.isNotEmpty ? controller.text : null,
        items: dropdownItems
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        onChanged: isEditable
            ? (value) {
                setState(() {
                  controller.text = value ?? '';
                });
              }
            : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: isEditable ? Colors.blue : Colors.grey,
          ),
          border: const OutlineInputBorder(),
        ),
        style: TextStyle(
          color: isEditable ? Colors.black : Colors.grey.shade600,
        ),
      ),
    );
  }

  // Return the regular TextField for other fields
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      controller: controller,
      enabled: isEditable,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isEditable ? Colors.blue : Colors.grey,
        ),
        border: const OutlineInputBorder(),
      ),
      style: TextStyle(
        color: isEditable ? Colors.black : Colors.grey.shade600,
      ),
    ),
  );
}

}
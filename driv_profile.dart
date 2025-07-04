import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreenDriv extends StatefulWidget {
  const ProfileScreenDriv({super.key});

  @override
  _ProfileScreenDriv createState() => _ProfileScreenDriv();
}

class _ProfileScreenDriv extends State<ProfileScreenDriv> {
  // Driver data
  String fullName = 'Driver Name';
  String username = 'driver_username';
  String email = 'driver@example.com';
  String mobile = '123-456-7890';
  String password = 'carlosp01';
  bool isEditable = false;
  bool _isPasswordVisible = false; // For toggling password visibility

  // Controllers for text fields
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadDriverProfile();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Load driver data from SharedPreferences
  Future<void> _loadDriverProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString('fullName') ?? fullName;
      username = prefs.getString('username') ?? username;
      email = prefs.getString('email') ?? email;
      mobile = prefs.getString('mobile') ?? mobile;
      
      _fullNameController.text = fullName;
      _usernameController.text = username;
      _emailController.text = email;
      _mobileController.text = mobile;
      _passwordController.text = password;

      String? imagePath = prefs.getString('profileImage');
      if (imagePath != null) {
        _profileImage = File(imagePath);
      }
    });
  }

  // Save driver data to SharedPreferences
  Future<void> _saveDriverProfile() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('fullName', fullName);
    prefs.setString('username', username);
    prefs.setString('email', email);
    prefs.setString('mobile', mobile);
    prefs.setString('password', password);

    if (_profileImage != null) {
      prefs.setString('profileImage', _profileImage!.path);
    }
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully.')),
    );
  }

  // Pick an image for the profile
  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('profileImage', _profileImage!.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Profile'),
        backgroundColor: const Color.fromARGB(255, 50, 109, 197),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the dashboard
            Navigator.pushReplacementNamed(context, '/driv_dashb'); // Adjust the route as needed
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Implement logout functionality (Navigate to login screen)
              Navigator.pushReplacementNamed(context, '/login'); // Adjust the route as needed
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
        color: const Color.fromARGB(255, 200, 225, 255),
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
                      onTap: _pickProfileImage, // Allow tapping to change the image
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.transparent,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : const AssetImage('assets/driv_pfp.png')
                                as ImageProvider,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Profile Fields
              _buildProfileField('Full Name', _fullNameController),
              _buildProfileField('Username', _usernameController),
              _buildProfileField('Email Address', _emailController),
              _buildProfileField('Mobile Number', _mobileController),
              _buildPasswordField('Password', _passwordController), // Modified for password toggle

              const SizedBox(height: 16),
              // Edit/Save Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (isEditable) {
                        // Save updated driver info
                        fullName = _fullNameController.text;
                        username = _usernameController.text;
                        email = _emailController.text;
                        mobile = _mobileController.text;
                        password = _passwordController.text;
                        _saveDriverProfile(); // Persist changes
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

  Widget _buildProfileField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        enabled: isEditable,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  // Password field with visibility toggle
  Widget _buildPasswordField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        enabled: isEditable,
        obscureText: !_isPasswordVisible, // Toggle visibility based on _isPasswordVisible
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible; // Toggle password visibility
              });
            },
          ),
        ),
      ),
    );
  }
}

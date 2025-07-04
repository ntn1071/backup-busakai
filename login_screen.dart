import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:busakai/screens/driv_main_dashb.dart';
import 'package:busakai/screens/main_dashb_passngr.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String userType = "Passenger";
  String id = "";
  bool _isPasswordVisible = false;

  // Controllers for text fields
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Function to login using SharedPreferences
  Future<void> _loginUser() async {
    final prefs = await SharedPreferences.getInstance();

    String inputUsername = usernameController.text.trim();
    String inputPassword = passwordController.text.trim();

    // Dummy account for the driver (just for testing purposes)
    if (userType == "Driver" && inputUsername == "carlosp@gmail.com" && inputPassword == "carlosp01") {
      // Successful login for driver dummy account
      prefs.setString('logged_in_userId', 'driver_id');
      prefs.setString('johndoe_driver_user_id', 'driver123'); // Dummy user ID
      prefs.setString('driver123@gmail.com_userType', 'Driver');
      prefs.setString('driver123@gmail.com_userType_username', 'johndoe_driver');
      prefs.setString('driver123@gmail.com_userType_password', 'password123');
      prefs.setString('driver123@gmail.com_userType_email', 'johndoe@busakai.com');
      prefs.setString('driver123@gmail.com_userType_mobile', '+639171234567');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DriverAppWithNavBar(), // Your Driver screen
        ),
      );
      return;
    }

    // Validate input fields
    if (inputUsername.isEmpty || inputPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both email and password.")),
      );
      return;
    }

    // Retrieve the associated userId based on the input username
    String? userId = prefs.getString('${inputUsername}_user_id');
    id = prefs.getString('${inputUsername}_user_id') ?? '';

    if (userId != null) {
      // Fetch saved credentials using userId
      String? savedPassword = prefs.getString('${userId}_userType_password');
      String? savedUserType = prefs.getString('${userId}_userType');
      String? savedUsername = prefs.getString('${userId}_userType_username');
      
      if (savedPassword != null && inputPassword == savedPassword && inputUsername == savedUsername) {
        // Successful login
        // Save the logged-in userId for future reference
        prefs.setString('logged_in_userId', userId);

        if (savedUserType == "Passenger") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BusPassengerAppHome(userId: userId),
            ),
          );
        } else if (savedUserType == "Driver") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DriverAppWithNavBar(),
            ),
          );
        }
      } else {
        // Invalid credentials
        ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text("Invalid credentials. Please try again.")),
        );
      }
    } else {
      // User not found
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No account found. Please sign up.")),
      );
    }
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.blue.shade700,
      title: const Text("Log In"),
      centerTitle: true,
    ),
    body: SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Dismiss the keyboard when tapping outside
        },
        child: Stack(
          children: [
            // Background Image
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/landin_bg.png"), // Your background image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Foreground content
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Glowing Bus Image
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.5),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        "assets/bus.png", // Your bus image path
                        height: 160,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  // User type dropdown
                  DropdownButton<String>(
                    value: userType,
                    isExpanded: true,
                    items: ["Passenger", "Driver"].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        userType = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  // Username TextField
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      filled: true,
                      fillColor: const Color.fromARGB(157, 32, 57, 72), // Gray background
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white, width: 2), // White border
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color.fromARGB(255, 58, 155, 252), width: 2), // White border when focused
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelStyle: const TextStyle(color: Color.fromARGB(255, 245, 245, 245)), // Optional: white label text
                        ),
                        style: const TextStyle(color: Color.fromARGB(255, 33, 151, 255)), // Input text color
                      ),
                  const SizedBox(height: 20),
                  // Password TextField
                  TextField(
                    controller: passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: "Password",
                      filled: true,
                      fillColor: const Color.fromARGB(157, 32, 57, 72), // Gray background
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white, width: 2), // White border
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color.fromARGB(255, 58, 155, 252), width: 2), // White border when focused
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          labelStyle: const TextStyle(color: Color.fromARGB(255, 245, 245, 245)), // Optional: white label text
                        ),
                        style: const TextStyle(color: Color.fromARGB(255, 33, 151, 255)), // Input text color
                      ),
                  const SizedBox(height: 20),
                  // Login Button
                  ElevatedButton(
                    onPressed: _loginUser,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Log In",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}
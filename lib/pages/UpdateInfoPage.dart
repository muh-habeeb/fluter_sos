import 'package:flutter/material.dart';
import 'package:pingme/utils/color_hexing.dart';

class UpdateInfoPage extends StatelessWidget {
  const UpdateInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Update Info',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ), // Title for the AppBar
        backgroundColor: "#4B39EF".toColor(), // Background color of the AppBar
      ),
      body: Container(
        color: Colors.white, // White background for the drawer
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 100), // Space from the top

            // Header Text
            const Text(
              'Update your details!',
              style: TextStyle(
                fontSize: 24, // Font size for the header
                fontWeight: FontWeight.bold, // Bold text
              ),
            ),
            const SizedBox(height: 20), // Space below the header

            // Circular Avatar
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Make the container circular
                border: Border.all(
                  color: const Color(
                      0xFF39D2C0), // Use ARGB format for the border color
                  width: 8, // Set the border width
                ),
              ),
              child: const CircleAvatar(
                radius: 100, // 200 x 200 means radius of 100
                backgroundImage:
                    NetworkImage('https://avatar.iran.liara.run/public/girl'),
                backgroundColor:
                    Colors.transparent, // Make the background transparent
              ),
            ),

            const SizedBox(height: 20), // Small space below the image

            // Name Input
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter your name',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: "#4B39EF".toColor()),
                  borderRadius: BorderRadius.circular(18),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: "#4B39EF".toColor()),
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              textAlign: TextAlign.center, // Center text
            ),
            const SizedBox(height: 10), // Small space between input boxes

            // Phone Number Input
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter the receiver phone number',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: "#4B39EF".toColor()),
                  borderRadius: BorderRadius.circular(18),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: "#4B39EF".toColor()),
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              textAlign: TextAlign.center, // Center text
            ),
            const SizedBox(height: 20), // Small space before the button

            // Submit Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: "#4B39EF".toColor(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize:
                    const Size(150, 50), // Width and height of the button
              ),
              onPressed: () {
                // Handle button press
              },
              child: const Text(
                'Submit',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  letterSpacing: 1.5, // Letter spacing
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

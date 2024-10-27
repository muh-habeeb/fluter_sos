import 'package:flutter/material.dart';
import 'package:pingme/pages/UpdateInfoPage.dart';
import 'package:vibration/vibration.dart'; // Import vibration package

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer>
    with SingleTickerProviderStateMixin {
  bool isAlarmOn = false; // State for the switch button
  late AnimationController _controller; // Animation controller
  late Animation<double> _animation; // Animation for swinging effect

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 20), // Duration for the swing
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    // Tween values set to swing between -0.5 and 0.5
    _animation = Tween<double>(begin: 0.0, end: 0.5).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller
    super.dispose();
  }

  void _toggleAlarm() async {
    setState(() {
      isAlarmOn = !isAlarmOn; // Update the alarm state
    });
    _swingAnimation(); // Start the pendulum animation

    // Check if the alarm is turned on
    if (isAlarmOn) {
      // Vibrate the device when the alarm is turned on
      // Check if the device has a vibrator

      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        // Vibrate for 500 milliseconds
        Vibration.vibrate(duration: 500);
      }
    }
  }

  void _swingAnimation() async {
    // Swing left to right
    for (int i = 0; i < 3; i++) {
      // Swing left and right 3 times
      await _controller.forward(); // Swing to the right
      await _controller.reverse(); // Swing back to the left
    }
    _controller.value = 0; // Reset to the default position
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white, // White background for the drawer
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 100), // Space from the top

            // Header Text
            Container(
              decoration: BoxDecoration(
                  color: Colors.white12, // Light red background color
                  borderRadius: BorderRadius.circular(10)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
              child: const Text(
                'Menu',
                style: TextStyle(
                  fontSize: 24, // Font size for the header
                  fontWeight: FontWeight.bold, // Bold text
                ),
              ),
            ),

            const SizedBox(height: 20), // Space below the header

            // Update Info Navigation
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // Background color for better visibility
                borderRadius: BorderRadius.circular(10), // Rounded corners
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(56, 5, 5, 5), // Shadow color
                    blurRadius: 4.0, // Blur radius for the shadow
                    spreadRadius: 0, // Spread radius for the shadow
                    offset: Offset(0, 2), // Offset for the shadow
                  ),
                ],
              ),

              padding: const EdgeInsets.all(8), // Padding inside the container
              margin: const EdgeInsets.symmetric(
                  vertical: 8), // Vertical margin for spacing

              child: ListTile(
                leading: const Icon(Icons.person_2_outlined),
                title: const Text('Update your info'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UpdateInfoPage(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 40), // Space before the switch

            // Alarm Switch with Icon
            // Alarm Row with Light Red Background
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                    255, 250, 48, 48), // Light red background color
                borderRadius: BorderRadius.circular(10), // Rounded corners
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(56, 5, 5, 5), // Shadow color
                    blurRadius: 4.0, // Blur radius for the shadow
                    spreadRadius: 0, // Spread radius for the shadow
                    offset: Offset(0, 2), // Offset for the shadow
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8), // Padding for aesthetics
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Pendulum-like swinging icon based on switch state
                  Transform(
                    transform: Matrix4.rotationZ(
                        _animation.value), // Apply swinging effect
                    alignment: Alignment.center, // Center the rotation
                    child: Icon(
                      isAlarmOn
                          ? Icons.notifications
                          : Icons.notifications_off_outlined,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                      width: 10), // Space between the icon and the text
                  const Text(
                    'Alarm',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white), // Label for the switch
                  ),
                  const SizedBox(width: 20), // Space between label and switch
                  Switch(
                    value: isAlarmOn,
                    onChanged: (value) {
                      _toggleAlarm(); // Call the toggle function
                    },
                    activeColor: const Color.fromARGB(
                        255, 105, 14, 14), // Color when switch is on
                    inactiveTrackColor: const Color.fromARGB(
                        186, 227, 89, 89), // Color when switch is off
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
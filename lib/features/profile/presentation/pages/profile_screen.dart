import 'package:flutter/material.dart';
import '../../../../core/widgets/pulse_app_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PulseAppBar(title: 'Profile', showBackButton: false),
      body: Center(
        child: Text('Profile Screen'),
      ),
    );
  }
}

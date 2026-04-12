import 'package:flutter/material.dart';

class AuthMenuScreen extends StatelessWidget {
  const AuthMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1E88E5), // Vibrant Blue
            Color(0xFF42A5F5), // Lighter Blue
            Color(0xFF64B5F6), // Softer Light Blue
            Color(0xFF90CAF9), // Very Light Blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Big Logo - centered with proper spacing
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Image.asset(
                    'assets/images/LOGO.png',
                    height: 350,
                    width: 350,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 10),

                // Login Button
                _MenuButton(
                  text: 'LOG IN',
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                ),
                const SizedBox(height: 20),

                // Register Button
                _MenuButton(
                  text: 'REGISTER',
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _MenuButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0D47A1), // Deep Blue
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: const BorderSide(color: Color(0xFF42A5F5), width: 2),
          ),
          shadowColor: Colors.black38,
          elevation: 8,
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}

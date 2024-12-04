import 'package:flutter/material.dart';
import 'package:x_o/x_o.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            const Text(
              'X-O',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const XOGame(gameMode: 'Computer'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xff303f9f), // لون النص
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // حواف دائرية
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 50, vertical: 20), // المسافة الداخلية
                elevation: 5, // الظل
              ),
              child: const Text(
                'Play with Computer',
                style: TextStyle(
                  fontSize: 20, // حجم النص
                  fontWeight: FontWeight.bold, // سمك الخط
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const XOGame(gameMode: 'Friend'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xff455a64), // لون النص
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // حواف دائرية
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 50, vertical: 20), // المسافة الداخلية
                elevation: 5, // الظل
              ),
              child: const Text(
                'Play with Friend',
                style: TextStyle(
                  fontSize: 20, // حجم النص
                  fontWeight: FontWeight.bold, // سمك الخط
                ),
              ),
            ),
            const SizedBox(
              height: 300,
            ),
          ],
        ),
      ),
    );
  }
}

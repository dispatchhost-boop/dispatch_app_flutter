import 'package:flutter/material.dart';

class IntroSlide extends StatelessWidget {
  final String title, subtitle, imagePath;

  const IntroSlide({super.key, required this.title, required this.subtitle, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final screenHeight = media.size.height;
    final textScale = media.textScaleFactor;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06, vertical: screenHeight * 0.04),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: screenWidth * 0.6,
            height: screenHeight * 0.3,
            fit: BoxFit.contain,
          ),
          SizedBox(height: screenHeight * 0.03),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22 * textScale,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenHeight * 0.015),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14 * textScale,
              fontWeight: FontWeight.normal,
              color: Colors.white,

            ),
          ),
        ],
      ),
    );
  }
}

// class IntroSlide extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final String imagePath;
//
//   const IntroSlide({
//     super.key,
//     required this.title,
//     required this.subtitle,
//     required this.imagePath,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//
//           Expanded(flex: 3, child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const SizedBox(height: 80),
//               Image.asset(imagePath, height: 50),
//           ],)),
//           Expanded(flex: 4, child: Column(mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//             Padding(padding: EdgeInsets.symmetric(horizontal: 30),child: Text(
//               title,
//               textAlign: TextAlign.center,
//               style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                 fontSize: 30,
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),),
//             const SizedBox(height: 20),
//             Padding(padding: EdgeInsets.symmetric(horizontal: 30),child: Text(
//               subtitle,
//               textAlign: TextAlign.center,
//               style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                 fontSize: 18,
//                 color: Colors.white,
//                 fontWeight: FontWeight.normal,
//               ),
//             ),),
//           ],)),
//
//         ],
//       ),
//     );
//   }
// }

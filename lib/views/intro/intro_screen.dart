import 'package:dispatch/const/app_colors.dart';
import 'package:dispatch/const/app_strings.dart';
import 'package:dispatch/const/buttons.dart';
import 'package:dispatch/const/text_style.dart';
import 'package:dispatch/views/auth/login_screen.dart';
import 'package:dispatch/views/auth/sign_up_screen_new.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dispatch/view_model/intro_screen_vm.dart';
import '../kyc_form/kyc_doc.dart';
import 'intro_slides.dart';



//
class IntroductionScreen extends ConsumerStatefulWidget {
  const IntroductionScreen({super.key});

  @override
  ConsumerState<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends ConsumerState<IntroductionScreen> {
  final PageController _controller = PageController();

  final List<Map<String, String>> _slides = [
    {
      'title': 'Tracking in your fingertips',
      'subtitle': 'We will send your package or anything to your destination',
      'image': 'assets/images/png/dispatch.png',
    },
    {
      'title': 'Tracking in your fingertips',
      'subtitle': 'Track your delivery status in real time easily without any hassle',
      'image': 'assets/images/png/dispatch.png',
    },
    {
      'title': 'Package safe and on time',
      'subtitle': 'We provide the best delivery service to customers to build good value',
      'image': 'assets/images/png/dispatch.png',
    },
  ];

  late IntroScreenVM _vm;

  @override
  void initState() {
    super.initState();
    _vm = IntroScreenVM(ref);
    WidgetsBinding.instance.addPostFrameCallback((_){
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.top],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenHeight = kIsWeb ? 800.0 : media.size.height;
    final screenWidth = kIsWeb ? 400.0 : media.size.width;
    final textScale = media.textScaleFactor;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white, // Use your AppColors.white here
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06, vertical: 1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppButtons.elevatedButton(height: screenHeight * 0.06, width: screenWidth * 0.36, text: AppStrings.signUp, onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return SignUpScreenNew();
                        }));
                      }, backgroundColor: AppColors.mainClr),
                      SizedBox(width: screenWidth * 0.04),
                      AppButtons.textButton(
                        height: screenHeight * 0.06,
                        width: screenWidth * 0.36,
                        text: AppStrings.signIn, onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return LogInScreen();
                          // return KycDocumentsScreen();
                        }));
                      },),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.06),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: AppStrings.byJoiningYouAgreeToOur,
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.75),
                          fontSize: 13 * textScale,
                          fontWeight: FontWeight.w400,fontFamily: 'Poppins',
                        ),
                        children: [
                          MyTextStyles.getTextSpan(text: AppStrings.termsOfService, fontWeight: FontWeight.w600, textClr: Colors.black),
                          MyTextStyles.getTextSpan(text: ' ${AppStrings.and} ', fontWeight: FontWeight.w400, textClr: Colors.black.withValues(alpha: 0.75)),
                          MyTextStyles.getTextSpan(text: AppStrings.privacyPolicy, fontWeight: FontWeight.w600)
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.1),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              height: kIsWeb ? screenHeight * 0.82 : screenHeight * 0.7,  // relative height
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFc8c7cc),
                    Color(0xFFc1c0c5),
                    Color(0xFFc7c6cb),
                    Color(0xFFc8c7cc),
                    Color(0xFFb0afb3),
                    Color(0xFF919194),
                    Color(0xFF575759),
                    Color(0xFF49494b),
                    Color(0xFF303031),
                  ],
                  stops: [0.0, 0.08, 0.16, 0.3, 0.45, 0.6, 0.86, 0.93, 1.0],
                ),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(screenWidth * 0.04),
                  bottomLeft: Radius.circular(screenWidth * 0.04),
                ),
              ),
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _controller,
                    itemCount: _slides.length,
                    onPageChanged: (index) {
                      _vm.updateSlideIndex(index);
                    },
                    itemBuilder: (_, index) {
                      final slide = _slides[index];
                      return IntroSlide(
                        title: slide['title'] ?? '',
                        subtitle: slide['subtitle'] ?? '',
                        imagePath: slide['image'] ?? '',
                        // Consider passing screenWidth, screenHeight to IntroSlide to make it responsive too
                      );
                    },
                  ),
                  Consumer(builder: (context, ref, child) {
                    int i = ref.watch(_vm.currentIndex);
                    return i != 2
                        ? Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.06, right: screenWidth * 0.06),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LogInScreen()));
                          },
                          child: Text(
                            'Skip', // Use AppStrings.skip
                            style: TextStyle(
                              fontSize: 18 * textScale,
                              letterSpacing: 0.5,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                        : SizedBox.shrink();
                  }),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.03),
                      child: Consumer(builder: (context, ref, child) {
                        int i = ref.watch(_vm.currentIndex);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _slides.length,
                                (index) => Container(
                              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.012),
                              height: screenHeight * 0.01,
                              width: i == index ? screenWidth * 0.06 : screenWidth * 0.02,
                              decoration: BoxDecoration(
                                color: i == index ? Colors.blue : Colors.grey, // Use your colors
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}














// class IntroductionScreen extends ConsumerStatefulWidget {
//   const IntroductionScreen({super.key});
//
//   @override
//   ConsumerState<IntroductionScreen> createState() => _IntroductionScreenState();
// }
//
// class _IntroductionScreenState extends ConsumerState<IntroductionScreen> {
//   final PageController _controller = PageController();
//   // int _currentIndex = 0;
//
//   final List<Map<String, String>> _slides = [
//     {
//       'title': 'Tracking in your fingertips',
//       'subtitle': 'We will send your package or anything to your destination',
//       'image': 'assets/images/png/dispatch.png',
//     },
//     {
//       'title': 'Tracking in your fingertips',
//       'subtitle': 'Track your delivery status in real time easily without any hassle',
//       'image': 'assets/images/png/dispatch.png',
//     },
//     {
//       'title': 'Package safe and on time',
//       'subtitle': 'We provide the best delivery service to customers to build good value',
//       'image': 'assets/images/png/dispatch.png',
//     },
//   ];
//
//   late IntroScreenVM _vm;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _vm = IntroScreenVM(ref);
//     WidgetsBinding.instance.addPostFrameCallback((_){
//       SystemChrome.setEnabledSystemUIMode(
//         SystemUiMode.manual,
//         overlays: [SystemUiOverlay.top], // Show only top bar
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     // final screenWidth = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background gradient
//           Container(
//             width: double.infinity,
//             height: double.infinity,
//         decoration: BoxDecoration(
//           color: AppColors.white
//           // gradient: LinearGradient(
//           //   begin: Alignment.topCenter,
//           //   end: Alignment.bottomCenter,
//           //   colors: [
//           //     Color(0xFF07659b), // Teal
//           //     Color(0xFF127db3), // Darker teal
//           //     Color(0xFF187aa9), // Even darker
//           //   ],
//           //   stops: [0.0, 0.6, 1.0],
//           // ),
//         ),
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 24, vertical: 25),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // SizedBox(height: 20),
//                   Spacer(),
//
//                   // Buttons
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // Sign Up button
//                       // Expanded(
//                       //   child:
//                         AppButtons.elevatedButton(height: 50, text: AppStrings.signUp, onPressed: (){
//                           Navigator.push(context, MaterialPageRoute(builder: (context){
//                             return SignUpScreenNew();
//                           }));
//                         }, backgroundColor: AppColors.mainClr),
//                       // ),
//                       SizedBox(width: 20),
//                       // Sign In button
//                       // Expanded(
//                       //   child:
//                         AppButtons.textButton(
//                           height: 50,
//                           text: AppStrings.signIn, onPressed: (){
//                           Navigator.push(context, MaterialPageRoute(builder: (context){
//                             return LogInScreen();
//                             // return KycDocumentsScreen();
//                           }));
//                         },),
//                       // ),
//                     ],
//                   ),
//
//                   SizedBox(height: 50,),
//
//                   // Terms and Privacy Policy
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 8),
//                     child: RichText(
//                       textAlign: TextAlign.center,
//                       text: TextSpan(
//                         text: AppStrings.byJoiningYouAgreeToOur,
//                         style: TextStyle(
//                           color: Colors.black.withValues(alpha: 0.75),
//                           fontSize: 13,
//                           fontWeight: FontWeight.w400,fontFamily: 'Poppins',
//                         ),
//                         children: [
//                           MyTextStyles.getTextSpan(text: AppStrings.termsOfService, fontWeight: FontWeight.w600, textClr: Colors.black),
//                           MyTextStyles.getTextSpan(text: ' ${AppStrings.and} ', fontWeight: FontWeight.w400, textClr: Colors.black.withValues(alpha: 0.75)),
//                           MyTextStyles.getTextSpan(text: AppStrings.privacyPolicy, fontWeight: FontWeight.w600)
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   SizedBox(height: 80),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//               child: Container(
//                 height: 572,
//             decoration: BoxDecoration(
//               // color: Colors.green,
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Color(0xFFc8c7cc), // Very light gray
//                   Color(0xFFc1c0c5), // Light gray
//                   Color(0xFFc7c6cb), // Medium gray
//                   Color(0xFFc8c7cc), // Darker gray
//                   Color(0xFFb0afb3), // Even darker
//                   Color(0xFF919194), // Dark gray
//                   Color(0xFF575759),
//                   Color(0xFF49494b),
//                   Color(0xFF303031),
//                 ],
//                 stops: [0.0, 0.08, 0.16, 0.3, 0.45, 0.6, 0.86, 0.93, 1.0],
//               ),
//               borderRadius: BorderRadius.only(
//                 bottomRight: Radius.circular(15),
//                 bottomLeft: Radius.circular(15),
//               ),
//             ),
//                 child: Stack(
//                     children: [
//                       PageView.builder(
//                         controller: _controller,
//                         itemCount: _slides.length,
//                         onPageChanged: (index) {
//                           _vm.updateSlideIndex(index);
//                         },
//                         itemBuilder: (_, index) {
//                           final slide = _slides[index];
//                           return IntroSlide(
//                             title: slide['title'] ?? '',
//                             subtitle: slide['subtitle'] ?? '',
//                             imagePath: slide['image'] ?? '',
//                           );
//                         },
//                       ),
//                       Consumer(builder: (key, builder, child){
//                         int i = ref.watch(_vm.currentIndex);
//                         return i != 2 ? Align(
//                           alignment: Alignment.topRight,
//                           child: Padding(padding: EdgeInsets.only(top: 45, right: 25), child: TextButton(onPressed: (){
//                             Navigator.push(context, MaterialPageRoute(builder: (context)=>LogInScreen()));
//                           }, child: Text(AppStrings.skip,
//                             style: TextStyle(
//                                 fontSize: 18,
//                                 letterSpacing: 0.5,
//                                 color: AppColors.white
//                             ),
//                           )),),
//                         ) : SizedBox.shrink();
//                       },),
//                       Align(
//                           alignment: Alignment.bottomCenter,
//                           // bottom: 15,
//                           child: Padding(padding: EdgeInsets.only(bottom: 20), child: Consumer(builder: (key, builder, child){
//                             int i = ref.watch(_vm.currentIndex);
//                             return Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: List.generate(
//                                 _slides.length,
//                                     (index) => Container(
//                                   margin: const EdgeInsets.symmetric(horizontal: 4),
//                                   height: 8,
//                                   width: i == index ? 24 : 8,
//                                   decoration: BoxDecoration(
//                                     color: i == index ? AppColors.mainClr : AppColors.grey,
//                                     borderRadius: BorderRadius.circular(4),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }),))
//                     ],
//                 )
//           ))
//         ],
//       ),
//     );
//   }
// }

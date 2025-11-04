import 'package:dispatch/const/debug_config.dart';
import 'package:dispatch/prefs/share_pref.dart';
import 'package:dispatch/views/dashboard/dashboard_screen.dart';
import 'package:dispatch/views/intro/intro_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import '../../prefs/share_pref_keys.dart';
import '../../services/login_credentials/user_authentications.dart';
import '../../view_model/splash_vm.dart';
import '../auth/login_screen.dart';
import '../digio_kyc/digio_kyc_home.dart';


class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _dotsController;
  late AnimationController _backgroundController;
  late AnimationController _particlesController;
  late AnimationController _roadController;
  late AnimationController _pulseController;

  Animation<double> _logoScaleAnimation = const AlwaysStoppedAnimation(0.0);
  Animation<double> _logoRotationAnimation = const AlwaysStoppedAnimation(0.0);
  Animation<double> _textSlideAnimation = const AlwaysStoppedAnimation(50.0);
  Animation<double> _textFadeAnimation = const AlwaysStoppedAnimation(0.0);
  Animation<double> _dotsAnimation = const AlwaysStoppedAnimation(0.0);
  Animation<double> _particlesAnimation = const AlwaysStoppedAnimation(0.0);
  Animation<double> _pulseAnimation = const AlwaysStoppedAnimation(1.0);
  Animation<double> _roadAnimation = const AlwaysStoppedAnimation(0.0);

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _dotsController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    _particlesController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _roadController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat();

    // Initialize animations after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAnimations();
    });

    // Navigate after delay
    Future.delayed(Duration(seconds: 4), () {
      if (mounted) {
        navigateOnScreen(context);
      }
    });
  }

  Future<void> navigateOnScreen(BuildContext context) async {
    final userAuth = UserAuthentication();

    // Ensure token is loaded
    await userAuth.loadTokenFromStorage();

    // Ensure first-time flag is loaded
    bool isNotFirst = MySharedPreferences.getBool(FIRST_TIME_OPEN);
    DebugConfig.debugLog('Is first :: $isNotFirst');

    Widget targetScreen;

    if (isNotFirst) {
      DebugConfig.debugLog('On not kyc000112 :: ${userAuth.token}');
      if (userAuth.token != null && userAuth.token!.isNotEmpty) {
        DebugConfig.debugLog('On not kyc000 :: ${userAuth.isKycVerified} and ${userAuth.isKycVerified.runtimeType}');
        if (userAuth.isKycVerified != 1) { // ==
          targetScreen = DashboardScreen();
        } else {
          // DebugConfig.debugLog('On not kyc1');
          // final loginVm = LoginViewModel(ref);
          // CheckKycStatusModel? res = await loginVm.getKycStatus(loaderRef: ref);
          //
          // if(res != null && res.templateId != null && res.templateId!.isNotEmpty){
            targetScreen = DigioKycHome();
          //   // targetScreen = DigioKycHome(
          //   //   docDetails: {
          //   //   "documentId": res.templateId ?? '',
          //   //   "token": res.referenceId ?? '',
          //   //   "userIdentifier": res.customerIdentifier ?? ''
          //   // },
          //   // ); // KycDashboard(); //DashboardScreen(); //
          // }else{
          // DebugConfig.debugLog('On not kyc2');
          //   targetScreen = LogInScreen();
          // }
        }
      } else {
        targetScreen = LogInScreen();
      }
    } else {
      await MySharedPreferences.setBool(FIRST_TIME_OPEN, true);
      targetScreen = IntroductionScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => targetScreen),
    );
  }


  void _initializeAnimations() {

    ref.read(animationsInitializedProvider.notifier).state = false;
    // Logo animations
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    _logoRotationAnimation = Tween<double>(
      begin: -0.5,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutBack),
    ));

    // Text animations
    _textSlideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    ));

    // Dots animation
    _dotsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _dotsController,
      curve: Curves.easeInOut,
    ));

    // Particles animation
    _particlesAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _particlesController,
      curve: Curves.linear,
    ));

    // Pulse animation
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _roadAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _roadController,
      curve: Curves.linear,
    ));

    // Update state using Riverpod
    ref.read(animationsInitializedProvider.notifier).state = true;

    _startAnimations();
  }

  void _startAnimations() async {
    // Start background animations
    _backgroundController.repeat();
    _particlesController.repeat();
    _roadController.repeat();
    _pulseController.repeat(reverse: true);

    await Future.delayed(const Duration(milliseconds: 500));
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();

    await Future.delayed(const Duration(milliseconds: 400));
    _dotsController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _dotsController.dispose();
    _backgroundController.dispose();
    _particlesController.dispose();
    _pulseController.dispose();
    _roadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animationsInitialized = ref.watch(animationsInitializedProvider);

    return Scaffold(
      backgroundColor: const LinearGradient(
        colors: [Color(0xFF1976D2), Color(0xFF21CBF3)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
       ).colors.first,
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _backgroundController,
          _particlesController,
          _roadController,
        ]),
        builder: (context, child) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1976D2), Color(0xFF21CBF3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // Animated particles background
                if (animationsInitialized) ...[
                  ...List.generate(20, (index) =>
                      AnimatedBuilder(
                        animation: _particlesAnimation,
                        builder: (context, child) {
                          final offset = (_particlesAnimation.value + index * 0.1) % 1.0;
                          return Positioned(
                            top: 50 + (index * 30) % (MediaQuery.of(context).size.height - 100),
                            left: -20 + (offset * (MediaQuery.of(context).size.width + 40)),
                            child: Container(
                              width: 4 + (index % 3) * 2,
                              height: 4 + (index % 3) * 2,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.3 + (index % 4) * 0.1),
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        },
                      ),
                  ),
                ],

                // Main content
                SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),

                      // Logo Section with pulse effect
                      animationsInitialized
                          ? AnimatedBuilder(
                        animation: Listenable.merge([
                          _logoScaleAnimation,
                          _logoRotationAnimation,
                          _pulseAnimation,
                        ]),
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _logoScaleAnimation.value * _pulseAnimation.value,
                            child: Transform.rotate(
                              angle: _logoRotationAnimation.value,
                              child: Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white,
                                      Color(0xFFF5F5F5),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.3),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 8),
                                    ),
                                    BoxShadow(
                                      color: Colors.white.withValues(alpha: 0.8),
                                      blurRadius: 10,
                                      spreadRadius: -2,
                                      offset: const Offset(0, -2),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Glow effect
                                    Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        gradient: RadialGradient(
                                          colors: [
                                            const Color(0xFF2196F3).withValues(alpha: 0.3),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Image.asset('assets/images/png/icon_dispatch.png'),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                          : Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Image.asset('assets/images/png/icon_dispatch.png'),
                      ),

                      const SizedBox(height: 40),

                      // App Title with slide animation
                      animationsInitialized
                          ? AnimatedBuilder(
                        animation: Listenable.merge([
                          _textFadeAnimation,
                          _textSlideAnimation,
                        ]),
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _textSlideAnimation.value),
                            child: Opacity(
                              opacity: _textFadeAnimation.value,
                              child: Column(
                                children: [
                                  ShaderMask(
                                    shaderCallback: (bounds) => const LinearGradient(
                                      colors: [
                                        Colors.white,
                                        Color(0xFFE3F2FD),
                                      ],
                                    ).createShader(bounds),
                                    child: const Text(
                                      'Dispatch',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        letterSpacing: 2.0,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(0, 4),
                                            blurRadius: 8,
                                            color: Colors.black26,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.3),
                                      ),
                                    ),
                                    child: const Text(
                                      'Fast & Reliable Delivery',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        letterSpacing: 0.8,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                          : const Column(
                        children: [
                          Text(
                            'Dispatch',
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 2.0,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Fast & Reliable Delivery',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),

                      const Spacer(flex: 1),

                      // Enhanced Truck Animation Section
                      SizedBox(
                        height: 120,
                        child: Stack(
                          children: [
                            // Enhanced Road with gradient
                            Positioned(
                              bottom: 30,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withValues(alpha: 0.2),
                                      Colors.black.withValues(alpha: 0.3),
                                      Colors.black.withValues(alpha: 0.2),
                                    ],
                                  ),
                                  // borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),

                            // Animated road lines
                            if (animationsInitialized)
                            // Animated road lines
                              Positioned(
                                bottom: 33,
                                left: -22,
                                right: 0,
                                child: SizedBox(
                                  height: 2,
                                  child: AnimatedBuilder(
                                    animation: _roadAnimation,
                                    builder: (context, child) {
                                      final screenWidth = MediaQuery.of(context).size.width;
                                      const lineWidth = 25.0;
                                      const gap = 5.0;
                                      final totalSpacing = lineWidth + gap;
                                      final baseOffset = _roadAnimation.value * totalSpacing;

                                      return Stack(
                                        children: List.generate(
                                          (screenWidth ~/ totalSpacing) + 3,
                                              (index) {
                                            // each line is shifted leftwards by baseOffset
                                            double left = (index * totalSpacing - baseOffset) % (screenWidth + totalSpacing);
                                            return Positioned(
                                              left: left,
                                              child: Container(
                                                width: 25,
                                                height: 3,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(2),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),

                                    Positioned(
                                    bottom: 16,
                                    left: MediaQuery.of(context).size.width / 2 - 75, // (150 / 2 = 75 for centering)
                                    child: SizedBox(
                                      width: 150,
                                      height: 100,
                                      child: Image.asset('assets/images/png/truck.png'),
                                    ),
                                  )
                          ],
                        ),
                      ),

                      const Spacer(flex: 1),

                      // Enhanced Loading Dots with wave effect
                      if (animationsInitialized)
                        AnimatedBuilder(
                          animation: _dotsAnimation,
                          builder: (context, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (index) {
                                double delay = index * 0.15;
                                double animValue = (_dotsAnimation.value + delay) % 1.0;
                                double scale = 0.5 + (math.sin(animValue * 2 * math.pi) + 1) * 0.4;
                                double opacity = 0.4 + (math.sin(animValue * 2 * math.pi) + 1) * 0.3;

                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 6),
                                  child: Transform.scale(
                                    scale: scale,
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: opacity),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.white.withValues(alpha: 0.5),
                                            blurRadius: 4,
                                            spreadRadius: scale * 2 - 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.6),
                                shape: BoxShape.circle,
                              ),
                            );
                          }),
                        ),

                      const SizedBox(height: 25),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


// android/app/src/main/res/mipmap-mdpi/ic_launcher.png  1
// android/app/src/main/res/mipmap-hdpi/ic_launcher.png  1
// android/app/src/main/res/mipmap-xhdpi/ic_launcher.png  1
// android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png
// android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png
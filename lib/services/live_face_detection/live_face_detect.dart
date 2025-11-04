import 'dart:io';
import 'package:camera/camera.dart';
import 'package:facelivenessdetection/facelivenessdetection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../const/app_colors.dart';
import '../../const/buttons.dart';
import '../../const/text_style.dart';
import 'live_face_vm.dart';

class FaceDetectorScreen extends StatelessWidget {
  const FaceDetectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text('Detect Face'),
          onPressed: () {
            Get.to(() => FaceDetectorScreenPage());
          },
        ),
      ),
    );
  }
}

class FaceDetectorScreenPage extends StatefulWidget {
  const FaceDetectorScreenPage({super.key});

  @override
  State<FaceDetectorScreenPage> createState() => _FaceDetectorScreenPageState();
}

class _FaceDetectorScreenPageState extends State<FaceDetectorScreenPage> {

  final FaceDetectorController controller = Get.put(FaceDetectorController());

  @override
  void initState() {
    super.initState();
    controller.resetDetection();
  }

  Widget onValidationDoneWrapper(CameraController? camController) {
    controller.startDetectionIfNotRunning(camController);

    return Obx(() {
      if (controller.isHuman.value == null) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.livenessFailed.value) {
        return Center(
          child: MyTextStyles.getRegularText(text: 'Liveness Failed'),
          // child: Text(
          //   'Liveness Failed',
          //   style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          // ),
        );
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          MyTextStyles.getRegularText(text: 'Detect Human Face only', clr: Colors.red),
          const SizedBox(height: 24),
          AppButtons.elevatedButton(text: 'Retry', onPressed: controller.resetDetection, height: 50),
          const SizedBox(height: 40),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {final media = MediaQuery.of(context);
  final screenHeight = kIsWeb ? 800.0 : media.size.height;
  final screenWidth = kIsWeb ? 400.0 : media.size.width;
  final textScale = media.textScaleFactor;
  bool isBigSize = screenWidth >= 500;
    return WillPopScope(
      onWillPop: () async {
        // No timers to cancel here anymore
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios),
          ),
          title: Text("Capture Face"),
          titleTextStyle: TextStyle(fontSize: 25 * textScale, color: AppColors.black),
          actions: [
            // Removed countdown timer UI
          ],
        ),
        body: Obx(() {
          if (controller.livenessFailed.value) {
            return Center(
              child: Text(
                "Liveness not detected",
                style: TextStyle(fontSize: 18 + textScale, color: Colors.red),
              ),
            );
          }
          if (controller.capturedFaceImagePath.value != null) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                      child: ClipOval(
                        child: Image.file(
                          File(controller.capturedFaceImagePath.value!),
                          fit: BoxFit.cover, // Cover works better for a circle
                          height: 170,
                          width: 160, // Must set width for a perfect circle
                        ),
                      )
                  ),
                  const SizedBox(height: 50),
                  MyTextStyles.getBoldText(text: 'Face Detected Successfully!', clr: Colors.green, size: 18),
                  // Retry button
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppButtons.elevatedButton(
                          text: 'Retry',
                          onPressed: controller.resetDetection,
                          height: 42,
                          width: 100,
                          backgroundColor: Colors.grey
                      ),
                      const SizedBox(width: 20),

                      // Save button
                      AppButtons.elevatedButton(
                        text: 'Save',
                        height: 42,
                        width: 100,
                        onPressed: () {
                          // log('✅ Image saved at: ${controller.capturedFaceImagePath.value}');
                          // Add your save logic here (e.g., API call or navigation)
                          final imagePath = controller.capturedFaceImagePath.value;
                          // if (imagePath != null && imagePath.isNotEmpty) {
                          if (imagePath != null && File(imagePath).existsSync()) {
                            Navigator.pop(context, imagePath);
                            // log('✅ Returning image path: $imagePath');
                          } else {
                            // log('⚠ No image to return');
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            );
          }

          return Center(
            child: FaceDetectorView(
              progressColor: Colors.red,
              activeProgressColor: Colors.green,
              cameraSize: isBigSize ? Size(300, 300) : Size(200, 200),
              ruleset: [
                Rulesets.blink,
                Rulesets.toRight,
                Rulesets.toLeft,
                Rulesets.tiltUp,
                Rulesets.tiltDown
              ],
              onSuccessValidation: (validated) {
                // log('Face verification is completed', name: 'Validation');
                // Stop loader by setting detected image
                // controller.capturedFaceImagePath.value = validated?.path;
              },
              onValidationDone: onValidationDoneWrapper,
              onRulesetCompleted: (ruleset) {
                if (!controller.completedRuleset.contains(ruleset)) {
                  controller.completedRuleset.add(ruleset);
                }
              },
              child: ({required int countdown, required Rulesets state, required bool hasFace}) {
                controller.updateStepTitle(state);
                controller.hasFace.value = hasFace;

                final totalSteps = 5;

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: screenHeight * 0.012),
                      Obx(() => Text(
                        controller.hasFace.value ? 'Face detected' : 'No face detected',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: controller.hasFace.value ? Colors.green : Colors.redAccent,
                        ),
                      )),
                      SizedBox(height: screenHeight * 0.03),
                      Obx(() => Text(
                        controller.currentStepTitle.value.isNotEmpty
                            ? controller.currentStepTitle.value
                            : "Waiting...",
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      )),
                      SizedBox(height: screenHeight * 0.012),

                      // Step counter
                      Obx(() => Text(
                        'Step ${controller.completedRuleset.length} of $totalSteps',
                        style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.w500),
                      )),
                      SizedBox(height: screenHeight * 0.025),

                      // Loader
                      CircularProgressIndicator(color: AppColors.mainClr,),
                    ],
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}

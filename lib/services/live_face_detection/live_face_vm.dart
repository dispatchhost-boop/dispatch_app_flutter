import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:facelivenessdetection/facelivenessdetection.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';


class FaceDetectorController extends GetxController {
  var completedRuleset = <Rulesets>[].obs;
  var currentStepTitle = ''.obs;
  var lastStepTitle = ''.obs;
  var hasFace = false.obs;
  var livenessFailed = false.obs;
  var isHuman = RxnBool();
  var isDetecting = false.obs;
  var capturedFaceImagePath = RxnString();

  @override
  void onInit() {
    super.onInit();
    // log('Controller onInit');
    resetDetection();
    // Removed timer start here
  }

  @override
  void onClose() {
    // log('Controller onClose');
    // Removed timer cancel here
    super.onClose();
  }

  @override
  void dispose() {
    Get.delete<FaceDetectorController>();
    super.dispose();
  }


  void resetDetection() {
    // log('Resetting detection');
    capturedFaceImagePath.value = null;
    isHuman.value = null;
    livenessFailed.value = false;
    completedRuleset.clear();
    hasFace.value = false;
    isDetecting.value = false;
    // Removed timer restart here
  }

  void updateStepTitle(Rulesets state) {
    final title = getHintText(state);
    if (lastStepTitle.value != title) {
      lastStepTitle.value = title;
      currentStepTitle.value = title;
    }
  }

  void startDetectionIfNotRunning(CameraController? camController) {
    Future.delayed(Duration(microseconds: 500), (){
      if (isDetecting.value) return;
      isDetecting.value = true;

      () async {
        try {
          final XFile file = await camController!.takePicture();
          final imagePath = file.path;
          // log('Image captured at: $imagePath');

          final bool humanDetected = await detectHumanFace(imagePath);

          isHuman.value = humanDetected;

          if (!completedRuleset.contains(Rulesets.blink)) {
            livenessFailed.value = true;
          }
          if (humanDetected) {
            capturedFaceImagePath.value = imagePath;
          }
        } catch (e) {
          log('Error capturing image: $e');
          isHuman.value = false;
          livenessFailed.value = true;
        }
      }();
    }
    );
  }

  Future<bool> detectHumanFace(String imagePath) async {
    try {
      final faceDetector = FaceDetector(
        options: FaceDetectorOptions(
          performanceMode: FaceDetectorMode.accurate,
          enableClassification: true,
          enableContours: false,
          enableLandmarks: false,
          enableTracking: false,
          minFaceSize: 0.1,
        ),
      );

      final inputImage = InputImage.fromFilePath(imagePath);
      final List<Face> faces = await faceDetector.processImage(inputImage);

      await faceDetector.close();

      return faces.isNotEmpty;
    } catch (e) {
      log("⚠️ Error in face detection: $e");
      return false;
    }
  }

  String getHintText(Rulesets state) {
    switch (state) {
      case Rulesets.blink:
        return 'Please Blink';
      case Rulesets.toRight:
        return 'Turn Your Head to Right';
      case Rulesets.toLeft:
        return 'Turn Your Head to Left';
      case Rulesets.tiltUp:
        return 'Tilt Your Head Up';
      case Rulesets.tiltDown:
        return 'Tilt Your Head Down';
      default:
        return '';
    }
  }
}

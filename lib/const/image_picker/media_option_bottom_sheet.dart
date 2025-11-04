import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dispatch/const/debug_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dispatch/const/image_picker/my_media_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class MyBottomSheet{
  static bool _isPicking = false;
  // // pick = 1 for single image & pick = 2 for multiImages & pick = 3 for multiMedia
  // static onMediaOptionBottomSheet({required BuildContext context, required int pickImage, bool? showPdfIcon, int? imageQuality})async{
  //   if (_isPicking) return;
  //   _isPicking = true; // Prevent multiple calls
  //   final media = MediaQuery.of(context);
  //   final screenHeight = media.size.height;
  //   final textScale = media.textScaleFactor;
  //
  //   try {
  //     final image = await showModalBottomSheet(context: context,
  //         isDismissible: false,
  //         builder: (context){
  //       return SizedBox(
  //         height: screenHeight * 0.3,
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             Center(child: Text('Select Image', style: TextStyle(fontSize: 22 * textScale),),),
  //             // SizedBox(height: 40,),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: [
  //                 Expanded(
  //                   child: GestureDetector(
  //                     onTap: () async {
  //                       final File? pickedImage = await MyMediaPicker.onSingleImagePicker(
  //                           ImageSource.camera, imageQuality ?? 50);
  //                       if(pickedImage != null){
  //                         final imageComp = await MyMediaPicker.onSingleImageCompressor(imageFile: pickedImage);
  //                         Get.back(result: imageComp);
  //                       }else{
  //                         Get.back(result: pickedImage);
  //                       }
  //                     },
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         SizedBox(
  //                           height: 65,
  //                           width: 65,
  //                           child: Image.asset('assets/images/png/camera.png'),
  //                         ),
  //                         SizedBox(height: 10,),
  //                         const Text('Camera'),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: GestureDetector(
  //                     onTap: () async {
  //                       if(pickImage ==1){
  //                         final File? pickedImage = await MyMediaPicker.onSingleImagePicker(ImageSource.gallery, imageQuality ?? 50);
  //                         if(pickedImage != null){
  //                           final imageComp = await MyMediaPicker.onSingleImageCompressor(imageFile: pickedImage);
  //                           Get.back(result: imageComp);
  //                         }else{
  //                           Get.back(result: pickedImage);
  //                         }
  //                       }else if(pickImage == 2){
  //                         final List<File>? pickedImage = await MyMediaPicker.onMultipleImagePicker(imageQuality ?? 50);
  //                         // log('is multiple media list :: $pickedImage');
  //                         Get.back(result: pickedImage);
  //                       }else if(pickImage == 3){
  //                         final List<File>? pickedImage = await MyMediaPicker.onMultipleMediaPicker(imageQuality ?? 50);
  //                         // log('is multiple image list :: $pickedImage');
  //                         Get.back(result: pickedImage);
  //                       }
  //                     },
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         SizedBox(
  //                           height: 65,
  //                           width: 65,
  //                           child: Image.asset('assets/images/png/gallery.png'),
  //                         ),
  //                         const SizedBox(height: 10,),
  //                         const Text('Gallery'),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 // showPdfIcon == true ? Expanded(
  //                 //   child: GestureDetector(
  //                 //     onTap: () async {
  //                 //
  //                 //       final pickedImage = await _pickSinglePdf();
  //                 //
  //                 //       log('is hosdkfs add :: $pickedImage');
  //                 //       Get.back(result: pickedImage);
  //                 //     },
  //                 //     child: Column(
  //                 //       mainAxisAlignment: MainAxisAlignment.center,
  //                 //       children: [
  //                 //         SizedBox(
  //                 //           height: 65,
  //                 //           width: 65,
  //                 //           child: Image.asset('assets/images/pdf.png'),
  //                 //         ),
  //                 //         const SizedBox(height: 10,),
  //                 //         const Text('pdf'),
  //                 //       ],
  //                 //     ),
  //                 //   ),
  //                 // ) : const SizedBox.shrink()
  //               ],
  //             ),
  //           ],
  //         ),
  //       );
  //     });
  //
  //     if(image != null){
  //       return image;
  //     }else{
  //       return null;
  //     }
  //   } finally {
  //     _isPicking = false; // Reset flag when done
  //   }
  //
  // }

  // static Future<File?> _pickSinglePdf() async {
  //   try {
  //     final result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: ['pdf'],
  //     );
  //
  //     if (result != null && result.files.isNotEmpty) {
  //       // Return the File object
  //       return File(result.files.single.path!);
  //     }
  //   } catch (e) {
  //     log('Error picking PDF file: $e');
  //   }
  //   return null; // Return null if no file was selected
  // }



  static onMediaOptionBottomSheet({
    required BuildContext context,
    required int pickImage,
    bool? showPdfIcon,
    int? imageQuality,
  }) async {
    if (_isPicking) return;
    _isPicking = true; // Prevent multiple calls
    final media = MediaQuery.of(context);
    final screenHeight = media.size.height;
    final screenWidth = media.size.width;
    final textScale = media.textScaleFactor;

    try {
      final image = await showModalBottomSheet(
        context: context,
        isDismissible: false,
        builder: (context) {
          return LayoutBuilder(
            builder: (context, constraints) {
              bool isBigSize = constraints.maxWidth > 550;

              return SizedBox(
                height: isBigSize ? screenHeight * 0.35 : screenHeight * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: Text(
                        'Select Image',
                        style: TextStyle(fontSize: 22 * textScale),
                      ),
                    ),
                    // SizedBox(height: screenHeight * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _buildOptions(
                        context: context,
                        pickImage: pickImage,
                        imageQuality: imageQuality,
                        showPdfIcon: showPdfIcon,
                        iconSize: isBigSize ? 80 : 65,
                        fontSize: isBigSize ? 16 * textScale : 14 * textScale,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );

      return image ?? null;
    } finally {
      _isPicking = false; // Reset flag when done
    }
  }

  /// 🔑 Helper to build media options
  static List<Widget> _buildOptions({
    required BuildContext context,
    required int pickImage,
    int? imageQuality,
    bool? showPdfIcon,
    double iconSize = 65,
    double fontSize = 14,
  }) {
    return [
      // Camera
      GestureDetector(
        onTap: () async {
          final hasCamera = await ensureCameraPermission(context);
          if (!hasCamera) return;

          final File? pickedImage = await MyMediaPicker.onSingleImagePicker(
            ImageSource.camera,
            imageQuality ?? 50,
          );
          if (pickedImage != null) {
            final imageComp =
            await MyMediaPicker.onSingleImageCompressor(imageFile: pickedImage);
            Get.back(result: imageComp);
          } else {
            Get.back(result: pickedImage);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: iconSize,
              width: iconSize,
              child: Image.asset('assets/images/png/camera.png'),
            ),
            const SizedBox(height: 10),
            Text('Camera', style: TextStyle(fontSize: fontSize)),
          ],
        ),
      ),

      // Gallery
      GestureDetector(
        onTap: () async {
          if (pickImage == 1) {
            final hasGallery = await ensureGalleryPermission(context);
            if (!hasGallery) return;
            final File? pickedImage = await MyMediaPicker.onSingleImagePicker(
              ImageSource.gallery,
              imageQuality ?? 50,
            );
            if (pickedImage != null) {
              final imageComp = await MyMediaPicker.onSingleImageCompressor(
                  imageFile: pickedImage);
              Get.back(result: imageComp);
            } else {
              Get.back(result: pickedImage);
            }
          } else if (pickImage == 2) {
            final List<File>? pickedImage =
            await MyMediaPicker.onMultipleImagePicker(imageQuality ?? 50);
            Get.back(result: pickedImage);
          } else if (pickImage == 3) {
            final List<File>? pickedImage =
            await MyMediaPicker.onMultipleMediaPicker(imageQuality ?? 50);
            Get.back(result: pickedImage);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: iconSize,
              width: iconSize,
              child: Image.asset('assets/images/png/gallery.png'),
            ),
            const SizedBox(height: 10),
            Text('Gallery', style: TextStyle(fontSize: fontSize)),
          ],
        ),
      ),

      if (showPdfIcon == true)
        GestureDetector(
          onTap: () async {
            // final hasPdf = await ensurePdfPermission(context);
            // if (!hasPdf) return;
            final pickedPdf = await MyMediaPicker.onSingleMediaPicker(quality: imageQuality ?? 50);
            Get.back(result: pickedPdf);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: iconSize,
                width: iconSize,
                child: Image.asset('assets/images/png/gallery.png'),
              ),
              const SizedBox(height: 10),
              Text('PDF', style: TextStyle(fontSize: fontSize)),
            ],
          ),
        ),
    ];
  }

  /// Request Camera Permission
  static Future<bool> ensureCameraPermission(BuildContext context) async {
    final status = await Permission.camera.status;

    if (status.isGranted) {
      DebugConfig.debugLog('Camera 1');
      return true;
    }else if (status.isPermanentlyDenied) {
      DebugConfig.debugLog('Camera 3');
      // 🚫 Permanently denied → Open settings
      Get.back();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Camera permission permanently denied, enable it from settings.")),
      );
      // await openAppSettings();
      return false;
    } else {
      DebugConfig.debugLog('Camera 4');
      final result = await Permission.camera.request();
      return result.isGranted;
    }
  }

  /// Request Gallery Permission (Photos/Storage)
  static Future<bool> ensureGalleryPermission(BuildContext context) async {
    final permission = Platform.isIOS
        ? Permission.photos
        : (Platform.isAndroid && await _isAndroid13OrAbove()
            ? Permission.photos
            : Permission.storage);

    final status = await permission.status;

    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      Get.back();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gallery permission permanently denied, enable it from settings.")),
      );
      // await openAppSettings();
      return false;
    } else {
      final result = await permission.request();
      return result.isGranted;
    }
  }

  /// Helper: check if Android 13+
  static Future<bool> _isAndroid13OrAbove() async {
    if (!Platform.isAndroid) return false;
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    return androidInfo.version.sdkInt >= 33;
  }

  // static Future<bool> ensurePdfPermission(BuildContext context) async {
  //   if (Platform.isIOS) {
  //     // iOS doc picker doesn’t need explicit storage permission
  //     return true;
  //   }
  //
  //   // For Android < 13 → Storage, for Android 13+ → use READ_MEDIA_* (handled by Permission.storage)
  //   final status = await Permission.storage.status;
  //
  //   if (status.isGranted) {
  //     DebugConfig.debugLog('Storage ✅ Granted');
  //     return true;
  //   }
  //
  //   if (status.isPermanentlyDenied) {
  //     DebugConfig.debugLog('Storage ❌ Permanently Denied');
  //     Get.back();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Storage permission permanently denied, enable it from settings.")),
  //     );
  //     // await openAppSettings();
  //     return false;
  //   }
  //
  //   final result = await Permission.storage.request();
  //   return result.isGranted;
  // }




}
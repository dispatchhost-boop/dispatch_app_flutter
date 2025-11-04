import 'dart:developer';
import 'dart:io';

import 'package:dispatch/const/debug_config.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class MyMediaPicker {
  /// Pick a single image (camera/gallery)
  static Future<File?> onSingleImagePicker(
      ImageSource source, int imageQuality) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        preferredCameraDevice: source == ImageSource.camera ? CameraDevice.front : CameraDevice.rear,
        imageQuality: imageQuality,
      );

      if (image != null) {
        return File(image.path);
      } else {
        // Handle lost data
        final LostDataResponse response = await picker.retrieveLostData();
        if (response.isEmpty) return null;
        if (response.file != null) {
          return File(response.file!.path);
        } else if (response.exception != null) {
          throw Exception(response.exception);
        }
      }
    } catch (e) {
      throw Exception(e);
    }
    return null;
  }

  /// Pick multiple images
  static Future<List<File>?> onMultipleImagePicker(int quality) async {
    try {
      List<XFile> imagesList =
      await ImagePicker().pickMultiImage(imageQuality: quality);
      return imagesList.isNotEmpty
          ? imagesList.map((file) => File(file.path)).toList()
          : null;
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Compress a single image file until size is under 300 KB
  // static Future<File?> onSingleImageCompressor({
  //   File? imageFile,
  //   int maxSizeInMB = 1, required int atQuality, // default 1 mb
  // }) async {
  //   try {
  //     if (imageFile == null) return null;
  //
  //     int maxSize = maxSizeInMB * 1024 * 1024; // for kb - int maxSize = maxSizeInKB * 1024; // bytes
  //     int imageSize = await imageFile.length();
  //
  //     DebugConfig.debugLog("📌 Original size: ${(imageSize / 1024).toStringAsFixed(2)} KB");
  //
  //     // If already under limit, return as-is
  //     if (imageSize <= maxSize) return imageFile;
  //     int quality = atQuality;
  //     int minWidth = 1920;
  //     int minHeight = 1080;
  //
  //     while (imageSize > maxSize && quality > 10) {
  //       final Directory tempDir = await getTemporaryDirectory();
  //       final String targetPath = join(
  //         tempDir.path,
  //         "compressed_${DateTime.now().millisecondsSinceEpoch}.jpg",
  //       );
  //
  //       final compressedFile = await FlutterImageCompress.compressAndGetFile(
  //         imageFile!.absolute.path,
  //         targetPath,
  //         quality: quality,
  //         minWidth: minWidth,
  //         minHeight: minHeight,
  //       );
  //
  //       if (compressedFile != null) {
  //         imageFile = File(compressedFile.path);
  //         imageSize = await imageFile.length();
  //
  //         DebugConfig.debugLog("📌 Compressed -> ${(imageSize / 1024).toStringAsFixed(2)} KB (quality=$quality)");
  //
  //         // decrease gradually
  //         quality -= 10;
  //         minWidth = (minWidth * 0.9).toInt();
  //         minHeight = (minHeight * 0.9).toInt();
  //       } else {
  //         break;
  //       }
  //     }
  //
  //     return imageFile;
  //   } catch (e) {
  //     DebugConfig.debugLog('❌ Error on Image Compressor: $e');
  //     return null;
  //   }
  // }

  static Future<File?> onSingleImageCompressor({
    required File imageFile,
    int maxSizeInMB = 1,
    int atQuality = 90, // default quality (optional)
  }) async {
    try {
      final int maxSize = maxSizeInMB * 1024 * 1024;
      int imageSize = await imageFile.length();

      DebugConfig.debugLog("📌 Original size: ${(imageSize / 1024).toStringAsFixed(2)} KB");

      if (imageSize <= maxSize) return imageFile;

      if((imageSize / 1024) >= 4000){
        atQuality = 80;
      }

      // int quality = atQuality;
      int minWidth = 1920;
      int minHeight = 1080;
      // Set minimum possible values to avoid overcompression
      const int minQuality = 10;
      const int minAllowedWidth = 300;
      const int minAllowedHeight = 300;

      File? compressedImage = imageFile;

      while (imageSize > maxSize && atQuality >= minQuality && minWidth > minAllowedWidth && minHeight > minAllowedHeight) {
        final Directory tempDir = await getTemporaryDirectory();
        final String targetPath = join(
          tempDir.path,
          "compressed_${DateTime.now().millisecondsSinceEpoch}.jpg",
        );

        final result = await FlutterImageCompress.compressAndGetFile(
          compressedImage!.absolute.path,
          targetPath,
          quality: atQuality,
          minWidth: minWidth,
          minHeight: minHeight,
        );

        if (result == null) break;

        compressedImage = File(result.path);
        imageSize = await compressedImage.length();

        DebugConfig.debugLog("📌 Compressed -> ${(imageSize / 1024).toStringAsFixed(2)} KB (quality=$atQuality, w=$minWidth, h=$minHeight)");

        // Reduce further for next loop
        atQuality -= 10;
        minWidth = (minWidth * 0.9).toInt();
        minHeight = (minHeight * 0.9).toInt();
      }

      return compressedImage;
    } catch (e) {
      DebugConfig.debugLog('❌ Error on Image Compressor: $e');
      return null;
    }
  }


  /// Compress a list of image files
  static Future<List<File>?> onCompressorFileList({
    required List<File> files,
    required int atQuality,
  }) async {
    List<File> compressedFiles = [];
    for (File file in files) {
      File? compressedFile =
      await onSingleImageCompressor(imageFile: file, atQuality: atQuality);
      if (compressedFile != null) compressedFiles.add(compressedFile);
    }
    return compressedFiles;
  }

  /// Pick single image (jpg/png) or PDF
  static Future<dynamic> onSingleMediaPicker({
    required int quality,
    List<String> allowedExtensions = const ['jpg', 'jpeg', 'png', 'pdf'],
  }) async {
    try {
      final XFile? picked = await ImagePicker().pickMedia(
        imageQuality: quality,
      );

      if (picked == null) return null;

      final path = picked.path.toLowerCase();

      // ✅ Check extension from parameter
      final isAllowed = allowedExtensions.any((ext) => path.endsWith(".$ext"));

      if (isAllowed) {
        final file = File(picked.path);
        final bytes = await file.length();
        final sizeInMB = bytes / (1024 * 1024);
        DebugConfig.debugLog("❌ Size is too large: ${sizeInMB.toStringAsFixed(2)} MB");
        // ✅ Extra check for File size (2 MB max)
          if (sizeInMB > 2) {
            return 'large_size'; // custom error code
          }else{
            return File(picked.path);
          }
      } else {
        DebugConfig.debugLog("❌ Unsupported file type: $path");
        return 'unsupported'; // or throw Exception("Unsupported file type");
      }
    } catch (e) {
      DebugConfig.debugLog('Error on Single Media Picker: ${e.toString()}');
      throw Exception(e);
    }
  }

  /// Pick multiple media files
  static Future<List<File>?> onMultipleMediaPicker(int quality) async {
    try {
      List<XFile> imagesList =
      await ImagePicker().pickMultipleMedia(imageQuality: quality);
      return imagesList.isNotEmpty
          ? imagesList.map((file) => File(file.path)).toList()
          : null;
    } catch (e) {
      throw Exception(e);
    }
  }
}

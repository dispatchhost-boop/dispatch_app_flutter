
import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:read_pdf_text/read_pdf_text.dart';

import '../../const/debug_config.dart';

class OcrFiles{

  // Extract text from image
  static Future<String?> extractTextFromImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);

// English
    final latinRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final latinResult = await latinRecognizer.processImage(inputImage);
    await latinRecognizer.close();

// Hindi
    final hindiRecognizer = TextRecognizer(script: TextRecognitionScript.devanagiri);
    final hindiResult = await hindiRecognizer.processImage(inputImage);
    await hindiRecognizer.close();

// Merge both
    final fullText = "${latinResult.text}\n${hindiResult.text}";
    return fullText.trim();
  }

  // Extract text from PDF
  static Future<String?> extractTextFromPdf(File pdfFile) async {
    try {
      // Extract all pages as a list of strings
      final pages = await ReadPdfText.getPDFtextPaginated(pdfFile.path);
      return pages.join('\n'); // Merge into single text
    } catch (e) {
      DebugConfig.debugLog('Error reading PDF: $e');
      return null;
    }
  }

}

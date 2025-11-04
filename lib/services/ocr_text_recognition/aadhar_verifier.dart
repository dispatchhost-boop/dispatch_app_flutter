import 'dart:io';
import 'package:dispatch/const/debug_config.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class AadhaarVerifier {

  /// Check if text contains any keyword from a list
  static bool containsAny(String text, List<String> keywords) {
    final norm = text.toLowerCase();
    return keywords.any((k) => norm.contains(k.toLowerCase()));
  }

  /// Verify Aadhaar text has BOTH front & back keywords + Aadhaar number
  static bool verifyFront(String extractedText) {
    final normText = extractedText.replaceAll("\n", " ");

    // Front side markers
    final frontKeywords = [
      "सत्यमेव जयते",
      "भारत सरकार",
      "government of india",
      "government of lndia", // common OCR mistake
      "मेरा आधार, मेरी पहचान",
    ];

    // // Back side markers
    // final backKeywords = [
    //   "unique identification authority of india",
    //   "भारतीय विशिष्ट पहचान प्राधिकरण",
    //   "address",
    //   "पता", // Hindi "address"
    // ];

    final hasFront = containsAny(normText, frontKeywords);
    // final hasBack = containsAny(normText, backKeywords);

    // Aadhaar regex (12 digits OR masked Aadhaar last 4 digits)
    final aadhaarRegex = RegExp(r"\b\d{4}\s?\d{4}\s?\d{4}\b"); // full 12
    final maskedRegex = RegExp(r"(x{4}\s?x{4}\s?\d{4})", caseSensitive: false); // masked

    final aadhaarMatch = aadhaarRegex.firstMatch(normText);
    final maskedMatch = maskedRegex.firstMatch(normText);

    // Aadhaar valid if number (full/masked) exists + BOTH sides keywords
    return (aadhaarMatch != null || maskedMatch != null) && hasFront;
  }

  // static bool verifyBack(String extractedText) {
  //   DebugConfig.debugLog('Back Extarcted words : $extractedText');
  //   final normText = extractedText.replaceAll("\n", " ");
  //
  //   // // Front side markers
  //   // final frontKeywords = [
  //   //   "सत्यमेव जयते",
  //   //   "भारत सरकार",
  //   //   "government of india",
  //   //   "government of lndia", // common OCR mistake
  //   //   "मेरा आधार, मेरी पहचान",
  //   // ];
  //
  //   // Back side markers
  //   final backKeywords = [
  //     "unique identification authority of india",
  //     "भारतीय विशिष्ट पहचान प्राधिकरण",
  //     "address",
  //     "पता", // Hindi "address"
  //   ];
  //
  //   // final hasFront = containsAny(normText, frontKeywords);
  //   final hasBack = containsAny(normText, backKeywords);
  //
  //   // Aadhaar regex (12 digits OR masked Aadhaar last 4 digits)
  //   final aadhaarRegex = RegExp(r"\b\d{4}\s?\d{4}\s?\d{4}\b"); // full 12
  //   final maskedRegex = RegExp(r"(x{4}\s?x{4}\s?\d{4})", caseSensitive: false); // masked
  //
  //   final aadhaarMatch = aadhaarRegex.firstMatch(normText);
  //   final maskedMatch = maskedRegex.firstMatch(normText);
  //
  //   // Aadhaar valid if number (full/masked) exists + BOTH sides keywords
  //   return (aadhaarMatch != null || maskedMatch != null) && hasBack;
  // }

  static bool verifyBack(String extractedText) {
    final normText = extractedText.replaceAll("\n", " ");

    // Back side markers
    final backKeywords = [
      "unique identification authority of india",
      "भारतीय विशिष्ट पहचान प्राधिकरण",
      "address",
      "पता",
    ];

    final hasBack = containsAny(normText, backKeywords);

    // ✅ Aadhaar back valid if back markers exist (no need for Aadhaar number)
    return hasBack;
  }

  /// Extract Aadhaar number (full or masked → last 4 digits)
  static String? extractAadhaarNumber(String extractedText) {
    // Full Aadhaar
    final aadhaarRegex = RegExp(r"\b\d{4}\s?\d{4}\s?\d{4}\b");
    final matchFull = aadhaarRegex.firstMatch(extractedText);
    if (matchFull != null) {
      return matchFull.group(0)?.replaceAll(" ", "");
    }

    // Masked Aadhaar (only last 4 digits meaningful)
    final maskedRegex = RegExp(r"(x{4}\s?x{4}\s?(\d{4}))", caseSensitive: false);
    final matchMasked = maskedRegex.firstMatch(extractedText);
    if (matchMasked != null) {
      return matchMasked.group(2); // last 4 digits only
    }

    return null;
  }
}

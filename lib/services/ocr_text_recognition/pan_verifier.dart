import 'dart:io';
import 'package:dispatch/const/debug_config.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class PanVerifier {
  /// Check if text contains any keyword from a list
  static bool containsAny(String text, List<String> keywords) {
    final norm = text.toLowerCase();
    return keywords.any((k) => norm.contains(k.toLowerCase()));
  }

  /// Verify PAN card text:
  /// - Every keyword in extractedText must exist in the allowed keywords list.
  /// - PAN number format must also be valid.
  /// Verify PAN card text has all required keywords + PAN number format
  static bool verify(String extractedText) {
    final normText = extractedText.replaceAll("\n", " ").toLowerCase();

    // PAN keywords (must all be present)
    final keywords = [
      "income tax department",
      "govt. of india",
      "permanent account number card",
      "स्थायी लेखा संख्या कार्ड",
      "आयकर विभाग",
      "भारत सरकार",
      "नाम",
      "पिता का नाम",
      "जन्म की तारीख",
      "हस्ताक्षर",
    ];

    // ✅ Check that *every* keyword exists in extracted text
    final missingKeywords = keywords
        .where((k) => !normText.contains(k.toLowerCase()))
        .toList();

    final hasAllKeywords = missingKeywords.isEmpty;

    // PAN number regex (AAAAA9999A)
    final panRegex = RegExp(r"\b([A-Z]{5}[0-9]{4}[A-Z])\b");
    final panMatch = panRegex.firstMatch(extractedText.toUpperCase());

    // Debugging
    DebugConfig.debugLog("📌 Missing keywords: $missingKeywords");

    return panMatch != null && hasAllKeywords;
  }

  /// Extract PAN number
  static String? extractPanNumber(String extractedText) {
    final panRegex = RegExp(r"\b([A-Z]{5}[0-9]{4}[A-Z])\b");
    final match = panRegex.firstMatch(extractedText);
    if (match != null) {
      return match.group(0);
    }
    return null;
  }
}

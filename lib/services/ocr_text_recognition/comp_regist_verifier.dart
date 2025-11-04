import 'dart:io';
import 'package:dispatch/const/debug_config.dart';

class CompanyRegVerifier {
  /// Verify Company Registration text:
  /// - Must contain all required keywords (case-insensitive)
  /// - Must contain a valid CIN format
  static String normalize(String text) {
    final lower = text.toLowerCase();

    return lower
        .replaceAll('ldentity', 'identity')   // OCR l -> I
        .replaceAll('pernmanent', 'permanent') // double n
        .replaceAll('coporate', 'corporate') // double n
        .replaceAll('paņ', 'pan')              // weird accent in PAN
        .replaceAll('nùgber', 'number')        // OCR ù -> u
        .replaceAll('nùnber', 'number')        // OCR ù -> u
        .replaceAll('nùgber', 'number')        // OCR ù -> u
        .replaceAll('çorporate', 'corporate')  // OCR ç -> c
        .replaceAll('şeptember', 'september')  // OCR ş -> s
        .replaceAll('compáníes', 'companies')  // OCR í -> i
        .replaceAll('ingorporation', 'incorporation'); // OCR g -> c
  }

  static bool verify(String extractedText) {
    final normText = normalize(extractedText);
    DebugConfig.debugLog('messagea324 : $normText');

    // Required keyword phrases
    final keywords = [
      "government of india",
      "central registration centre",
      "certificate of incorporation",
      "the corporate identity number",
      "the permanent account number",
      "the tax deduction and collection account number",
    ];

    // Check missing keywords
    final missingKeywords = keywords
        .where((k) => !normText.contains(k.toLowerCase()))
        .toList();

    final hasAllKeywords = missingKeywords.isEmpty;

    // CIN regex: 21 characters like L00000MH2000PLC123456
    final cinRegex = RegExp(
      r"\b([A-Z]{1}[0-9]{5}[A-Z]{2}[0-9]{4}[A-Z]{3}[0-9]{6})\b",
    );
    // final cinMatch = cinRegex.firstMatch('U74999UP2018PTC107680');
    final cinMatch = cinRegex.firstMatch(extractedText.toUpperCase());

    // Debug log (optional)
    DebugConfig.debugLog("📌 Missing keywords: $missingKeywords");
    DebugConfig.debugLog("✅ CIN Found: ${cinMatch?.group(0)}");
    DebugConfig.debugLog("✅ All Keywords Present: $hasAllKeywords");

    return cinMatch != null && hasAllKeywords;
  }

  /// Extract Company Registration Number (CIN)
  static String? extractCIN(String extractedText) {
    final cinRegex = RegExp(
      r"\b([A-Z]{1}[0-9]{5}[A-Z]{2}[0-9]{4}[A-Z]{3}[0-9]{6})\b",
    );
    final match = cinRegex.firstMatch(extractedText.toUpperCase());
    DebugConfig.debugLog('messagedasdas :: ${match?.group(0)}');
    return match?.group(0);
  }
}


// class CompanyRegVerifier {
//   /// Check if text contains any keyword from a list
//   static bool containsAny(String text, List<String> keywords) {
//     final norm = text.toLowerCase();
//     return keywords.any((k) => norm.contains(k.toLowerCase()));
//   }
//
//   /// Verify Company Registration text:
//   /// - Every keyword in extractedText must exist in the allowed keywords list.
//   /// - Company registration number format must also be valid.
//   static bool verify(String extractedText) {
//     final normText = extractedText.replaceAll("\n", " ").toLowerCase();
//
//     // Company registration keywords (must all be present)
//     final keywords = [
//       "government of india",
//       "central registration centre",
//       "certificate of incorporation",
//       "corporate identity number",
//       "permanent account number",
//       "tax deduction and collection account number"
//     ];
//
//     // ✅ Check that *every* keyword exists in extracted text
//     final missingKeywords = keywords
//         .where((k) => !normText.contains(k.toLowerCase()))
//         .toList();
//
//     final hasAllKeywords = missingKeywords.isEmpty;
//
//     // Example Company Registration Number regex (adjust if needed)
//     // Usually CIN is 21 characters: L00000MH2000PLC123456
//     final cinRegex = RegExp(r"\b([A-Z]{1}[0-9]{5}[A-Z]{2}[0-9]{4}[A-Z]{3}[0-9]{6})\b");
//     final cinMatch = cinRegex.firstMatch(extractedText.toUpperCase());
//
//     // Debugging
//     DebugConfig.debugLog("📌 Missing keywords: $missingKeywords");
//
//     return cinMatch != null && hasAllKeywords;
//   }
//
//   /// Extract Company Registration Number (CIN)
//   static String? extractCIN(String extractedText) {
//     final cinRegex = RegExp(r"\b([A-Z]{1}[0-9]{5}[A-Z]{2}[0-9]{4}[A-Z]{3}[0-9]{6})\b");
//     final match = cinRegex.firstMatch(extractedText.toUpperCase());
//     if (match != null) {
//       return match.group(0);
//     }
//     return null;
//   }
// }

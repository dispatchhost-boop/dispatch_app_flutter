import 'package:dispatch/const/debug_config.dart';

class GstVerifier {
  /// GST keywords (for OCR validation, required)
  static final List<String> keywords = [
    "government of india",
    "form gst reg-06",
    "registration certificate",
    "registration number",
    "constitution of business",
    "date of issue of certificate",
    "legal name",
    "date of liability",
    "date of validity",
    "type of registration",
  ];

  /// Verify GST text:
  /// - ALL keywords must be present
  /// - GST number format must be valid
  static bool verify(String extractedText) {
    final normText = extractedText.replaceAll("\n", " ").toLowerCase();

    // ✅ Require ALL keywords to exist
    final hasAllKeywords = keywords.every(
          (k) => normText.contains(k.toLowerCase()),
    );

    // ✅ GSTIN regex
    final gstRegex = RegExp(
      r"\b([0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1})\b",
    );

    final gstMatch = gstRegex.firstMatch(extractedText.toUpperCase());

    // Debugging
    DebugConfig.debugLog("📌 All GST keywords present: $hasAllKeywords");

    return gstMatch != null && hasAllKeywords;
  }

  // /// Extract GST number
  // static String? extractGstNumber(String extractedText) {
  //   final gstRegex = RegExp(
  //     r"\b([0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1})\b",
  //   );
  //   final match = gstRegex.firstMatch(extractedText.toUpperCase());
  //   if (match != null) {
  //     return match.group(0);
  //   }
  //   return null;
  // }
}

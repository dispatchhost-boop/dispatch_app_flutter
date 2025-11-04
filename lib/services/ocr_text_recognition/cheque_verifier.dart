import 'package:dispatch/const/debug_config.dart';

class ChequeVerifier {
  /// Common cheque keywords
  static final List<String> keywords = [
    "pay",
    "rupees",
    "ifsc",
    "रुपये",
    "अदा करें",
  ];

  /// Regex for IFSC code (e.g. SBIN0001234)
  static final RegExp ifscRegex = RegExp(r"\b[A-Z]{4}0[A-Z0-9]{6}\b");

  /// Regex for MICR (9 digits)
  static final RegExp micrRegex = RegExp(r"\b\d{9}\b");

  /// Regex for Account number (9–18 digits)
  static final RegExp accountRegex = RegExp(r"\b\d{9,18}\b");

  /// Verify cheque OCR text
  // static bool verify(String extractedText) {
  //   final normText = extractedText.replaceAll("\n", " ").toLowerCase();
  //
  //   // Find missing keywords
  //   final missingKeywords = keywords
  //       .where((k) => !normText.contains(k.toLowerCase()))
  //       .toList();
  //
  //   // ✅ must contain at least some cheque keywords
  //   final hasKeywords = keywords.any((k) => normText.contains(k.toLowerCase()));
  //
  //   // ✅ must contain IFSC or MICR
  //   // final hasIfsc = ifscRegex.hasMatch(extractedText.toUpperCase());
  //   final possibleIfsc = RegExp(r"[A-Z]{4}[0O][A-Z0-9]{6}").firstMatch(extractedText.toUpperCase())?.group(0);
  //   final hasIfsc = possibleIfsc != null && possibleIfsc.length == 11;
  //
  //   final hasMicr = micrRegex.hasMatch(extractedText);
  //
  //   // ✅ must contain account number
  //   final hasAccount = accountRegex.hasMatch(extractedText);
  //
  //   DebugConfig.debugLog("📌 Cheque keywords found: $hasKeywords");
  //   DebugConfig.debugLog("📌 Missing cheque keywords: $missingKeywords");
  //   DebugConfig.debugLog("📌 IFSC found: $hasIfsc $possibleIfsc, MICR found: $hasMicr, Account found: $hasAccount");
  //
  //   return hasKeywords && (hasIfsc || hasMicr) && hasAccount;
  // }

  static bool verify(String extractedText, String expectedChequeNo6) {
    final normText = extractedText.replaceAll("\n", " ").toLowerCase();

    final missingKeywords = keywords.where((k) => !normText.contains(k.toLowerCase())).toList();
    final hasKeywords = keywords.any((k) => normText.contains(k.toLowerCase()));

    final possibleIfsc = RegExp(r"[A-Z]{4}[0O][A-Z0-9]{6}").firstMatch(extractedText.toUpperCase())?.group(0);
    final hasIfsc = possibleIfsc != null && possibleIfsc.length == 11;

    final hasMicr = micrRegex.hasMatch(extractedText);
    final hasAccount = accountRegex.hasMatch(extractedText);

    final chequeNo = extractChequeNumber(extractedText);
    final chequeNoMatches = chequeNo == expectedChequeNo6;

    DebugConfig.debugLog("📌 Cheque keywords found: $hasKeywords");
    DebugConfig.debugLog("📌 Missing cheque keywords: $missingKeywords");
    DebugConfig.debugLog("📌 IFSC found: $hasIfsc $possibleIfsc, MICR found: $hasMicr, Account found: $hasAccount");
    DebugConfig.debugLog("📌 ChequeNo extracted: $chequeNo, matches user: $chequeNoMatches");

    return hasKeywords && (hasIfsc || hasMicr) && hasAccount && chequeNoMatches;
  }


  /// Extract IFSC
  static String? extractIfsc(String extractedText) {
    // Replace common OCR error: 'O' with '0' at 5th position of IFSC
    final possibleIfsc = RegExp(r"[A-Z]{4}[0O][A-Z0-9]{6}").firstMatch(extractedText.toUpperCase())?.group(0);
    if (possibleIfsc != null && possibleIfsc.length == 11) {
      // Correct 'O' (capital o) to '0'
      final corrected = '${possibleIfsc.substring(0, 4)}0${possibleIfsc.substring(5)}';
      return corrected;
    }
    return null;
  }

  /// Extract MICR
  static String? extractMicr(String extractedText) {
    final match = micrRegex.firstMatch(extractedText);
    return match?.group(0);
  }

  /// Extract Account number
  static String? extractAccount(String extractedText) {
    final match = accountRegex.firstMatch(extractedText);
    return match?.group(0);
  }

  static String? extractChequeNumber(String extractedText) {
    final cleaned = extractedText.replaceAll(RegExp(r'[^\d]'), ' ').replaceAll(RegExp(r'\s+'), ' ');
    final match = RegExp(r'(\d[\d ]{5,})').firstMatch(cleaned);
    if (match != null) {
      final digits = match.group(0)!.replaceAll(' ', '');
      if (digits.length >= 6) {
        return digits.substring(0, 6);
      }
    }
    return null;
  }

}

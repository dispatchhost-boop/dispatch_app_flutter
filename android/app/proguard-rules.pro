# Please add these rules to your existing keep rules in order to suppress warnings.
# This is generated automatically by the Android Gradle plugin.

# --- ML Kit (Text Recognition) ---
-dontwarn com.google.mlkit.vision.text.japanese.JapaneseTextRecognizerOptions$Builder
-dontwarn com.google.mlkit.vision.text.japanese.JapaneseTextRecognizerOptions
-dontwarn com.google.mlkit.vision.text.korean.KoreanTextRecognizerOptions$Builder
-dontwarn com.google.mlkit.vision.text.korean.KoreanTextRecognizerOptions

# --- PDFBox / ReadPdfText ---
# Ignore missing JPEG2000 decoder (Gemalto)
-dontwarn com.gemalto.jp2.**
# Ignore JPXFilter warnings if JPEG2000 decoder is not present
-dontwarn com.tom_roush.pdfbox.filter.JPXFilter
# Ignore Java ImageIO APIs (not available on Android)
-dontwarn javax.imageio.**
# Ignore JAI ImageIO (desktop only, not used on Android)
-dontwarn com.github.jaiimageio.**
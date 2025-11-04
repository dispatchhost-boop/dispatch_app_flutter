plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.dispatch"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString() // "11"
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.dispatch"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 21
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

//    flavorDimensions "env"
//    productFlavors {
//        dev {
//            dimension "env"
//            applicationId "com.example.dispatch_dev"
//            versionNameSuffix "-sit"
//            resValue "string", "app_name", "Dispatch Dev"
//        }
//        prod {
//            dimension "env"
//            applicationId "com.example.dispatch"
//            resValue "string", "app_name", "Dispatch"
//
//        }
//    }
//
//    // used to get different name for apk at time of build apk of dev and prod
//    applicationVariants.all { variant ->
//        variant.outputs.all { output ->
//            if (output.outputFileName != null && output.outputFileName.endsWith('.apk')) {
//                def newFileName = variant.productFlavors[0].name == "dev" ? "dispatch_dev.apk" : "Dispatch.apk"
//                output.outputFileName = newFileName
//            }
//        }
//    }

    // ✅ Flavors
    flavorDimensions += "env"

    productFlavors {
        create("dev") {
            dimension = "env"
            applicationId = "com.example.dispatch_dev"
            versionNameSuffix = "-dev"
            resValue("string", "app_name", "Dispatch Dev")
        }
        create("prod") {
            dimension = "env"
            applicationId = "com.example.dispatch"
            resValue("string", "app_name", "Dispatch")
        }
    }

// ✅ Custom APK names (Kotlin DSL safe)
    applicationVariants.all {
        val variant = this
        variant.outputs.all {
            val output = this as com.android.build.gradle.internal.api.BaseVariantOutputImpl

            val flavorName = variant.flavorName ?: "noflavor"
            val buildTypeName = variant.buildType.name

            val newName = when (flavorName) {
                "dev" -> "dispatch_dev-${buildTypeName}.apk"
                "prod" -> "dispatch_prod-${buildTypeName}.apk"
                else -> "dispatch-${buildTypeName}.apk"
            }

            output.outputFileName = newName
        }
    }



}

flutter {
    source = "../.."
}

dependencies{
    implementation("com.google.mlkit:face-detection:16.1.6")
    implementation("com.google.mlkit:text-recognition-devanagari:16.0.1")
    implementation("com.google.mlkit:text-recognition-chinese:16.0.1")
    // PDFBox Android
    implementation("com.tom-roush:pdfbox-android:2.0.27.0")

    // JPEG2000 decoder (needed for JPXFilter)
//    implementation("com.github.jai-imageio:jai-imageio-jpeg2000:1.4.0")
}

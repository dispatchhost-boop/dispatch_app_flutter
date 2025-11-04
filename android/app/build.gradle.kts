plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
//    namespace = "com.dispatchsolutions.live"
    namespace = "com.dispatchsolutions.live"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
//        applicationId = "com.dispatchsolutions.live"
        applicationId = "com.dispatchsolutions.live"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        debug {
            // Debug builds should not minify/shrink to avoid APK not generating
            isMinifyEnabled = false
            isShrinkResources = false
        }
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

    buildFeatures {
        viewBinding = true
        dataBinding = true
    }

    // Handle duplicate resource files (like BouncyCastle .properties)
    packaging {
        resources {
            pickFirsts += listOf("**/*.properties")
        }
    }

    flavorDimensions += "env"

    productFlavors {
        create("dev") {
            dimension = "env"
//            applicationId = "com.dispatchsolutions.live_dev"
            applicationId = "com.dispatchsolutions.dev"
            versionNameSuffix = "-dev"
            resValue("string", "app_name", "Dispatch Dev")
        }
        create("prod") {
            dimension = "env"
//            applicationId = "com.dispatchsolutions.live"
            applicationId = "com.dispatchsolutions.live"
            resValue("string", "app_name", "Dispatch")
        }
    }

    // Custom APK names
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

dependencies {
    implementation("com.google.mlkit:face-detection:16.1.6")
    implementation("com.google.mlkit:text-recognition-devanagari:16.0.1")
    implementation("com.google.mlkit:text-recognition-chinese:16.0.1")
    implementation("com.tom-roush:pdfbox-android:2.0.27.0")
    implementation("com.github.digio-tech:protean-esign:v3.2")
    // implementation("com.github.jai-imageio:jai-imageio-jpeg2000:1.4.0") // optional
}

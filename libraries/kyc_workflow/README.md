# digio kyc workflow plugin

Digio kyc workflow flutter plugin

# Getting Started

## Android
* Digio SDK supports android version 7.0 and above (SDK level 24 above)

1. Add it to your root build.gradle at the end of repositories:

```allprojects {
allprojects {
  repositories {
     ...
     maven { url 'https://jitpack.io' }
  }
}
```
2. Add the dependency:

```
implementation 'com.github.digio-tech:protean-esign:v3.2'
```

3. Check your app’s build.gradle file (android/apps/build.gradle) to confirm a declaration similar
   to the following (depending on the build configuration you’ve selected):

```
android {
    compileSdk = 35

    defaultConfig {
        minSdk = 24
    }
  
   buildTypes {
        release {
            signingConfig signingConfigs.debug
            minifyEnabled true
        }
        debug {
            signingConfig signingConfigs.debug
            minifyEnabled true
        }
    }
        
    buildFeatures {
        viewBinding true
        dataBinding true
    }
    
    dependencies {
     implementation 'com.github.digio-tech:protean-esign:v3.2'
    }
}
```


4. Module Build Gradle (android/build.gradle) has following

```
buildscript {
    ext.kotlin_version = "1.8.22"
    dependencies {
        classpath("com.android.tools.build:gradle:8.1.0")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version")
    }
}
```

Note: Kotlin plugin should be added at your project level inside build gradle

5. Add required permissions in manifest file and run time.
```
<!--RECORD_AUDIO and MODIFY_AUDIO_SETTINGS Permission required for Video KYC -->
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
/** Required for geotagging */
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />

/** Required for ID card analysis, selfie and face match**/
<uses-permission android:name="android.permission.CAMERA" />
<uses-feature android:name="android.hardware.camera.autofocus"   android:required="false" />

<uses-permission android:name="android.permission.READ_MEDIA_AUDIO" />
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />

```

A fintech Android app can't access the following permission
- Read_external_storage
- Read_media_images
- Read_contacts
- Access_fine_location
- Read_phone_numbers
- Read_media_videos

## You get a build error due to a theme issue.
- Please add tools:replace="android:theme" under your android manifest.
```
<application
....
tools:replace="android:label,android:theme"
...
>
.....
</application>

```

## If you face a crash related to the AppCompat theme while using eSign in an Activity, add this under the application tag in the manifest
```
    <application
        ...
        android:theme="@style/Theme.AppCompat.Light.NoActionBar"
        ...
        >
        ...
    </application>    
```

## Proguard :
It is required to test the release build for possible proguard exceptions before prod releases.
```
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
-keepattributes JavascriptInterface
-keepattributes *Annotation*
-keepattributes Signature
-optimizations !method/inlining/*
-keeppackagenames
-keepnames class androidx.navigation.fragment.NavHostFragment
-keep class * extends androidx.fragment.app.Fragment{}
-keepnames class * extends android.os.Parcelable
-keepnames class * extends java.io.Serializable
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
-dontwarn androidx.databinding.**
-keep class androidx.databinding.** { *; }
-keepclassmembers class * extends androidx.databinding.** { *; }
-dontwarn org.json.**
-keep class org.json** { *; }
-keep public class org.simpleframework.**{ *; }
-keep class org.simpleframework.xml.**{ *; }
-keep class org.simpleframework.xml.core.**{ *; }
-keep class org.simpleframework.xml.util.**{ *; }
-dontwarn com.google.android.gms.**
-keep class com.google.android.gms.** { *; }
-keep class com.google.android.material.** { *; }
-dontwarn org.simpleframework.**
-keepattributes ElementList, Root
-keepclassmembers class * {
    @org.simpleframework.xml.* *;
}
-keep class org.spongycastle.** { *; }
-keep class com.ecs.rdlibrary.request.** { *; }
-keep class com.ecs.rdlibrary.response.** { *; }
-keep class com.ecs.rdlibrary.utils.** { *; }
-keep class com.ecs.rdlibrary.ECSBioCaptureActivity { *; }
-keep class org.simpleframework.xml.** { *; }
-keepattributes Exceptions, InnerClasses
-keep class com.google.android.gms.location.LocationSettingsRequest$Builder { *; }
-keepnames class ** { *; }
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
-keepattributes RuntimeVisibleAnnotations, RuntimeVisibleParameterAnnotations
-keepattributes AnnotationDefault
-keepclassmembers,allowshrinking,allowobfuscation interface * {
    @retrofit2.http.* <methods>;
}
-dontwarn javax.annotation.**
-dontwarn kotlin.Unit
-dontwarn retrofit2.KotlinExtensions
-dontwarn retrofit2.KotlinExtensions$*
-if interface * { @retrofit2.http.* <methods>; }
-keep,allowobfuscation interface <1>
-if interface * { @retrofit2.http.* <methods>; }
-keep,allowobfuscation interface * extends <1>
-keep,allowobfuscation,allowshrinking class kotlin.coroutines.Continuation
-if interface * { @retrofit2.http.* public *** *(...); }
-keep,allowoptimization,allowshrinking,allowobfuscation class <3>
-keep,allowobfuscation,allowshrinking class retrofit2.Response
-adaptresourcefilenames okhttp3/internal/publicsuffix/PublicSuffixDatabase.gz
-dontwarn org.codehaus.mojo.animal_sniffer.*
-dontwarn okhttp3.internal.platform.**
-dontwarn org.conscrypt.**
-dontwarn org.bouncycastle.**
-dontwarn org.openjsse.**
-keep class * extends androidx.databinding.DataBinderMapper
-keep class javax.xml.bind.annotation.** { *; }
-dontwarn javax.xml.bind.annotation.**
-keep class com.ecs.cdslxsds.ESignProcessorResponse { *; }
-dontwarn org.xmlpull.v1.XmlPullParser
-dontwarn android.content.res.XmlResourceParser

```

## IOS

In case of iOS, No need to put SDK. You can proceed with writing the code below.

DigioKycSDK requires permission mentioned below. Make sure to add these permissions in your app's
info.plist

```
<key>NSCameraUsageDescription</key>
<string>$(PRODUCT_NAME) would like to access your camera.</string>   
<key>NSPhotoLibraryUsageDescription</key> 
<string>$(PRODUCT_NAME) would like to access your photo.</string>   
<key>NSMicrophoneUsageDescription</key>
<string>$(PRODUCT_NAME) would like to access your microphone to capture video.</string>
<key>NSLocationWhenInUseUsageDescription</key> 
<string>$(PRODUCT_NAME) would like to access your location.</string> 
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>$(PRODUCT_NAME) would like to access your location.</string>
```

#### Add LSApplicationQueriesSchemes in your iOS app's Info.plist file
```
<key>LSApplicationQueriesSchemes</key>
    <array>
        <string>phonepe</string>
        <string>gpay</string>
        <string>paytmmp</string>
        <string>bhim</string>
        <string>upi</string>
        <string>ppe</string>
    </array>

```

Refer ios guide for ios folder
[iOS Guide](https://docs.google.com/document/d/1hxOX_fORqSc-dVJj3gT3uw2QF3LV_HaRJTWroGvX-Qk)

* Digio SDK support for xcode 14.0 and above, Swift version 5.7

### Starting the digio kyc workflow

```
HashMap<String, String> additionalData = HashMap<String, String>(); 
additionalData["dg_disable_upi_collect_flow"] = "false"; // optional for mandate

var digioConfig = DigioConfig();
digioConfig.theme.primaryColor = "#32a83a";
digioConfig.logo = "https://your_logo_url";
digioConfig.environment = Environment.SANDBOX;
digioConfig.serviceMode = ServiceMode.OTP; // FP/FACE/IRIS/OTP

final _kycWorkflowPlugin = KycWorkflow(digioConfig);
_kycWorkflowPlugin.setGatewayEventListener((GatewayEvent? gatewayEvent) {
    print("gateway event : " + gatewayEvent.toString());
});
workflowResult = await _kycWorkflowPlugin.start("KID23010416361850266BAKNKNORLP6W","abc@gmail.com","GWT230104163618520T2Y9IPUT2PBNC8",additionalData);
print('workflowResult : ' + workflowResult.toString());
```


| **Field**      | **Example Value**                                                                                | **Description**                                                                                                                                                                               |
|----------------|--------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **documentId** | DID22040413040490937VNTC6LAP8KWD                                                                 | String format (Request ID Passed by parent app)                                                                                                                                               |
| **message**    | Signing Success                                                                                  | **Signing Failure**  <br> **Failure** = Digio SDK crash <br> **Webpage could not be loaded** = Web page not loaded due to internet connection issue even after 3 retries.                     |
| **code**       | 1001 <br> (App should only depend upon the code,<br/>not on message to check failure or success) | DigioConstants.RESPONSE_CODE_SUCCESS = 1001  <br> RESPONSE_CODE_CANCEL = -1000  <br> RESPONSE_CODE_FAIL = 1002  <br> RESPONSE_CODE_WEB_VIEW_CRASH = 1003  <br> RESPONSE_CODE_SDK_CRASH = 1004 |
| **screen**     | document_preview                                                                                 | -                                                                                                                                                                                             |
| **npciTxnId**  | -                                                                                                | String                                                                                                                                                                                        |
| **stacktrace** | -                                                                                                | In case of Digio SDK crashes, the crash log                                                                                                                                                   |



[Gateway Event Doc](https://docs.google.com/document/d/15LHtjGyXd_JNM0de8uH9zB7WllJikRl1d9e4qdy0-C0)

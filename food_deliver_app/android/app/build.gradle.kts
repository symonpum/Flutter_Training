plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.food_deliver_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.food_deliver_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Signing with debug key for now
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // Rename APK files automatically
    applicationVariants.all {
        outputs.all {
            val newName = "food_deliver_${name}.apk"  // name = debug or release
            (this as com.android.build.gradle.internal.api.BaseVariantOutputImpl).outputFileName = newName
        }
    }
}

dependencies {
    // Google Play Services for Google Maps
    implementation("com.google.android.gms:play-services-maps:18.2.0")
}

flutter {
    source = "../.."
}

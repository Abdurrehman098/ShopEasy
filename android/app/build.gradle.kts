plugins {
    id("com.android.application")

    id("com.google.gms.google-services")

    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.shop_easy"

    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.shopeasy.user"

        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    flavorDimensions += "app"

    productFlavors {

        create("user") {
            dimension = "app"
            applicationId = "com.shopeasy.user"
        }

        create("admin") {
            dimension = "app"
            applicationId = "com.shopeasy.admin"
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget =
            org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
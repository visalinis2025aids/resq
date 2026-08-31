plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}


android {

    namespace = "com.visalini.safebee"

    compileSdk = flutter.compileSdkVersion

    ndkVersion = flutter.ndkVersion


    compileOptions {

        // Required for flutter_local_notifications
        isCoreLibraryDesugaringEnabled = true

        sourceCompatibility = JavaVersion.VERSION_17

        targetCompatibility = JavaVersion.VERSION_17
    }



    defaultConfig {

        applicationId = "com.visalini.safebee"

        minSdk = flutter.minSdkVersion

        targetSdk = flutter.targetSdkVersion

        versionCode = flutter.versionCode

        versionName = flutter.versionName
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



dependencies {

    coreLibraryDesugaring(
        "com.android.tools:desugar_jdk_libs:2.1.4"
    )

}
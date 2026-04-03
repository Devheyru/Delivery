android {
    namespace = "com.example.minoo_deleivery"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    packaging {
        jniLibs {
            useLegacyPackaging = false
        }
    }

    defaultConfig {
        applicationId = "com.example.minoo_deleivery"
        minSdk = 23
        targetSdk = 35
        versionCode = 1
        versionName = "1.0"
    }

    signingConfigs {
        create("release") {
            // ⚠️ Replace this with your real release keystore when publishing
            keyAlias = "androiddebugkey"
            keyPassword = "android"
            storeFile = file(System.getProperty("user.home") + "/.android/debug.keystore")
            storePassword = "android"
        }
    }

    buildTypes {
        getByName("debug") {
            // ✅ DISABLE splits for debug builds - this creates universal APK
            splits.abi.isEnable = false
            splits.density.isEnable = false
            signingConfig = signingConfigs.getByName("release")
        }

        getByName("release") {
            // Use release signing (currently debug keystore for testing)
            signingConfig = signingConfigs.getByName("release")

            // ✅ Enable shrinking & minification
            isMinifyEnabled = true
            isShrinkResources = true

            // ✅ ProGuard/R8 rules
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )

            // ✅ Keep splits ENABLED only for release (optional)
            splits.abi.isEnable = true
            splits.abi.reset()
            splits.abi.include("armeabi-v7a", "arm64-v8a") // Remove x86_64 if not needed
            splits.abi.isUniversalApk = false
        }
    }
}
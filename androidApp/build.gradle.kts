plugins {
//    kotlin("android")
    kotlin("multiplatform")
    id("com.android.application")
    id("org.jetbrains.compose")
    kotlin("plugin.serialization")
}

kotlin {
    androidTarget()
    sourceSets {
        val androidMain by getting {
            dependencies {
                implementation(project(":shared"))
            }
        }
    }
}

android {
    namespace = "net.wangyl.poetrie.android"
    compileSdk = (findProperty("android.compileSdk") as String).toInt()
    sourceSets["main"].manifest.srcFile("src/main/AndroidManifest.xml")

    defaultConfig {
        applicationId = "net.wangyl.poetrie.android"
        minSdk = (findProperty("android.minSdk") as String).toInt()
        targetSdk = (findProperty("android.targetSdk") as String).toInt()
        versionCode = 1
        versionName = "1.0"
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlin {
        jvmToolchain(17)
    }
//    buildFeatures {
//        compose = true
//    }
//    composeOptions {
//        kotlinCompilerExtensionVersion = "1.4.7"
//    }
//    packaging {
//        resources {
//            excludes += "/META-INF/{AL2.0,LGPL2.1}"
//        }
//    }
//    buildTypes {
//        getByName("release") {
//            isMinifyEnabled = false
//        }
//    }
}
dependencies {
    implementation("androidx.compose.ui:ui-tooling-preview-android:1.5.1")
}

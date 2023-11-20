import net.wangyl.poetrie.Deps
import net.wangyl.poetrie.Versions

plugins {
    kotlin("multiplatform")
    kotlin("native.cocoapods")
    id("com.android.library")
    id("org.jetbrains.compose")
    id("kotlinx-serialization")
    kotlin("plugin.serialization")
    id("app.cash.sqldelight")
//    id("org.jetbrains.kotlin.android")
}

kotlin {
    androidTarget()
//    targetHierarchy.default()

    iosX64()
    iosArm64()
    iosSimulatorArm64()

    cocoapods {
        summary = "Some description for the Shared Module"
        homepage = "Link to the Shared Module homepage"
        version = "1.0"
        ios.deploymentTarget = "14.1"
        podfile = project.file("../iosApp/Podfile")
        framework {
            baseName = "shared"
            isStatic = true
        }
        extraSpecAttributes["resources"] = "['src/commonMain/resources/**', 'src/iosMain/resources/**']"
    }
    
    sourceSets {
        all {
            languageSettings.optIn("kotlinx.cinterop.ExperimentalForeignApi")
        }
        val koin_version = "3.5.0"
        val voyagerVersion = "1.0.0-rc10"
        val commonMain by getting {
            dependencies {
                //put your multiplatform dependencies here
                dependencies {
                    api("org.jetbrains.kotlin:kotlin-stdlib:${Versions.kotlin}")
                    // Navigator
                    implementation("cafe.adriel.voyager:voyager-navigator:$voyagerVersion")
                    // BottomSheetNavigator
                    implementation("cafe.adriel.voyager:voyager-bottom-sheet-navigator:$voyagerVersion")
                    // TabNavigator
                    implementation("cafe.adriel.voyager:voyager-tab-navigator:$voyagerVersion")
                    // Transitions
                    implementation("cafe.adriel.voyager:voyager-transitions:$voyagerVersion")
                    implementation("org.jetbrains.kotlinx:kotlinx-datetime:0.4.0")

                    api(compose.runtime)
                    api(compose.foundation)
                    api(compose.material)
                    api(compose.material3)
                    api(compose.materialIconsExtended)
                    @OptIn(org.jetbrains.compose.ExperimentalComposeLibrary::class)
                    api(compose.components.resources)
                    implementation("org.jetbrains.compose.components:components-resources:1.6.0-dev1275")

                    implementation("media.kamel:kamel-image:0.6.0")
                    api("com.rickclephas.kmm:kmm-viewmodel-core:1.0.0-ALPHA-15")

                    // Ktor
                    with(Deps.Io.Ktor) {
                        api(ktorClientCore)
                        api(ktorSerializationKotlinxJson)
                        api(ktorClientContentNegotiation)
                        api(ktorClientLogging)
                    }
                    // Logback for ktor logging
                    implementation(Deps.Logback.logbackClassic)

                    // SqlDelight
                    with(Deps.CashApp.SQLDelight) {
                        api(coroutinesExtensions)
                        api(primitiveAdapters)
                    }
                    // Koin
                    with(Deps.Koin) {
                        api(core)
                        api(compose)
                        api(test)
                    }

                    // KotlinX Serialization Json
                    implementation(Deps.Org.JetBrains.Kotlinx.kotlinxSerializationJson)

                    // Coroutines
                    implementation(Deps.Org.JetBrains.Kotlinx.coroutinesCore)

                    // MVIKotlin
                    with(Deps.ArkIvanov.MVIKotlin) {
                        api(mvikotlin)
                        api(mvikotlinMain)
                        api(mvikotlinExtensionsCoroutines)
                    }

                    // Decompose
                    with(Deps.ArkIvanov.Decompose) {
                        api(decompose)
                        api(extensionsCompose)
                    }

                    // Image Loading
                    api(Deps.Github.imageLoader)
                    implementation(Deps.ArkIvanov.Essenty.lifecycle)

                    implementation("org.jetbrains.kotlinx:kotlinx-serialization-json:1.6.0")
                    api("dev.icerock.moko:mvvm-core:0.16.1") // only ViewModel, EventsDispatcher, Dispatchers.UI
                    api("dev.icerock.moko:mvvm-compose:0.16.1") // api mvvm-core, getViewModel for Compose Multiplatfrom
                }
            }
        }
        val commonTest by getting {
            dependencies {
                api(kotlin("test"))
            }
        }
        val androidMain by getting {
            dependencies {
                api("androidx.activity:activity-compose:1.8.1")
                api("androidx.appcompat:appcompat:1.6.1")
                api("androidx.core:core-ktx:1.12.0")
                implementation("androidx.camera:camera-camera2:1.3.0")
                implementation("androidx.camera:camera-lifecycle:1.3.0")
                implementation("androidx.camera:camera-view:1.3.0")
                implementation("com.google.accompanist:accompanist-permissions:0.29.2-rc")

                // Ktor
                api(Deps.Io.Ktor.ktorClientAndroid)

                // SqlDelight
                api(Deps.CashApp.SQLDelight.androidDriver)

                // Koin
                api(Deps.Koin.core)
                api(Deps.Koin.android)
            }
        }
        val iosMain by creating {
            dependsOn(commonMain)
            dependencies {
                // Ktor
                implementation(Deps.Io.Ktor.ktorClientDarwin)

                // SqlDelight
                implementation(Deps.CashApp.SQLDelight.nativeDriver)
            }
        }
        val iosX64Main by getting {
            dependsOn(iosMain)
        }
        val iosArm64Main by getting {
            dependsOn(iosMain)
        }
        val iosSimulatorArm64Main by getting {
            dependsOn(iosMain)
        }
    }

    targets.filterIsInstance<org.jetbrains.kotlin.gradle.plugin.mpp.KotlinNativeTarget>().forEach{
        it.binaries.filterIsInstance<org.jetbrains.kotlin.gradle.plugin.mpp.Framework>()
            .forEach { lib ->
                lib.isStatic = false
                lib.linkerOpts.add("-lsqlite3")
            }
    }
}

android {
    compileSdk = (findProperty("android.compileSdk") as String).toInt()
    namespace = "net.wangyl.poetrie"

    sourceSets["main"].manifest.srcFile("src/androidMain/AndroidManifest.xml")
    sourceSets["main"].res.srcDirs("src/androidMain/res")
    sourceSets["main"].resources.srcDirs("src/commonMain/resources")

    defaultConfig {
        minSdk = (findProperty("android.minSdk") as String).toInt()
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlin {
        jvmToolchain(17)
    }
}
dependencies {
    implementation("androidx.core:core-ktx:+")
    implementation("androidx.core:core-ktx:+")
}

sqldelight {
    databases {
        create("PoetrieDatabase") {
            packageName.set("net.wangyl.poetrie.core.database")
        }
    }
    linkSqlite = true
}
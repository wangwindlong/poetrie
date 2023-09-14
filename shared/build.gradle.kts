import net.wangyl.poetrie.Deps

plugins {
    kotlin("multiplatform")
    kotlin("native.cocoapods")
    id("com.android.library")
    id("org.jetbrains.compose")
    id("kotlinx-serialization")
    kotlin("plugin.serialization")
    id("app.cash.sqldelight")
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
        val koin_version = "3.5.0"
        val commonMain by getting {
            dependencies {
                //put your multiplatform dependencies here
                dependencies {
                    api(compose.runtime)
                    api(compose.foundation)
                    api(compose.material)
                    api(compose.material3)
                    api(compose.materialIconsExtended)
                    @OptIn(org.jetbrains.compose.ExperimentalComposeLibrary::class)
                    api(compose.components.resources)

                    implementation("media.kamel:kamel-image:0.6.0")

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
                api("androidx.activity:activity-compose:1.7.2")
                api("androidx.appcompat:appcompat:1.6.1")
                api("androidx.core:core-ktx:1.12.0")
                // Ktor
                api(Deps.Io.Ktor.ktorClientAndroid)

                // SqlDelight
                api(Deps.CashApp.SQLDelight.androidDriver)

                // Koin
                api(Deps.Koin.core)
                api(Deps.Koin.android)
            }
        }
        val iosX64Main by getting
        val iosArm64Main by getting
        val iosSimulatorArm64Main by getting {
        }
        val iosMain by creating {
            dependsOn(commonMain)
            iosX64Main.dependsOn(this)
            iosArm64Main.dependsOn(this)
            iosSimulatorArm64Main.dependsOn(this)

            dependencies {
                // Ktor
                implementation(Deps.Io.Ktor.ktorClientDarwin)

                // SqlDelight
                implementation(Deps.CashApp.SQLDelight.nativeDriver)
            }
        }
//        val desktopMain by getting {
//            dependsOn(commonMain)
//
//            dependencies {
//                // Ktor
//                api(Deps.Io.Ktor.ktorClientJava)
//
//                // SqlDelight
//                api(Deps.CashApp.SQLDelight.sqliteDriver)
//            }
//        }
//        val iosTest by getting {
//            dependsOn(commonTest)
//        }
//        val iosSimulatorArm64Test by getting {
//            dependsOn(iosTest)
//        }
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

sqldelight {
    databases {
        create("PoetrieDatabase") {
            packageName.set("net.wangyl.poetrie.core.database")
        }
    }
}
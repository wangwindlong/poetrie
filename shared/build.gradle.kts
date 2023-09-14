plugins {
    kotlin("multiplatform")
    kotlin("native.cocoapods")
    id("com.android.library")
    id("org.jetbrains.compose")
    id("kotlinx-serialization")
    kotlin("plugin.serialization")

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
                    @OptIn(org.jetbrains.compose.ExperimentalComposeLibrary::class)
                    api(compose.components.resources)

                    implementation("media.kamel:kamel-image:0.6.0")
                    implementation("io.ktor:ktor-client-core:2.3.3")
                    implementation("io.ktor:ktor-client-content-negotiation:2.3.1")
                    implementation("io.ktor:ktor-serialization-kotlinx-json:2.3.1")
                    implementation("org.jetbrains.kotlinx:kotlinx-serialization-json:1.6.0")
                    api("dev.icerock.moko:mvvm-core:0.16.1") // only ViewModel, EventsDispatcher, Dispatchers.UI
                    api("dev.icerock.moko:mvvm-compose:0.16.1") // api mvvm-core, getViewModel for Compose Multiplatfrom
                    implementation ("org.jetbrains.kotlinx:kotlinx-serialization-json:1.6.0")
//                    implementation("io.insert-koin:koin-core:$koin_version")
                    // for android compose
//                    implementation("io.insert-koin:koin-androidx-compose:1.1.0")
                    // Koin for Ktor
//                    implementation("io.insert-koin:koin-ktor:$koin_version")
                    // SLF4J Logger
//                    implementation("io.insert-koin:koin-logger-slf4j:$koin_version")
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
                api("androidx.activity:activity-compose:1.6.1")
                api("androidx.appcompat:appcompat:1.6.1")
                api("androidx.core:core-ktx:1.12.0")
                implementation("io.ktor:ktor-client-android:2.3.1")
                implementation("io.insert-koin:koin-core:$koin_version")

            }
        }
        val iosX64Main by getting
        val iosArm64Main by getting
        val iosSimulatorArm64Main by getting
        val iosMain by creating {
            dependsOn(commonMain)
            iosX64Main.dependsOn(this)
            iosArm64Main.dependsOn(this)
            iosSimulatorArm64Main.dependsOn(this)

            dependencies {
                implementation("io.ktor:ktor-client-darwin:2.3.3")
            }
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
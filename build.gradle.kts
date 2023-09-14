plugins {
    //trick: for the same plugin versions in all sub-modules
//    id("com.android.application").version("8.1.1").apply(false)
//    id("com.android.library").version("8.1.1").apply(false)
//    kotlin("android").version("1.8.21").apply(false)
//    kotlin("multiplatform").version("1.8.21").apply(false)

    kotlin("multiplatform").apply(false)
    id("com.android.application").apply(false)
    id("com.android.library").apply(false)
    id("org.jetbrains.compose").apply(false)
    kotlin("plugin.serialization")
}

tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}

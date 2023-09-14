package net.wangyl.poetrie

import platform.UIKit.UIDevice
import androidx.compose.ui.window.ComposeUIViewController

class IOSPlatform: Platform {
    override val name: String = UIDevice.currentDevice.systemName() + " " + UIDevice.currentDevice.systemVersion
}

actual fun getPlatform(): Platform = IOSPlatform()

fun MainViewController() = ComposeUIViewController { App() }
package net.wangyl.poetrie.android

import android.app.Application
import android.content.Context
import android.content.pm.ApplicationInfo
import net.wangyl.poetrie.core.di.initKoin
import org.koin.android.ext.koin.androidContext
import org.koin.android.ext.koin.androidLogger
import org.koin.core.logger.Level

class MainApp: Application() {

    override fun onCreate() {
        super.onCreate()
        initKoin {
            androidLogger(if (isDebug()) Level.DEBUG else Level.ERROR)
            androidContext(this@MainApp)
        }
    }

}

fun Context.isDebug() = 0 != applicationInfo.flags and ApplicationInfo.FLAG_DEBUGGABLE
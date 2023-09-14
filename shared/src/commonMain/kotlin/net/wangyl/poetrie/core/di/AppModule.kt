package net.wangyl.poetrie.core.di

import net.wangyl.poetrie.core.database.databaseModule
import net.wangyl.poetrie.core.network.networkModule
import org.koin.core.context.startKoin
import org.koin.dsl.KoinAppDeclaration

fun initKoin(enableNetworkLogs: Boolean = false, appDeclaration: KoinAppDeclaration = {}) =
    startKoin {
        appDeclaration()
        modules(
            databaseModule,
            networkModule(enableNetworkLogs),
            dataModule
        )
    }
package net.wangyl.poetrie.core.database

import org.koin.dsl.module

val databaseModule = module {
    factory { sqlDriverFactory() }
    single { createDatabase(driver = get()) }
    single { PokemonDao(pokemonDatabase = get()) }
//    single { PokemonInfoDao(pokemonDatabase = get()) }
}
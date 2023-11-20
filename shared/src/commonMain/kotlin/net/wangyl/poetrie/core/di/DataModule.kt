package net.wangyl.poetrie.core.di

import net.wangyl.poetrie.core.repository.CuiRepository
import net.wangyl.poetrie.core.repository.CuiRepositoryImpl
import net.wangyl.poetrie.core.repository.PokemonRepository
import net.wangyl.poetrie.core.repository.PokemonRepositoryImpl
import org.koin.dsl.module

val dataModule = module {
    single<PokemonRepository> { PokemonRepositoryImpl() }
    single<CuiRepository> { CuiRepositoryImpl() }
}
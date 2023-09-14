package net.wangyl.poetrie.core.repository

import net.wangyl.poetrie.core.database.PokemonDao
import net.wangyl.poetrie.core.network.HttpLoader
import net.wangyl.poetrie.core.network.model.Pokemon
import net.wangyl.poetrie.model.toPokemon
import net.wangyl.poetrie.model.toPokemonEntity
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class PokemonRepositoryImpl : PokemonRepository, KoinComponent {
    private val pokemonClient by inject<HttpLoader>()
    private val pokemonDao by inject<PokemonDao>()
//    private val pokemonInfoDao by inject<PokemonInfoDao>()

    override suspend fun getPokemonList(page: Long): Result<List<Pokemon>> {
        return try {
            val cachedPokemonList = pokemonDao.selectAllByPage(page)

            if (cachedPokemonList.isEmpty()) {
                val response = pokemonClient.getPokemonList(page = page)
                response.results.forEach { pokemon ->
                    pokemonDao.insert(pokemon.toPokemonEntity(page))
                }

                Result.success(pokemonDao.selectAllByPage(page).map { it.toPokemon() })
            } else {
                Result.success(cachedPokemonList.map { it.toPokemon() })
            }
        } catch (e: Exception) {
            e.printStackTrace()
            Result.failure(e)
        }
    }
}
package net.wangyl.poetrie.core.database

import kotlinx.coroutines.withContext
import net.wangyl.poetrie.poetrieDispatchers
import netwangylpoetriecoredatabase.PoetrieEntity

class PokemonDao(
    private val pokemonDatabase: PoetrieDatabase
) {
    private val query get() = pokemonDatabase.poetriesQueries

    suspend fun selectAllByPage(page: Long) = withContext(poetrieDispatchers.io) {
        query.selectAllByPage(page = page).executeAsList()
    }

    suspend fun insert(pokemonEntity: PoetrieEntity) = withContext(poetrieDispatchers.io) {
        query.insert(pokemonEntity)
    }
}
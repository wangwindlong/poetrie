package net.wangyl.poetrie.core.repository

import io.ktor.client.HttpClient
import io.ktor.client.request.get
import io.ktor.http.ContentType
import io.ktor.http.contentType
import kotlinx.coroutines.flow.Flow
import net.wangyl.poetrie.core.network.handleErrors
import net.wangyl.poetrie.core.network.model.PokemonResponse
import net.wangyl.poetrie.core.network.NetworkConstants
import net.wangyl.poetrie.core.network.model.Pokemon

interface PokemonRepository {
    suspend fun getPokemonList(page: Long): Result<List<Pokemon>>

//    suspend fun getPokemonFlowByName(name: String): Result<PokemonInfo>
//    suspend fun getFavoritePokemonListFlow(): Flow<List<Pokemon>>
//    suspend fun updatePokemonFavoriteState(name: String, isFavorite: Boolean)
}
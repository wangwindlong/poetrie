package net.wangyl.poetrie.core.network

import io.ktor.client.*
import io.ktor.client.request.*
import io.ktor.http.*
import net.wangyl.poetrie.core.network.model.PokemonResponse

class HttpLoader(private val httpClient: HttpClient) {

    suspend fun getPokemonList(
        page: Long,
    ): PokemonResponse {
        return handleErrors {
            httpClient.get(NetworkConstants.Pokemon.route) {
                url {
                    parameters.append("limit", PageSize.toString())
                    parameters.append("offset", (page * PageSize).toString())
                }
                contentType(ContentType.Application.Json)
            }
        }
    }

//    suspend fun getPokemonByName(
//        name: String,
//    ): PokemonInfo {
//        return handleErrors {
//            httpClient.get(NetworkConstants.Pokemon.byName(name)) {
//                contentType(ContentType.Application.Json)
//            }
//        }
//    }

    companion object {
        private const val PageSize = 20
    }

}
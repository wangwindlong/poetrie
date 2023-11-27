package net.wangyl.poetrie.core.network

import io.ktor.client.*
import io.ktor.client.call.body
import io.ktor.client.request.*
import io.ktor.client.request.forms.MultiPartFormDataContent
import io.ktor.client.request.forms.formData
import io.ktor.http.*
import net.wangyl.poetrie.core.network.model.PokemonResponse
import net.wangyl.poetrie.model.BaseCuiModel
import net.wangyl.poetrie.model.CuiModel
import net.wangyl.poetrie.model.CuiPicParams
import net.wangyl.poetrie.net.Api

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

    suspend fun getOrderInfo(barCode: String = "202311171753273"): BaseCuiModel<CuiModel> {
        return handleErrors {
            httpClient.get(Api.ORDER_INFO) {
                url {
                    parameters.append("barCode", barCode)
                }
                contentType(ContentType.Application.Json)
            }
        }
    }

    suspend fun uploadImages(params: CuiPicParams): BaseCuiModel<String> {
        return handleErrors {
            httpClient.post(Api.UPLOAD_PIC_INFO) {
                contentType(ContentType.Application.Json)
                setBody(params)
            }
        }
    }

    companion object {
        private const val PageSize = 20
    }

}
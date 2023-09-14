package net.wangyl.poetrie.core.network

import io.ktor.client.call.body
import io.ktor.client.statement.HttpResponse
import io.ktor.utils.io.errors.IOException
import kotlinx.coroutines.withContext
import net.wangyl.poetrie.poetrieDispatchers

suspend inline fun <reified T> handleErrors(
    crossinline response: suspend () -> HttpResponse
): T = withContext(poetrieDispatchers.io) {

    val result = try {
        response()
    } catch(e: IOException) {
        throw PoetrieException(PoetrieError.ServiceUnavailable)
    }

    when(result.status.value) {
        in 200..299 -> Unit
        in 400..499 -> throw PoetrieException(PoetrieError.ClientError)
        500 -> throw PoetrieException(PoetrieError.ServerError)
        else -> throw PoetrieException(PoetrieError.UnknownError)
    }

    return@withContext try {
        result.body()
    } catch(e: Exception) {
        throw PoetrieException(PoetrieError.ServerError)
    }

}

enum class PoetrieError {
    ServiceUnavailable,
    ClientError,
    ServerError,
    UnknownError
}

class PoetrieException(error: PoetrieError): Exception(
    "Something goes wrong: $error"
)
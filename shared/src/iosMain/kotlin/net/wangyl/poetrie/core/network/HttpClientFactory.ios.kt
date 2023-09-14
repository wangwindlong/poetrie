package net.wangyl.poetrie.core.network

import io.ktor.client.*
import io.ktor.client.engine.darwin.Darwin

actual fun createPlatformHttpClient(): HttpClient {
    return HttpClient(Darwin)
}
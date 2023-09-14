package net.wangyl.poetrie

import kotlinx.coroutines.CoroutineDispatcher

interface PoetrieDispatchers {
    val main: CoroutineDispatcher
    val io: CoroutineDispatcher
    val unconfined: CoroutineDispatcher
}

expect val poetrieDispatchers: PoetrieDispatchers
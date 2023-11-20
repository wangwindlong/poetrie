package net.wangyl.poetrie.core.repository

import net.wangyl.poetrie.core.network.HttpLoader
import net.wangyl.poetrie.core.network.PoetrieError
import net.wangyl.poetrie.core.network.PoetrieException
import net.wangyl.poetrie.model.CuiModel
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class CuiRepositoryImpl: CuiRepository, KoinComponent {
    private val cuiClient by inject<HttpLoader>()

    override suspend fun getOrderInfo(barCode: String): CuiModel {
        return cuiClient.getOrderInfo(barCode).data ?: CuiModel(0)
    }
}
package net.wangyl.poetrie.core.repository

import net.wangyl.poetrie.core.network.HttpLoader
import net.wangyl.poetrie.core.network.PoetrieError
import net.wangyl.poetrie.core.network.PoetrieException
import net.wangyl.poetrie.model.BaseCuiModel
import net.wangyl.poetrie.model.CuiModel
import net.wangyl.poetrie.model.CuiPicParams
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class CuiRepositoryImpl: CuiRepository, KoinComponent {
    private val cuiClient by inject<HttpLoader>()

    override suspend fun getOrderInfo(barCode: String): CuiModel {
        return cuiClient.getOrderInfo(barCode).data ?: CuiModel(0)
    }

    override suspend fun uploadImages(params: CuiPicParams): BaseCuiModel<String> {
        return cuiClient.uploadImages(params)
    }
}
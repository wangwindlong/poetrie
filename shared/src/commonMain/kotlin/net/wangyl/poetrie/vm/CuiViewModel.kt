package net.wangyl.poetrie.vm

import dev.icerock.moko.mvvm.viewmodel.ViewModel
import io.ktor.client.HttpClient
import io.ktor.client.call.body
import io.ktor.client.plugins.contentnegotiation.ContentNegotiation
import io.ktor.client.request.get
import io.ktor.serialization.kotlinx.json.json
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import net.wangyl.poetrie.model.BirdImage
import kotlinx.serialization.json.Json
import net.wangyl.poetrie.core.repository.CuiRepository
import net.wangyl.poetrie.model.BaseCuiModel
import net.wangyl.poetrie.model.CuiModel
import net.wangyl.poetrie.model.CuiPicModel
import net.wangyl.poetrie.model.CuiPicParams
import net.wangyl.poetrie.net.Api
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

data class CuiUiState(
    val model: CuiModel = CuiModel(id = 0),
    val selectedCategory: String? = null
) {
}

class CuiViewModel : ViewModel(), KoinComponent {
    private val _uiState = MutableStateFlow(CuiUiState())
    val uiState = _uiState.asStateFlow()
    val cuiRepository: CuiRepository by inject()

    init {
        loadOrerInfo()
    }

    fun selectCategory(category: String) {
        _uiState.update {
            it.copy(selectedCategory = category)
        }
    }

    fun loadOrerInfo() {
        viewModelScope.launch {
            val info = cuiRepository.getOrderInfo("202311171753273")
            print("loadOrerInfo result = $info")
            _uiState.update {
                it.copy(model = info)
            }
        }
    }

    private fun getParams(): CuiPicParams {
        return CuiPicParams(id = 111.toLong(),
            fcPic = CuiPicModel(PICLIST = arrayOf("url1", "url2")),
            fcVideo = CuiPicModel(PICLIST = arrayOf("videoUrl1", "videoUrl2")),
            sring = CuiPicModel(PICLIST = arrayOf("largevideoUrl1", "largevideoUrl2")),
            isSring = "1",
            )
    }

    fun uploadImages(params: CuiPicParams = getParams()) {
        print("uploadImages params = $params")
        viewModelScope.launch {
            val info = cuiRepository.uploadImages(params)
            print("uploadImages result = $info")
//            _uiState.update {
//                it.copy(model = info)
//            }
        }
    }
//    private suspend fun getOrderInfo(): CuiModel {
//        val orderInfo = httpClient
//            .get("${Api.ORDER_INFO}?barCode=202311171753273")
//            .body<BaseCuiModel<CuiModel>>()
//        return orderInfo.result()
//    }
}
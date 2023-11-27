package net.wangyl.poetrie.core.repository

import net.wangyl.poetrie.model.BaseCuiModel
import net.wangyl.poetrie.model.CuiModel
import net.wangyl.poetrie.model.CuiPicParams

// 翡翠相关api
interface CuiRepository {
    suspend fun getOrderInfo(barCode: String): CuiModel
    suspend fun uploadImages(params: CuiPicParams): BaseCuiModel<String>

//    suspend fun getPokemonFlowByName(name: String): Result<PokemonInfo>
//    suspend fun getFavoritePokemonListFlow(): Flow<List<Pokemon>>
//    suspend fun updatePokemonFavoriteState(name: String, isFavorite: Boolean)
}
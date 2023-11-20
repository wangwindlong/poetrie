package net.wangyl.poetrie.model

import kotlinx.serialization.Serializable


@Serializable
data class BaseCuiModel<T>(val message: String, val code: Int = 0, val data: T? = null) {
    inline fun <reified T: Any> result() : T {
        return (data!!) as (T)
    }
}

@Serializable
data class CuiModel(val id: Long,
//                    val fcPic: String? = null,
//                    val fcVideo: String? = null,
                    val barCode: String? = null,
                    val createTime: String? = null,
                    val updateTime: String? = null,
                    val rktime: String? = null,
                    val goodsAddress: GoodsAddress? = null,
                    val ringsize: String? = null,
                    val jbtime: String? = null,
                    val lid: Int = 0,
                    val offerNum: Int = 0,
                    val priceMax: Int = 0,
                    val priceMin: Int = 0,
                    val fcState: String? = null,
                    val fcShow: String? = null,
                    val fcSize: String? = null,
                    val fcTypeName: String? = null,
                    val fcName: String? = null,
                    val fcType: String? = null,
                    ) {
}

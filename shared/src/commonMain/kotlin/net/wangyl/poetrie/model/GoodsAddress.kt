package net.wangyl.poetrie.model

import kotlinx.serialization.Serializable

@Serializable
data class GoodsAddress(
    val deleted: Int,
    val id: Int,
    val tenantId: Int,
//    val address: Any,
    val barcode: String? = null,
    val state: String? = null,
    val createTime: String? = null,
    val updateTime: String? = null,
    val waboutMsg: String? = null
)
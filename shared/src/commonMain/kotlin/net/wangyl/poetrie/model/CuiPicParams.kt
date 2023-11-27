package net.wangyl.poetrie.model

import kotlinx.serialization.Serializable

@Serializable
data class CuiPicParams(
    val id: Long,
    val fcPic: CuiPicModel,
    val fcVideo: CuiPicModel? = null,
    val sring: CuiPicModel? = null,
    val isSring: String = ""
)

@Serializable
data class CuiPicModel(val PICLIST: Array<String>) {
    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (other == null || this::class != other::class) return false

        other as CuiPicModel

        if (!PICLIST.contentEquals(other.PICLIST)) return false

        return true
    }

    override fun hashCode(): Int {
        return PICLIST.contentHashCode()
    }
}

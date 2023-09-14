package net.wangyl.poetrie.core.network.model

import kotlinx.serialization.Serializable

@Serializable
data class PokemonResponse(
    val count: Int,
    val next: String?,
    val previous: String?,
    val results: List<Pokemon>
)


@Serializable
data class Pokemon(
    var page: Long = 0,
    val name: String,
    val url: String
) {

    private val number get() =
        url.split("/").dropLast(1).last()

    val numberString get() = when(number.length) {
        1 -> "#00$number"
        2 -> "#0$number"
        else -> "#$number"
    }

    val imageUrl get() =
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$number.png"
}

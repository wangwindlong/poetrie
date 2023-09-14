package net.wangyl.poetrie.model

import net.wangyl.poetrie.core.network.model.Pokemon
import netwangylpoetriecoredatabase.PoetrieEntity

fun PoetrieEntity.toPokemon() = Pokemon(
    page = page,
    name = name,
    url = url
)

fun Pokemon.toPokemonEntity(page: Long) = PoetrieEntity(
    page = page,
    name = name,
    url = url
)
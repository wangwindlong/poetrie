package net.wangyl.poetrie

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform
package net.wangyl.poetrie.core.database

import app.cash.sqldelight.db.SqlDriver
import org.koin.core.scope.Scope

expect fun Scope.sqlDriverFactory(): SqlDriver

fun createDatabase(driver: SqlDriver): PoetrieDatabase {
    val database = PoetrieDatabase(
        driver = driver,
    )

    return database
}
package net.wangyl.poetrie.core.di

import net.wangyl.poetrie.core.repository.CuiRepository
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class DIHelper: KoinComponent {
    val cuiRepository: CuiRepository by inject()
}
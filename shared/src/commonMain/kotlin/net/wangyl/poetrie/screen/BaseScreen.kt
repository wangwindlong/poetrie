package net.wangyl.poetrie.screen

import androidx.compose.runtime.Composable
import cafe.adriel.voyager.core.screen.Screen
import cafe.adriel.voyager.core.screen.uniqueScreenKey
import cafe.adriel.voyager.core.stack.Stack
import cafe.adriel.voyager.navigator.LocalNavigator
import cafe.adriel.voyager.navigator.currentOrThrow

abstract class BaseScreen: Screen {
    override val key = uniqueScreenKey

//    @Composable
//    fun navigate(navigator: Stack<Screen>, screen: Screen) {
////        val navigator = LocalNavigator.currentOrThrow
//        navigator.push(screen)
//    }
}
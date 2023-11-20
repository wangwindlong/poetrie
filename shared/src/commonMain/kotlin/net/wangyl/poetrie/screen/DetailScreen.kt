package net.wangyl.poetrie.screen

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import cafe.adriel.voyager.core.screen.Screen
import cafe.adriel.voyager.core.screen.uniqueScreenKey
import dev.icerock.moko.mvvm.compose.getViewModel
import dev.icerock.moko.mvvm.compose.viewModelFactory
import net.wangyl.poetrie.vm.CuiViewModel

data class DetailScreen(val index: Int): Screen {
    override val key = uniqueScreenKey

    @Composable
    override fun Content() {
        val viewModel = getViewModel(Unit, viewModelFactory { CuiViewModel() })
        CuiPage(viewModel)
        viewModel.loadOrerInfo()
    }

    @Composable
    fun CuiPage(viewModel: CuiViewModel) {
        val uiState by viewModel.uiState.collectAsState()

        Column(
            Modifier.fillMaxSize().background(Color.LightGray),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {

        }
    }
}


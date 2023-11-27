package net.wangyl.poetrie.screen

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.wrapContentWidth
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.Button
import androidx.compose.material.ButtonDefaults
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.SideEffect
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import cafe.adriel.voyager.navigator.LocalNavigator
import cafe.adriel.voyager.navigator.currentOrThrow
import dev.icerock.moko.mvvm.compose.getViewModel
import dev.icerock.moko.mvvm.compose.viewModelFactory
import net.wangyl.poetrie.core.di.DIHelper
import net.wangyl.poetrie.vm.CuiViewModel

data class MainScreen(var index: Int, val wrapContent: Boolean = false): BaseScreen() {
    @Composable
    override fun Content() {
        val navigator = LocalNavigator.currentOrThrow
        val viewModel = getViewModel(Unit, viewModelFactory { CuiViewModel() })
        Row(
            Modifier.fillMaxWidth().height(160.dp).padding(5.dp),
            horizontalArrangement = Arrangement.Start
        ) {
            Button(
                shape = RoundedCornerShape(16.dp),
                onClick = {
//                    viewModel.selectCategory(category)
//                    navigator.push(DetailScreen(1))
                    viewModel.uploadImages()
                },
                modifier = Modifier.weight(0.3f).fillMaxSize(),
                elevation = ButtonDefaults.elevation(
                    defaultElevation = 0.dp,
                    focusedElevation = 0.dp
                )
            )
            {
//                    Image(
//                        painterResource("compose-multiplatform.xml"),
//                        null
//                    )
                Text("扫码拍照")
            }
        }

    }
}
package net.wangyl.poetrie.view

import androidx.compose.runtime.Composable

@Composable
expect fun Tooltip(
    text: String,
    content: @Composable () -> Unit
)

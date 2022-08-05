package ru.madbrains.appmetrica_push_android

import android.os.Handler
import android.os.Looper
import com.yandex.metrica.push.TokenUpdateListener
import com.yandex.metrica.push.YandexMetricaPush
import io.flutter.Log
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.channels.trySendBlocking
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.callbackFlow

class TokenManager {
    private val _tag = "AppmetricaPush.TokenManager"

    private val mainHandler = Handler(Looper.getMainLooper())

    var tokens: Flow<Map<String, String>>? = null

    fun isClosed(): Boolean {
        return tokens == null
    }

    fun init() {
        tokens = null
        tokens = tokensFlow()

        Log.d(_tag, "init")
    }

    fun dispose() {
        tokens = null

        Log.d(_tag, "dispose")
    }

    @OptIn(ExperimentalCoroutinesApi::class)
    private fun tokensFlow(): Flow<Map<String, String>> = callbackFlow {
        val listener = TokenUpdateListener { token -> mainHandler.post { trySendBlocking(token) } }

        YandexMetricaPush.setTokenUpdateListener(listener)

        awaitClose { YandexMetricaPush.setTokenUpdateListener {} }
    }
}
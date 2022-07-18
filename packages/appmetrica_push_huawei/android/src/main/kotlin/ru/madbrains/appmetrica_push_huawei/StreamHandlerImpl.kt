package ru.madbrains.appmetrica_push_huawei

import android.content.Context
import androidx.annotation.Nullable
import io.flutter.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.collect

class StreamHandlerImpl(private val tokenManager: TokenManager) : EventChannel.StreamHandler {
    private val _tag = "AppmetricaPushHuawei.StreamHandlerImpl"

    @Nullable
    private var channel: EventChannel? = null

    @Nullable
    private var context: Context? = null

    @OptIn(DelicateCoroutinesApi::class)
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        if (!tokenManager.isClosed()) {
            GlobalScope.launch {
                withContext(Dispatchers.Main) {
                    try {
                        tokenManager.tokens?.collect { it -> events?.success(it) }
                    } catch (e: Throwable) {
                        events?.error(_tag, e.localizedMessage, e.stackTraceToString())
                    }
                }
            }

        }
    }

    override fun onCancel(arguments: Any?) {
        disposeListeners()
    }

    fun startListening(context: Context?, messenger: BinaryMessenger?) {
        if (channel != null) {
            Log.d(_tag, "Setting a event call handler before the last was disposed.")
            stopListening()
        }
        channel = EventChannel(messenger, Constants.EVENT_CHANNEL)
        channel?.setStreamHandler(this)
        this.context = context
    }

    fun stopListening() {
        if (channel == null) {
            Log.d(_tag, "Tried to stop listening when no EventChannel had been initialized.")
            return
        }
        disposeListeners()
        channel?.setStreamHandler(null)
        channel = null
    }

    private fun disposeListeners() {
        Log.d(_tag, "AppMetrica push token update stopped")
    }
}
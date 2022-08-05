package ru.madbrains.appmetrica_push_huawei

import android.app.Activity
import android.content.Context
import androidx.annotation.Nullable
import androidx.core.app.NotificationManagerCompat
import com.yandex.appmetrica.push.hms.HmsPushServiceControllerProvider
import com.yandex.metrica.push.YandexMetricaPush
import io.flutter.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result

class MethodCallHandlerImpl(private val tokenManager: TokenManager) :
    MethodChannel.MethodCallHandler {
    private val _tag = "AppmetricaPushHuawei.MethodCallHandlerImpl"

    @Nullable
    private var channel: MethodChannel? = null

    @Nullable
    private var context: Context? = null

    @Nullable
    private var activity: Activity? = null

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            Constants.ACTIVATE -> onActivate(result)
            Constants.GET_TOKENS -> onGetTokens(result)
            Constants.REQUEST_PERMISSION -> onRequestPermission(result, call.arguments as String?)
        }
    }

    fun startListening(context: Context?, messenger: BinaryMessenger?) {
        if (channel != null) {
            Log.d(_tag, "Setting a method call handler before the last was disposed.")
            stopListening()
        }
        channel = MethodChannel(messenger!!, Constants.METHOD_CHANNEL)
        channel?.setMethodCallHandler(this)
        this.context = context!!
    }

    fun stopListening() {
        if (channel == null) {
            Log.d(_tag, "Tried to stop listening when no MethodChannel had been initialized.")
            return
        }
        channel?.setMethodCallHandler(null)
        channel = null
    }

    fun setActivity(@Nullable activity: Activity?) {
        this.activity = activity
    }

    private fun onActivate(result: Result) {
        try {
            context?.let { YandexMetricaPush.init(it, HmsPushServiceControllerProvider(it)) }

            Log.d(_tag, "Activate AppMetrica Push")
            Log.d(_tag, YandexMetricaPush.getDefaultNotificationChannel().toString())

            tokenManager.init()

            result.success(null)

            LateInvoker.invokeAll()
        } catch (e: Throwable) {
            result.error(_tag, e.localizedMessage, e.stackTraceToString())
        }
    }

    private fun onGetTokens(result: Result) {
        try {
            val tokens: MutableMap<String, String>? = YandexMetricaPush.getTokens()

            Log.d(_tag, "tokens: $tokens")

            result.success(tokens)
        } catch (e: Throwable) {
            result.error(_tag, e.localizedMessage, e.stackTraceToString())
        }
    }

    private fun onRequestPermission(result: Result, arguments: String?) {
        val areNotificationsEnabled: Boolean =
            activity?.let { NotificationManagerCompat.from(it).areNotificationsEnabled() } == true

        result.success(areNotificationsEnabled)
    }

    fun onMessageOpenedApp(message: String) {
        channel?.invokeMethod(Constants.ON_MESSAGE_OPENED_APP, message)
    }

    fun onMessage(message: String) {
        channel?.invokeMethod(Constants.ON_MESSAGE, message)
    }
}
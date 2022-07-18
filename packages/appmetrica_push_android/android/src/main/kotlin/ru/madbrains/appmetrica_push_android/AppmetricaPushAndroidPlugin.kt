package ru.madbrains.appmetrica_push_android

import android.app.Activity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import androidx.annotation.NonNull
import androidx.annotation.Nullable
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import com.yandex.metrica.push.YandexMetricaPush
import io.flutter.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry

class AppmetricaPushAndroidPlugin : FlutterPlugin, ActivityAware, PluginRegistry.NewIntentListener,
    BroadcastReceiver() {
    private val _tag = "AppmetricaPush.AppmetricaPushAndroidPlugin"

    private var tokenManager: TokenManager = TokenManager()

    @Nullable
    private var methodCallHandler: MethodCallHandlerImpl? = null

    @Nullable
    private var streamHandler: StreamHandlerImpl? = null

    @Nullable
    private var mainActivity: Activity? = null


    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        methodCallHandler = MethodCallHandlerImpl(tokenManager)
        methodCallHandler?.startListening(
            flutterPluginBinding.applicationContext, flutterPluginBinding.binaryMessenger
        )
        streamHandler = StreamHandlerImpl(tokenManager)
        streamHandler?.startListening(
            flutterPluginBinding.applicationContext, flutterPluginBinding.binaryMessenger
        )

        val intentFilter = IntentFilter()
        intentFilter.addAction(Utils.ACTION_REMOTE_MESSAGE)
        val manager =
            ContextHolder.applicationContext?.let { LocalBroadcastManager.getInstance(it) }
        manager?.registerReceiver(this, intentFilter)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        LocalBroadcastManager.getInstance(binding.applicationContext).unregisterReceiver(this)

        dispose()
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        Log.d(_tag, "Attaching AppMetrica Push to activity")

        binding.addOnNewIntentListener(this)

        mainActivity = binding.activity

        setActivityToHandlers(mainActivity)

        val intent: Intent? = mainActivity?.intent

        if (intent != null) {
            if (YandexMetricaPush.OPEN_DEFAULT_ACTIVITY_ACTION == intent.action) {
                onNewIntent(intent)
            } else {
                if (intent.flags and Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY
                    !== Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY
                ) {
                    onNewIntent(intent)
                }
            }
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        mainActivity = null

        setActivityToHandlers(mainActivity)

        Log.d(_tag, "Detaching AppMetrica Push from activity")
    }

    override fun onNewIntent(intent: Intent): Boolean {
        if (intent.extras == null) {
            return false
        }

        val payload: String = intent.getStringExtra(YandexMetricaPush.EXTRA_PAYLOAD) ?: return false
        val actionInfo: String? = intent.getStringExtra(YandexMetricaPush.EXTRA_ACTION_INFO)

        Log.d(_tag, "payload: $payload, info: $actionInfo")

        LateInvoker.invoke { methodCallHandler?.onMessageOpenedApp(payload) }

        mainActivity?.intent = intent

        return true
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        val action = intent?.action ?: return

        if (action == Utils.ACTION_REMOTE_MESSAGE) {
            val message: String =
                intent.getStringExtra(Utils.EXTRA_REMOTE_MESSAGE)
                    ?: return

            Log.d(_tag, "message: $message")

            LateInvoker.invoke { methodCallHandler?.onMessage(message) }
        }
    }

    private fun setActivityToHandlers(@Nullable activity: Activity?) {
        methodCallHandler?.setActivity(activity)
    }

    private fun dispose() {
        methodCallHandler?.stopListening()
        streamHandler?.stopListening()

        setActivityToHandlers(null)

        tokenManager.dispose()

        methodCallHandler = null
        streamHandler = null

        LateInvoker.dispose()

        Log.d(_tag, "Disposing AppMetrica Push services")
    }
}

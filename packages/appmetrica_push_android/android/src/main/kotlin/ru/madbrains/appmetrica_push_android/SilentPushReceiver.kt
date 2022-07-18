package ru.madbrains.appmetrica_push_android

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import com.yandex.metrica.push.YandexMetricaPush
import io.flutter.Log


class SilentPushReceiver : BroadcastReceiver() {
    private val _tag = "AppmetricaPush.SilentPushReceiver"

    override fun onReceive(context: Context, intent: Intent) {
        Log.d(_tag, "broadcast received for message")

        if (ContextHolder.applicationContextEmpty()) {
            ContextHolder.applicationContext = context.applicationContext
        }

        val payload: String? = intent.getStringExtra(YandexMetricaPush.EXTRA_PAYLOAD)

        if (payload == null) {
            Log.d(
                _tag,
                "broadcast received but intent contained no extras to process RemoteMessage. Operation cancelled."
            )
            return
        }

        Log.d(_tag, "payload: $payload")

        //  |-> ---------------------
        //      App in Foreground
        //   ------------------------
        if (Utils.isApplicationForeground(context)) {
            val onMessageIntent = Intent(Utils.ACTION_REMOTE_MESSAGE)
            onMessageIntent.putExtra(
                Utils.EXTRA_REMOTE_MESSAGE,
                payload
            )
            LocalBroadcastManager.getInstance(context).sendBroadcast(onMessageIntent)
            return
        }

        //  |-> ---------------------
        //    App in Background/Quit
        //   ------------------------
//        val onBackgroundMessageIntent = Intent(
//            context,
//            BackgroundService
//        )
//        onBackgroundMessageIntent.putExtra(
//            Utils.EXTRA_REMOTE_MESSAGE, payload
//        )
//        BackgroundService.enqueueMessageProcessing(
//            context, onBackgroundMessageIntent
//        )
    }
}
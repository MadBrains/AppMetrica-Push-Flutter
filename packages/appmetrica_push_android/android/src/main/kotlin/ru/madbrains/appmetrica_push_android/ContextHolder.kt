package ru.madbrains.appmetrica_push_android

import android.content.Context
import io.flutter.Log

object ContextHolder {
    private val _tag = "AppmetricaPush.ContextHolder"

    var applicationContext: Context? = null
        set(applicationContext) {
            Log.d(_tag, "received application context.")
            field = applicationContext
        }

    fun applicationContextEmpty(): Boolean {
        return applicationContext == null
    }
}
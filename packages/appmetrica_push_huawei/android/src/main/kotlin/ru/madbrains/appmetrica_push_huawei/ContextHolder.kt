package ru.madbrains.appmetrica_push_huawei

import android.content.Context
import io.flutter.Log

object ContextHolder {
    private val _tag = "AppmetricaPushHuawei.ContextHolder"

    var applicationContext: Context? = null
        set(applicationContext) {
            Log.d(_tag, "received application context.")
            field = applicationContext
        }

    fun applicationContextEmpty(): Boolean {
        return applicationContext == null
    }
}
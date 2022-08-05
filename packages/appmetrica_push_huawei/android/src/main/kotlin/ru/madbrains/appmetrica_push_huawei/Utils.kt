package ru.madbrains.appmetrica_push_huawei

import android.app.ActivityManager
import android.app.KeyguardManager
import android.content.Context

class Utils {
    companion object {
        const val ACTION_REMOTE_MESSAGE = "ru.madbrains.appmetrica_push_huawei.NOTIFICATION"
        const val EXTRA_REMOTE_MESSAGE = "notification"

        fun isApplicationForeground(context: Context): Boolean {
            val keyguardManager: KeyguardManager =
                context.getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
            if (keyguardManager.isKeyguardLocked) {
                return false
            }
            val activityManager: ActivityManager =
                context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
                    ?: return false
            val appProcesses: List<ActivityManager.RunningAppProcessInfo> =
                activityManager.runningAppProcesses
                    ?: return false
            val packageName: String = context.packageName
            for (appProcess in appProcesses) {
                if (appProcess.importance === ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND
                    && appProcess.processName.equals(packageName)
                ) {
                    return true
                }
            }
            return false
        }
    }
}
package ru.madbrains.appmetrica_push_android

import android.content.ContentProvider
import android.content.ContentValues
import android.content.Context
import android.content.pm.ProviderInfo
import android.database.Cursor
import android.net.Uri
import androidx.annotation.Nullable


class InitProvider : ContentProvider() {
    override fun attachInfo(context: Context?, info: ProviderInfo?) {
        super.attachInfo(context, info)
    }

    override fun onCreate(): Boolean {
        if (ContextHolder.applicationContextEmpty()) {
            var context: Context? = context
            if (context?.applicationContext != null) {
                context = context.applicationContext
            }
            ContextHolder.applicationContext = context
        }
        return false
    }

    @Nullable
    override fun query(
        uri: Uri,
        projection: Array<String?>?,
        selection: String?,
        selectionArgs: Array<String?>?,
        sortOrder: String?
    ): Cursor? {
        return null
    }

    @Nullable
    override fun getType(uri: Uri): String? {
        return null
    }

    @Nullable
    override fun insert(uri: Uri, values: ContentValues?): Uri? {
        return null
    }

    override fun delete(uri: Uri, selection: String?, selectionArgs: Array<String?>?): Int {
        return 0
    }

    override fun update(
        uri: Uri, values: ContentValues?, selection: String?, selectionArgs: Array<String?>?
    ): Int {
        return 0
    }
}
package ru.madbrains.appmetrica_push_huawei

object LateInvoker {
    private val list: MutableList<() -> Unit> = mutableListOf()
    private var isInvoked = false

    fun invoke(fn: () -> Unit) {
        if (isInvoked) {
            fn()
        } else {
            list.add(fn)
        }
    }

    fun invokeAll() {
        isInvoked = true
        for (fn in list) {
            fn()
        }
    }

    fun dispose() {
        list.clear()
        isInvoked = false
    }
}
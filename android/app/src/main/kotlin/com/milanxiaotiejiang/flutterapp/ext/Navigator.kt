package com.kotlin.base.ext

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.os.Parcelable
import androidx.fragment.app.Fragment
import java.io.Serializable

/**
 * User: milan
 * Time: 2020/3/24 17:04
 * Des:
 */
fun <T> createIntent(ctx: Context, clazz: Class<out T>, params: HashMap<String, Any?>): Intent {
    val intent = Intent(ctx, clazz)
    if (params.isNotEmpty()) fillIntentArguments(intent, params)
    return intent
}

fun fillIntentArguments(intent: Intent, params: HashMap<String, Any?>) {
    params.forEach {
        when (val value = it.value) {
            null -> intent.putExtra(it.key, null as Serializable?)
            is Int -> intent.putExtra(it.key, value)
            is Long -> intent.putExtra(it.key, value)
            is CharSequence -> intent.putExtra(it.key, value)
            is String -> intent.putExtra(it.key, value)
            is Float -> intent.putExtra(it.key, value)
            is Double -> intent.putExtra(it.key, value)
            is Char -> intent.putExtra(it.key, value)
            is Short -> intent.putExtra(it.key, value)
            is Boolean -> intent.putExtra(it.key, value)
            is Serializable -> intent.putExtra(it.key, value)
            is Bundle -> intent.putExtra(it.key, value)
            is Parcelable -> intent.putExtra(it.key, value)
            is Array<*> -> when {
                value.isArrayOf<CharSequence>() -> intent.putExtra(it.key, value)
                value.isArrayOf<String>() -> intent.putExtra(it.key, value)
                value.isArrayOf<Parcelable>() -> intent.putExtra(it.key, value)
                else -> throw IntentException("Intent extra ${it.key} has wrong type ${value.javaClass.name}")
            }
            is IntArray -> intent.putExtra(it.key, value)
            is LongArray -> intent.putExtra(it.key, value)
            is FloatArray -> intent.putExtra(it.key, value)
            is DoubleArray -> intent.putExtra(it.key, value)
            is CharArray -> intent.putExtra(it.key, value)
            is ShortArray -> intent.putExtra(it.key, value)
            is BooleanArray -> intent.putExtra(it.key, value)
            else -> throw IntentException("Intent extra ${it.key} has wrong type ${value.javaClass.name}")
        }
        return@forEach
    }
}

open class IntentException(message: String = "") : RuntimeException(message)

fun Intent.clearTop(): Intent = apply { addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP) }
fun Intent.singleTop(): Intent = apply { addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP) }
fun Intent.clearTask(): Intent = apply { addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK) }
//fun Intent.clearWhenTaskReset(): Intent = apply { addFlags(Intent.FLAG_ACTIVITY_CLEAR_WHEN_TASK_RESET) }
fun Intent.newDocument(): Intent = apply { addFlags(Intent.FLAG_ACTIVITY_NEW_DOCUMENT) }
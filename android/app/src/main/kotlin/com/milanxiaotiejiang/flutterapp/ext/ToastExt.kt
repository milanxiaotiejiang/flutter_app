package com.kotlin.base.ext

import android.content.Context
import android.widget.Toast
import androidx.fragment.app.Fragment
import com.milanxiaotiejiang.flutterapp.App.Companion.mApp
import me.drakeet.support.toast.ToastCompat

/**
 * User: milan
 * Time: 2019/9/10 15:11
 * Des:
 */
fun Context.toast(value: CharSequence) = toast { value }

fun Fragment.toast(value: CharSequence) = toast { value }

fun Context.toast(value: Int) = toastInt { value }

fun Fragment.toast(value: Int) = toastInt { value }


fun toast(value: Int) = toastInt { value }

inline fun toast(value: () -> CharSequence) =
        ToastCompat.makeText(mApp, value(), Toast.LENGTH_SHORT).show()

inline fun toastInt(value: () -> Int) =
        ToastCompat.makeText(mApp, value(), Toast.LENGTH_SHORT).show()


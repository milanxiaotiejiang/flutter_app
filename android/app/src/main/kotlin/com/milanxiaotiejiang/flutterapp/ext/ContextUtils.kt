package com.kotlin.base.ext

import android.app.Activity
import android.app.Dialog
import android.content.Context
import android.content.res.Configuration
import android.view.View
import androidx.annotation.IdRes
import androidx.fragment.app.Fragment

/**
 * User: milan
 * Time: 2020/3/24 17:18
 * Des:
 */

inline fun <reified T : View> View.find(@IdRes id: Int): T = findViewById(id)

inline fun <reified T : View> Activity.find(@IdRes id: Int): T = findViewById(id)

inline fun <reified T : View> Fragment.find(@IdRes id: Int): T = view?.findViewById(id) as T

inline fun <reified T : View> Dialog.find(@IdRes id: Int): T = findViewById(id)

inline val Context.displayMetrics: android.util.DisplayMetrics
    get() = resources.displayMetrics

inline val Context.configuration: Configuration
    get() = resources.configuration

inline val Configuration.portrait: Boolean
    get() = orientation == Configuration.ORIENTATION_PORTRAIT

inline val Configuration.landscape: Boolean
    get() = orientation == Configuration.ORIENTATION_LANDSCAPE

inline val Configuration.long: Boolean
    get() = (screenLayout and Configuration.SCREENLAYOUT_LONG_YES) != 0
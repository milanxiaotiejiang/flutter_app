package com.kotlin.base.ext

import android.app.Activity
import android.content.Context
import android.os.Handler
import android.os.Looper
import androidx.fragment.app.Fragment
import java.lang.ref.WeakReference
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import java.util.concurrent.Future

/**
 * User: milan
 * Time: 2020/3/24 17:44
 * Des:
 */
fun Context.runOnUiThread(f: Context.() -> Unit) {
    if (Looper.getMainLooper() === Looper.myLooper()) f() else ContextHelper.handler.post { f() }
}

inline fun Fragment.runOnUiThread(crossinline f: () -> Unit) {
    activity?.runOnUiThread { f() }
}

class AsyncContext<T>(val weakRef: WeakReference<T>)

fun <T> AsyncContext<T>.onComplete(f: (T?) -> Unit) {
    val ref = weakRef.get()
    if (Looper.getMainLooper() === Looper.myLooper()) {
        f(ref)
    } else {
        ContextHelper.handler.post { f(ref) }
    }
}

fun <T> AsyncContext<T>.uiThread(f: (T) -> Unit): Boolean {
    val ref = weakRef.get() ?: return false
    if (Looper.getMainLooper() === Looper.myLooper()) {
        f(ref)
    } else {
        ContextHelper.handler.post { f(ref) }
    }
    return true
}

fun <T : Activity> AsyncContext<T>.activityUiThread(f: (T) -> Unit): Boolean {
    val activity = weakRef.get() ?: return false
    if (activity.isFinishing) return false
    activity.runOnUiThread { f(activity) }
    return true
}

fun <T : Activity> AsyncContext<T>.activityUiThreadWithContext(f: Context.(T) -> Unit): Boolean {
    val activity = weakRef.get() ?: return false
    if (activity.isFinishing) return false
    activity.runOnUiThread { activity.f(activity) }
    return true
}

fun <T : Fragment> AsyncContext<T>.fragmentUiThread(f: (T) -> Unit): Boolean {
    val fragment = weakRef.get() ?: return false
    if (fragment.isDetached) return false
    val activity = fragment.activity ?: return false
    activity.runOnUiThread { f(fragment) }
    return true
}

fun <T : Fragment> AsyncContext<T>.fragmentUiThreadWithContext(f: Context.(T) -> Unit): Boolean {
    val fragment = weakRef.get() ?: return false
    if (fragment.isDetached) return false
    val activity = fragment.activity ?: return false
    activity.runOnUiThread { activity.f(fragment) }
    return true
}

private val crashLogger = { throwable: Throwable -> throwable.printStackTrace() }

fun <T> T.doAsync(
        exceptionHandler: ((Throwable) -> Unit)? = crashLogger,
        task: AsyncContext<T>.() -> Unit
): Future<Unit> {
    val context = AsyncContext(WeakReference(this))
    return BackgroundExecutor.submit {
        return@submit try {
            context.task()
        } catch (thr: Throwable) {
            val result = exceptionHandler?.invoke(thr)
            if (result != null) {
                result
            } else {
                Unit
            }
        }
    }
}

fun <T> T.doAsync(
        exceptionHandler: ((Throwable) -> Unit)? = crashLogger,
        executorService: ExecutorService,
        task: AsyncContext<T>.() -> Unit
): Future<Unit> {
    val context = AsyncContext(WeakReference(this))
    return executorService.submit<Unit> {
        try {
            context.task()
        } catch (thr: Throwable) {
            exceptionHandler?.invoke(thr)
        }
    }
}

fun <T, R> T.doAsyncResult(
        exceptionHandler: ((Throwable) -> Unit)? = crashLogger,
        task: AsyncContext<T>.() -> R
): Future<R> {
    val context = AsyncContext(WeakReference(this))
    return BackgroundExecutor.submit {
        try {
            context.task()
        } catch (thr: Throwable) {
            exceptionHandler?.invoke(thr)
            throw thr
        }
    }
}

fun <T, R> T.doAsyncResult(
        exceptionHandler: ((Throwable) -> Unit)? = crashLogger,
        executorService: ExecutorService,
        task: AsyncContext<T>.() -> R
): Future<R> {
    val context = AsyncContext(WeakReference(this))
    return executorService.submit<R> {
        try {
            context.task()
        } catch (thr: Throwable) {
            exceptionHandler?.invoke(thr)
            throw thr
        }
    }
}

internal object BackgroundExecutor {
    var executor: ExecutorService =
            Executors.newScheduledThreadPool(2 * Runtime.getRuntime().availableProcessors())

    fun <T> submit(task: () -> T): Future<T> = executor.submit(task)

}

private object ContextHelper {
    val handler = Handler(Looper.getMainLooper())
}
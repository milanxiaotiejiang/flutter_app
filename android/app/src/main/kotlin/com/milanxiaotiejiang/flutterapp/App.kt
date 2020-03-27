package com.milanxiaotiejiang.flutterapp

import android.app.Application
import android.content.Context
import com.milanxiaotiejiang.flutterapp.config.LogCatStrategy
import com.orhanobut.logger.AndroidLogAdapter
import com.orhanobut.logger.Logger
import com.orhanobut.logger.PrettyFormatStrategy
import io.flutter.app.FlutterApplication


/**
 * User: milan
 * Time: 2020/3/27 12:25
 * Des:
 */
class App : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()

        mApp = this

        val formatStrategy = PrettyFormatStrategy.newBuilder()
                .showThreadInfo(false)  // 输出线程信息. 默认输出
                .methodCount(0)         // 方法栈打印的个数，默认是2
                .methodOffset(7)        // 设置调用堆栈的函数偏移值，0的话则从打印该Log的函数开始输出堆栈信息，默认是0
                .logStrategy(LogCatStrategy())
                .build()
        Logger.addLogAdapter(AndroidLogAdapter(formatStrategy))
    }

    companion object {
        lateinit var mApp: Context
    }
}
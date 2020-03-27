package com.milanxiaotiejiang.flutterapp

import android.annotation.TargetApi
import android.os.Build
import android.os.Bundle
import android.view.View
import com.kotlin.base.ext.createIntent
import com.orhanobut.logger.Logger
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity : FlutterActivity() {

    private val CHANNEL_LOG = "com.milanxiaotiejiang.plugins/log"

    private val CHANNEL_NATIVE = "com.milanxiaotiejiang.plugins/navigation"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_LOG)
                .setMethodCallHandler { call, result ->
                    val arguments = call.arguments.toString()
                    when (call.method) {
                        "logI" -> Logger.i(arguments)
                        "logD" -> Logger.d(arguments)
                        "logV" -> Logger.v(arguments)
                        "logW" -> Logger.w(arguments)
                        "logE" -> Logger.e(arguments)
                    }
                    result.success(true)
                }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NATIVE)
                .setMethodCallHandler { call, result ->
                    Logger.e("call.method")
                    when (call.method) {
                        "openNativePage" -> {
                            val className: String = call.argument<String>("className")!!
                            val clazz = Class.forName(className)
                            val params: HashMap<String, Any?> = call.argument<HashMap<String, Any?>>("params")!!
                            startActivity(createIntent(this, clazz, params))
                        }
                        "closeFlutterPage" -> {
                            //销毁自身(Flutter容器)
                            finish()
                        }
                    }
                    result.success(true)
                }
    }

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        //隐藏虚拟按键，并且全屏
        //隐藏虚拟按键，并且全屏
        val _window = window
        val params = _window.attributes
        params.systemUiVisibility = View.SYSTEM_UI_FLAG_HIDE_NAVIGATION or View.SYSTEM_UI_FLAG_IMMERSIVE
        _window.attributes = params
    }
}

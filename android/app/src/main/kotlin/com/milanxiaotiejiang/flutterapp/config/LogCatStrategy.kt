package com.milanxiaotiejiang.flutterapp.config

import android.util.Log
import com.orhanobut.logger.LogStrategy

/**
 * User: milan
 * Time: 2020/3/27 12:32
 * Des:
 */
class LogCatStrategy : LogStrategy {
    override fun log(priority: Int, tag: String?, message: String) {
        Log.println(priority, randomKey() + tag!!, message)
    }

    private var last: Int = 0

    private fun randomKey(): String {
        var random = (10 * Math.random()).toInt()
        if (random == last) {
            random = (random + 1) % 10
        }
        last = random
        return random.toString()
    }
}
package com.example.wallpaper_verse

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import android.os.Bundle
import io.flutter.plugin.common.MethodChannel
import android.content.SharedPreferences
import android.preference.PreferenceManager


class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.wallpaper_verse/unlock_task").setMethodCallHandler { call, result ->
            when (call.method) {
                "activateUnlockTask" -> {
                    // Handle method call to activate unlock task
                    val preferences = PreferenceManager.getDefaultSharedPreferences(context)
                    preferences.edit().putBoolean("unlock_task_active", true).apply()
                    result.success(null)
                }
                "deactivateUnlockTask" -> {
                    // Handle method call to deactivate unlock task
                    // You can set the 'unlock_task_active' preference to false here
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
package com.example.wallpaper_verse

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import android.preference.PreferenceManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import android.os.Bundle
import io.flutter.plugin.common.MethodChannel
import android.content.SharedPreferences

class UnlockBroadcastReceiver : BroadcastReceiver() {
    private var methodChannel: MethodChannel? = null

    fun setMethodChannel(methodChannel: MethodChannel) {
        this.methodChannel = methodChannel
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action == Intent.ACTION_USER_PRESENT) {
            val preferences = PreferenceManager.getDefaultSharedPreferences(context)
            val isTaskActive = preferences.getBoolean("unlock_task_active", false)
            if (isTaskActive) {
                Log.d("UnlockBroadcastReceiver", "Device unlocked")
                methodChannel?.invokeMethod("deviceUnlocked", null)
            }
        }
    }
}
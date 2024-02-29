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
import android.app.WallpaperManager
import android.graphics.BitmapFactory
import android.os.AsyncTask
import java.net.URL
import android.app.Service
import android.content.IntentFilter
import android.os.IBinder




class UnlockBroadcastReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action == Intent.ACTION_USER_PRESENT) {
            val preferences = PreferenceManager.getDefaultSharedPreferences(context)
            val isTaskActive = preferences.getBoolean("unlock_task_active", false)
            if (isTaskActive) {
                Log.d("UnlockBroadcastReceiver", "Device unlocked")
                val wallpaperURL = "https://source.unsplash.com/user/c_v_r/1900x800"
                ChangeWallpaperTask(context).execute(wallpaperURL)
            }
        }
    }
}

class ChangeWallpaperTask(private val context: Context?) : AsyncTask<String, Void, Boolean>() {

    override fun doInBackground(vararg params: String?): Boolean {
        val wallpaperURL = params[0]

        try {
            // Download image from URL
            val inputStream = URL(wallpaperURL).openStream()
            val bitmap = BitmapFactory.decodeStream(inputStream)

            // Set downloaded image as wallpaper
            val wallpaperManager = WallpaperManager.getInstance(context)
            wallpaperManager.setBitmap(bitmap)

            return true
        } catch (e: Exception) {
            e.printStackTrace()
            return false
        }
    }
}
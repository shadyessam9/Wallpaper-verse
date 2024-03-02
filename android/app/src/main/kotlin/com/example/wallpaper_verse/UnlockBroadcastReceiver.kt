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
import android.content.Context.MODE_PRIVATE










class UnlockBroadcastReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action == Intent.ACTION_USER_PRESENT) {
            Log.d("UnlockBroadcastReceiver", "Device unlocked")

            context?.let { ctx ->
                val prefs = ctx.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
                val slideState = prefs.getBoolean("flutter.slideState",false)
                val selectedSource = prefs.getString("flutter.selectedSource", null)
                val selectedTarget = prefs.getString("flutter.selectedTarget", null)

                if(slideState){
                    if(selectedSource=="Random"){
                        if(selectedTarget=="HomePage")
                        {
                        val wallpaperURL = "https://wallpaperversaapp.000webhostapp.com/waapi/randomslideshow.php"
                        ChangeHomeWallpaperTask(ctx).execute(wallpaperURL)
                        }
                        if(selectedTarget=="LockScreen")
                        {
                        val wallpaperURL = "https://wallpaperversaapp.000webhostapp.com/waapi/randomslideshow.php"
                        ChangeLockWallpaperTask(ctx).execute(wallpaperURL)
                        }
                        if(selectedTarget=="HomePage & LockScreen")
                        {
                        val wallpaperURL = "https://wallpaperversaapp.000webhostapp.com/waapi/randomslideshow.php"
                        ChangeWallpaperTask(ctx).execute(wallpaperURL)
                        }
                    };
                    if(selectedSource=="Favorites"){
                        if(selectedTarget=="HomePage")
                        {
                        val wallpaperURL = "https://wallpaperversaapp.000webhostapp.com/waapi/userslideshowapi.php?user_id=1"
                        ChangeHomeWallpaperTask(ctx).execute(wallpaperURL)
                        }
                        if(selectedTarget=="LockScreen")
                        {
                        val wallpaperURL = "https://wallpaperversaapp.000webhostapp.com/waapi/userslideshowapi.php?user_id=1"
                        ChangeLockWallpaperTask(ctx).execute(wallpaperURL)
                        }
                        if(selectedTarget=="HomePage & LockScreen")
                        {
                        val wallpaperURL = "https://wallpaperversaapp.000webhostapp.com/waapi/userslideshowapi.php?user_id=1"
                        ChangeWallpaperTask(ctx).execute(wallpaperURL)
                        }
                    }
                }else{}
            }
        }
    }
}

class ChangeHomeWallpaperTask(private val context: Context?) : AsyncTask<String, Void, Boolean>() {

    override fun doInBackground(vararg params: String?): Boolean {
        val wallpaperURL = params[0]

        try {
            // Download image from URL
            val inputStream = URL(wallpaperURL).openStream()
            val bitmap = BitmapFactory.decodeStream(inputStream)

            // Set downloaded image as wallpaper
            val wallpaperManager = WallpaperManager.getInstance(context)
            wallpaperManager.setBitmap(bitmap, null, true, WallpaperManager.FLAG_SYSTEM)

            return true
        } catch (e: Exception) {
            e.printStackTrace()
            return false
        }
    }
}


class ChangeLockWallpaperTask(private val context: Context?) : AsyncTask<String, Void, Boolean>() {

    override fun doInBackground(vararg params: String?): Boolean {
        val wallpaperURL = params[0]

        try {
            // Download image from URL
            val inputStream = URL(wallpaperURL).openStream()
            val bitmap = BitmapFactory.decodeStream(inputStream)

            // Set downloaded image as wallpaper
            val wallpaperManager = WallpaperManager.getInstance(context)
            wallpaperManager.setBitmap(bitmap, null, true, WallpaperManager.FLAG_LOCK)


            return true
        } catch (e: Exception) {
            e.printStackTrace()
            return false
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
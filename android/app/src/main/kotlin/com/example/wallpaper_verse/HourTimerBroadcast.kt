package com.example.wallpaper_verse
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
import java.util.Timer
import java.util.TimerTask

class HourTimerService : Service() {
    private var timer: Timer? = null
    private lateinit var ctx: Context // Define a context variable

    override fun onCreate() {
        super.onCreate()
        ctx = this // Assign the context
        startTimerTask()
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onDestroy() {
        super.onDestroy()
        timer?.cancel()
    }

    private fun startTimerTask() {
        timer = Timer()
        timer?.scheduleAtFixedRate(object : TimerTask() {
            override fun run() {

                val prefs = ctx.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
                val slideState = prefs.getBoolean("flutter.slideState", false)
                val selectedSource = prefs.getString("flutter.selectedSource", null)
                val selectedTarget = prefs.getString("flutter.selectedTarget", null)
                val durationType = prefs.getString("flutter.durationType", null)
                val id = prefs.getString("flutter.id", null)

                if (slideState) {
                 if(durationType == "Every Hour"){
                        if (selectedSource == "Random") {
                            if (selectedTarget == "HomePage") {
                                val wallpaperURL1 = "https://wallpaperversaapp.000webhostapp.com/waapi/randomslideshow.php"
                                HChangeHomeWallpaperTask(ctx).execute(wallpaperURL1)
                            }
                            if (selectedTarget == "LockScreen") {
                                val wallpaperURL2 = "https://wallpaperversaapp.000webhostapp.com/waapi/randomslideshow.php"
                                HChangeLockWallpaperTask(ctx).execute(wallpaperURL2)
                            }
                            if (selectedTarget == "HomePage & LockScreen") {
                                val wallpaperURL3 = "https://wallpaperversaapp.000webhostapp.com/waapi/randomslideshow.php"
                                HChangeWallpaperTask(ctx).execute(wallpaperURL3)
                            }
                        }
                        if (selectedSource == "Favorites") {
                            if (selectedTarget == "HomePage") {
                                val wallpaperURL4 = "https://wallpaperversaapp.000webhostapp.com/waapi/userslideshowapi.php?user_id=$id"
                                HChangeHomeWallpaperTask(ctx).execute(wallpaperURL4)
                            }
                            if (selectedTarget == "LockScreen") {
                                val wallpaperURL5 = "https://wallpaperversaapp.000webhostapp.com/waapi/userslideshowapi.php?user_id=$id"
                                HChangeLockWallpaperTask(ctx).execute(wallpaperURL5)
                            }
                            if (selectedTarget == "HomePage & LockScreen") {
                                val wallpaperURL6 = "https://wallpaperversaapp.000webhostapp.com/waapi/userslideshowapi.php?user_id=$id"
                                HChangeWallpaperTask(ctx).execute(wallpaperURL6)
                            }
                        }
                 }
                }
            }
        }, 0, 3600000) // Run every hour (3600000 milliseconds)
    }
}

class HChangeHomeWallpaperTask(private val context: Context?) : AsyncTask<String, Void, Boolean>() {

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


class HChangeLockWallpaperTask(private val context: Context?) : AsyncTask<String, Void, Boolean>() {

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


class HChangeWallpaperTask(private val context: Context?) : AsyncTask<String, Void, Boolean>() {

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
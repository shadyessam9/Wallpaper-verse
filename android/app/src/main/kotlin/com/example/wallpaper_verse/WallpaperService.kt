package com.example.wallpaper_verse
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.graphics.BitmapFactory
import android.os.AsyncTask
import android.os.Build
import android.os.IBinder
import android.preference.PreferenceManager
import android.util.Log
import androidx.core.app.NotificationCompat
import java.net.URL

class WallpaperService : Service() {
    private val receiver = UnlockBroadcastReceiver()
    private val channelId = "WallpaperChannel"

    override fun onCreate() {
        super.onCreate()
        val filter = IntentFilter(Intent.ACTION_USER_PRESENT)
        registerReceiver(receiver, filter)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            createNotificationChannel()
        }
        startForeground(NOTIFICATION_ID, createNotification())
    }

    override fun onDestroy() {
        super.onDestroy()
        unregisterReceiver(receiver)
    }

    override fun onBind(intent: Intent): IBinder? {
        return null
    }

    private fun createNotificationChannel() {
        val channel = NotificationChannel(channelId, "Wallpaper Service", NotificationManager.IMPORTANCE_DEFAULT)
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.createNotificationChannel(channel)
    }

    private fun createNotification(): Notification {
        val notificationBuilder = NotificationCompat.Builder(this, channelId)
            .setContentTitle("Wallpaper Service")
            .setContentText("Running in background")
            .setSmallIcon(R.mipmap.ic_launcher)

        return notificationBuilder.build()
    }

    companion object {
        private const val NOTIFICATION_ID = 1
    }
}

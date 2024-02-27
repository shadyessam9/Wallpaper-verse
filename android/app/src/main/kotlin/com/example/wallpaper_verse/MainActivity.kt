package com.example.wallpaper_verse
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.example.wallpaper_verse/bgtsk"
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Initialize method channel
        MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, CHANNEL)
                .setMethodCallHandler { call, result ->
                    // Handle method calls from Flutter
                    if (call.method == "createNotification") {
                        val params = call.arguments as? HashMap<*, *>
                        val stringValue = params?.get("stringValue") as? String
                        val intValue = params?.get("intValue") as? Int
                        // Create a notification with received values
                        createNotification(stringValue, intValue)
                        result.success(null)
                    } else {
                        result.notImplemented()
                    }
                }
    }

    private fun createNotification(stringValue: String?, intValue: Int?) {
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
          val channelId = "com.example.wallpaper_verse.bgtsk"
          val channelName = "Background Task Channel"
            val importance = NotificationManager.IMPORTANCE_DEFAULT
            val channel = NotificationChannel(channelId, channelName, importance)
            notificationManager.createNotificationChannel(channel)
        }

        val notificationId = 1 // Unique ID for the notification
        val notificationBuilder = NotificationCompat.Builder(this, channelId)
                .setSmallIcon(R.drawable.notification_icon)
                .setContentTitle("Your Notification Title")
                .setContentText("String value: $stringValue, Int value: $intValue")
                .setPriority(NotificationCompat.PRIORITY_DEFAULT)

        notificationManager.notify(notificationId, notificationBuilder.build())
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Configure the Flutter engine
    }
}

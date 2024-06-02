package com.example.wallpaper_verse
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import android.os.Bundle
import io.flutter.plugin.common.MethodChannel
import android.content.SharedPreferences
import android.preference.PreferenceManager
import android.content.Intent
import androidx.annotation.NonNull
import androidx.appcompat.app.AppCompatActivity



class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        startService(Intent(this, WallpaperService::class.java))
        startService(Intent(this, HourTimerService::class.java))
        startService(Intent(this, DayTimerService::class.java))
    }
}
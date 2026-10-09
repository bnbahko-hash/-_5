package com.rafeeqy.app

import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.app.usage.NetworkStatsManager
import android.app.usage.NetworkStats
import android.content.pm.PackageManager
import android.net.ConnectivityManager
import android.os.StatFs
import android.database.Cursor
import android.net.Uri as AndroidUri
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {

    private val CHANNEL_SMS = "rafeeqy/sms"
    private val CHANNEL_USAGE = "rafeeqy/usage"
    private val CHANNEL_STORAGE = "rafeeqy/storage"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // ─── SMS Channel ───────────────────────────────
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_SMS)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "hasSmsPermission" -> {
                        val granted = checkSelfPermission(android.Manifest.permission.READ_SMS) ==
                            PackageManager.PERMISSION_GRANTED
                        result.success(granted)
                    }
                    "readSms" -> {
                        try {
                            val limit = call.argument<Int>("limit") ?: 200
                            val list = readSms(limit)
                            result.success(list)
                        } catch (e: Exception) {
                            result.error("SMS_ERROR", e.message, null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }

        // ─── Usage Channel ────────────────────────────
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_USAGE)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "hasUsagePermission" -> result.success(hasUsagePermission())
                    "getUsage" -> {
                        try {
                            result.success(getNetworkUsage())
                        } catch (e: Exception) {
                            result.error("USAGE_ERROR", e.message, null)
                        }
                    }
                    "getTopApps" -> {
                        try {
                            val limit = call.argument<Int>("limit") ?: 10
                            result.success(getTopApps(limit))
                        } catch (e: Exception) {
                            result.error("USAGE_ERROR", e.message, null)
                        }
                    }
                    "openUsageSettings" -> {
                        try {
                            startActivity(Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
                                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
                            result.success(true)
                        } catch (e: Exception) {
                            result.success(false)
                        }
                    }
                    else -> result.notImplemented()
                }
            }

        // ─── Storage Channel ──────────────────────────
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_STORAGE)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "totalBytes" -> {
                        val stat = StatFs(File("/").path)
                        result.success(stat.blockCountLong * stat.blockSizeLong)
                    }
                    "freeBytes" -> {
                        val stat = StatFs(File("/").path)
                        result.success(stat.availableBlocksLong * stat.blockSizeLong)
                    }
                    else -> result.notImplemented()
                }
            }

        // Handle initial widget action
        handleWidgetIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleWidgetIntent(intent)
    }

    private fun handleWidgetIntent(intent: Intent?) {
        intent?.data?.let { uri ->
            if (uri.scheme == "rafeeqy" && uri.host == "widget") {
                // Deep link handled by Flutter side
            }
        }
    }

    private fun hasUsagePermission(): Boolean {
        return try {
            val appOps = getSystemService(Context.APP_OPS_SERVICE) as android.app.AppOpsManager
            val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                appOps.unsafeCheckOpNoThrow(
                    android.app.AppOpsManager.OPSTR_GET_USAGE_STATS,
                    android.os.Process.myUid(),
                    packageName
                )
            } else {
                @Suppress("DEPRECATION")
                appOps.checkOpNoThrow(
                    android.app.AppOpsManager.OPSTR_GET_USAGE_STATS,
                    android.os.Process.myUid(),
                    packageName
                )
            }
            mode == android.app.AppOpsManager.MODE_ALLOWED
        } catch (e: Exception) {
            false
        }
    }

    private fun readSms(limit: Int): List<Map<String, Any?>> {
        val list = mutableListOf<Map<String, Any?>>()
        try {
            val cursor: Cursor? = contentResolver.query(
                AndroidUri.parse("content://sms/inbox"),
                arrayOf("_id", "address", "body", "date", "read"),
                null, null, "date DESC LIMIT $limit"
            )
            cursor?.use {
                while (it.moveToNext()) {
                    list.add(mapOf(
                        "id" to it.getString(0),
                        "address" to (it.getString(1) ?: ""),
                        "body" to (it.getString(2) ?: ""),
                        "date" to it.getLong(3),
                        "read" to (it.getInt(4) == 1)
                    ))
                }
            }
        } catch (_: Exception) { }
        return list
    }

    private fun getNetworkUsage(): Map<String, Any> {
        val cm = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val nsm = getSystemService(Context.NETWORK_STATS_SERVICE) as NetworkStatsManager
        val uid = android.os.Process.myUid()

        val now = System.currentTimeMillis()
        val startOfDay = now - (now % (24 * 60 * 60 * 1000))
        val startOfMonth = now - (30L * 24 * 60 * 60 * 1000)

        fun usageFor(from: Long, to: Long): Long {
            var total = 0L
            try {
                val bucket = nsm.queryDetailsForUid(
                    ConnectivityManager.TYPE_MOBILE, null, from, to, uid
                )
                while (bucket != null && bucket.hasNextBucket()) {
                    val b = NetworkStats.Bucket()
                    bucket.getNextBucket(b)
                    total += b.rxBytes + b.txBytes
                }
                bucket?.close()
            } catch (_: Exception) { }
            return total
        }

        val todayBytes = usageFor(startOfDay, now)
        val monthBytes = usageFor(startOfMonth, now)

        return mapOf(
            "todayMb" to (todayBytes / (1024.0 * 1024.0)),
            "monthMb" to (monthBytes / (1024.0 * 1024.0)),
            "totalMb" to (monthBytes / (1024.0 * 1024.0))
        )
    }

    private fun getTopApps(limit: Int): List<Map<String, Any>> {
        val nsm = getSystemService(Context.NETWORK_STATS_SERVICE) as NetworkStatsManager
        val pm = packageManager
        val now = System.currentTimeMillis()
        val startOfDay = now - (now % (24 * 60 * 60 * 1000))
        val result = mutableMapOf<Int, Long>()

        try {
            for (type in intArrayOf(ConnectivityManager.TYPE_MOBILE, ConnectivityManager.TYPE_WIFI)) {
                val bucket = nsm.queryDetailsForUidTag(type, null, startOfDay, now, -1, 0)
                while (bucket != null && bucket.hasNextBucket()) {
                    val b = NetworkStats.Bucket()
                    bucket.getNextBucket(b)
                    result[b.uid] = (result[b.uid] ?: 0L) + b.rxBytes + b.txBytes
                }
                bucket?.close()
            }
        } catch (_: Exception) { }

        return result.entries
            .sortedByDescending { it.value }
            .take(limit)
            .mapNotNull { entry ->
                try {
                    val name = pm.getNameForUid(entry.key) ?: return@mapNotNull null
                    mapOf(
                        "name" to name,
                        "mb" to (entry.value / (1024.0 * 1024.0))
                    )
                } catch (_: Exception) { null }
            }
    }
}

package com.yossefjoo.rafeeki

import android.app.AppOpsManager
import android.app.usage.NetworkStats
import android.app.usage.NetworkStatsManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.database.Cursor
import android.net.ConnectivityManager
import android.net.Uri
import android.os.Build
import android.os.Process
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Calendar

class MainActivity : FlutterActivity() {

    companion object {
        private const val CHANNEL_USAGE = "rafeeqy/usage"
        private const val CHANNEL_SMS = "rafeeqy/sms"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // ═══════════════════════════════════════════════════════════════
        //  Usage Stats Channel
        // ═══════════════════════════════════════════════════════════════
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_USAGE)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "hasUsagePermission" -> {
                        result.success(hasUsagePermission())
                    }
                    "getUsage" -> {
                        try {
                            result.success(getUsage())
                        } catch (e: Exception) {
                            result.error("USAGE_ERROR", e.message, null)
                        }
                    }
                    "getTopApps" -> {
                        try {
                            val limit = call.argument<Int>("limit") ?: 10
                            result.success(getTopApps(limit))
                        } catch (e: Exception) {
                            result.error("TOP_APPS_ERROR", e.message, null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }

        // ═══════════════════════════════════════════════════════════════
        //  SMS Channel
        // ═══════════════════════════════════════════════════════════════
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_SMS)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "hasSmsPermission" -> {
                        result.success(hasSmsPermission())
                    }
                    "readSms" -> {
                        try {
                            val limit = call.argument<Int>("limit") ?: 200
                            result.success(readSms(limit))
                        } catch (e: Exception) {
                            result.error("SMS_ERROR", e.message, null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    // ═══════════════════════════════════════════════════════════════════
    //  Usage Permission
    // ═══════════════════════════════════════════════════════════════════
    private fun hasUsagePermission(): Boolean {
        return try {
            val appOps = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
            val mode: Int = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                appOps.unsafeCheckOpNoThrow(
                    AppOpsManager.OPSTR_GET_USAGE_STATS,
                    Process.myUid(),
                    packageName
                )
            } else {
                @Suppress("DEPRECATION")
                appOps.checkOpNoThrow(
                    AppOpsManager.OPSTR_GET_USAGE_STATS,
                    Process.myUid(),
                    packageName
                )
            }
            mode == AppOpsManager.MODE_ALLOWED
        } catch (e: Exception) {
            false
        }
    }

    // ═══════════════════════════════════════════════════════════════════
    //  Get Overall Network Usage (MB)
    // ═══════════════════════════════════════════════════════════════════
    private fun getUsage(): Map<String, Any> {
        // بداية اليوم
        val cal = Calendar.getInstance()
        cal.set(Calendar.HOUR_OF_DAY, 0)
        cal.set(Calendar.MINUTE, 0)
        cal.set(Calendar.SECOND, 0)
        cal.set(Calendar.MILLISECOND, 0)
        val startDay = cal.timeInMillis
        val startMonth = startDay - (30L * 24L * 60L * 60L * 1000L)
        val now = System.currentTimeMillis()

        val todayBytes = getNetworkBytes(startDay, now)
        val monthBytes = getNetworkBytes(startMonth, now)
        val totalBytes = getNetworkBytes(0L, now)

        return mapOf(
            "todayMb" to (todayBytes / (1024.0 * 1024.0)),
            "monthMb" to (monthBytes / (1024.0 * 1024.0)),
            "totalMb" to (totalBytes / (1024.0 * 1024.0))
        )
    }

    // ═══════════════════════════════════════════════════════════════════
    //  Helper: get network bytes (mobile + wifi) for time range
    // ═══════════════════════════════════════════════════════════════════
    private fun getNetworkBytes(start: Long, end: Long): Long {
        if (!hasUsagePermission()) return 0L

        var total = 0L
        try {
            val nsm = getSystemService(Context.NETWORK_STATS_SERVICE) as NetworkStatsManager

            // Mobile
            try {
                val bucket = nsm.querySummaryForDevice(
                    ConnectivityManager.TYPE_MOBILE, null, start, end
                )
                if (bucket != null) {
                    total += bucket.rxBytes + bucket.txBytes
                }
            } catch (_: Exception) {}

            // WiFi
            try {
                val bucket = nsm.querySummaryForDevice(
                    ConnectivityManager.TYPE_WIFI, null, start, end
                )
                if (bucket != null) {
                    total += bucket.rxBytes + bucket.txBytes
                }
            } catch (_: Exception) {}

        } catch (_: Exception) {}
        return total
    }

    // ═══════════════════════════════════════════════════════════════════
    //  Get Top Apps by Network Usage
    // ═══════════════════════════════════════════════════════════════════
    private fun getTopApps(limit: Int): List<Map<String, Any>> {
        if (!hasUsagePermission()) return emptyList()

        val result = mutableListOf<Map<String, Any>>()

        try {
            val nsm = getSystemService(Context.NETWORK_STATS_SERVICE) as NetworkStatsManager
            val pm = packageManager

            // بداية اليوم
            val cal = Calendar.getInstance()
            cal.set(Calendar.HOUR_OF_DAY, 0)
            cal.set(Calendar.MINUTE, 0)
            cal.set(Calendar.SECOND, 0)
            cal.set(Calendar.MILLISECOND, 0)
            val start = cal.timeInMillis
            val end = System.currentTimeMillis()

            // ناخد التطبيقات الظاهرة للمستخدم بس (أسرع)
            val mainIntent = Intent(Intent.ACTION_MAIN).apply {
                addCategory(Intent.CATEGORY_LAUNCHER)
            }
            val apps = pm.queryIntentActivities(mainIntent, 0)

            val usageList = mutableListOf<Triple<String, String, Long>>()
            val seenUids = mutableSetOf<Int>()

            for (resolveInfo in apps) {
                try {
                    val appInfo = resolveInfo.activityInfo.applicationInfo
                    val uid = appInfo.uid

                    // نتخطى لو شفنا نفس الـ UID
                    if (uid in seenUids) continue
                    seenUids.add(uid)

                    var bytes = 0L

                    // Mobile
                    try {
                        val bucket = nsm.queryDetailsForUid(
                            ConnectivityManager.TYPE_MOBILE, null, start, end, uid
                        )
                        val b = NetworkStats.Bucket()
                        while (bucket.hasNextBucket()) {
                            bucket.getNextBucket(b)
                            bytes += b.rxBytes + b.txBytes
                        }
                        bucket.close()
                    } catch (_: Exception) {}

                    // WiFi
                    try {
                        val bucket = nsm.queryDetailsForUid(
                            ConnectivityManager.TYPE_WIFI, null, start, end, uid
                        )
                        val b = NetworkStats.Bucket()
                        while (bucket.hasNextBucket()) {
                            bucket.getNextBucket(b)
                            bytes += b.rxBytes + b.txBytes
                        }
                        bucket.close()
                    } catch (_: Exception) {}

                    if (bytes > 0) {
                        val appName = pm.getApplicationLabel(appInfo).toString()
                        usageList.add(Triple(appName, appInfo.packageName, bytes))
                    }
                } catch (_: Exception) {
                    // نتخطى التطبيقات اللي فيها مشاكل
                }
            }

            // رتب تنازلياً واخد الأعلى
            usageList.sortByDescending { it.third }
            usageList.take(limit).forEach { entry ->
                result.add(
                    mapOf(
                        "name" to entry.first,
                        "package" to entry.second,
                        "mb" to (entry.third / (1024.0 * 1024.0))
                    )
                )
            }

        } catch (_: Exception) {}

        return result
    }

    // ═══════════════════════════════════════════════════════════════════
    //  SMS
    // ═══════════════════════════════════════════════════════════════════
    private fun hasSmsPermission(): Boolean {
        return try {
            checkSelfPermission(android.Manifest.permission.READ_SMS) ==
                PackageManager.PERMISSION_GRANTED
        } catch (e: Exception) {
            false
        }
    }

    private fun readSms(limit: Int): List<Map<String, Any>> {
        val list = mutableListOf<Map<String, Any>>()
        if (!hasSmsPermission()) return list

        var cursor: Cursor? = null
        try {
            cursor = contentResolver.query(
                Uri.parse("content://sms/inbox"),
                arrayOf("_id", "address", "body", "date"),
                null,
                null,
                "date DESC LIMIT $limit"
            )
            cursor?.use { c ->
                while (c.moveToNext()) {
                    val id = c.getString(0) ?: ""
                    val address = c.getString(1) ?: ""
                    val body = c.getString(2) ?: ""
                    val date = c.getLong(3)

                    list.add(
                        mapOf(
                            "id" to id,
                            "address" to address,
                            "body" to body,
                            "date" to date
                        )
                    )
                }
            }
        } catch (_: Exception) {
            // ممكن يحصل security exception
        } finally {
            cursor?.close()
        }

        return list
    }
}
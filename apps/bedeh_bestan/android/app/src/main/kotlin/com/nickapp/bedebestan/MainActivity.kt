package com.nickapp.bedebestan

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.net.Uri
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import com.farsitel.bazaar.IUpdateCheckService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var updateService: IUpdateCheckService? = null
    private var updateServiceBound = false

    private val updateConnection =
        object : ServiceConnection {
            override fun onServiceConnected(name: ComponentName?, service: IBinder?) {
                updateService = IUpdateCheckService.Stub.asInterface(service)
            }

            override fun onServiceDisconnected(name: ComponentName?) {
                updateService = null
            }
        }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        bindBazaarUpdateService()
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "isUpdateAvailable" -> checkBazaarUpdate(result)
                    "openAppPage" -> {
                        openBazaarAppPage()
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun bindBazaarUpdateService() {
        val intent =
            Intent("com.farsitel.bazaar.service.UpdateCheckService.BIND").apply {
                setPackage("com.farsitel.bazaar")
            }
        try {
            updateServiceBound =
                bindService(intent, updateConnection, Context.BIND_AUTO_CREATE)
        } catch (_: Exception) {
            updateServiceBound = false
        }
    }

    private fun checkBazaarUpdate(result: MethodChannel.Result) {
        Handler(Looper.getMainLooper()).postDelayed(
            {
                try {
                    val service = updateService
                    if (service == null) {
                        result.success(null)
                        return@postDelayed
                    }
                    val storeCode = service.getVersionCode(packageName)
                    when (storeCode) {
                        -1L -> result.success(false)
                        else -> result.success(true)
                    }
                } catch (_: Exception) {
                    result.success(null)
                }
            },
            900L,
        )
    }

    private fun openBazaarAppPage() {
        try {
            val intent =
                Intent(
                    Intent.ACTION_VIEW,
                    Uri.parse("bazaar://details?id=$packageName"),
                ).apply { setPackage("com.farsitel.bazaar") }
            startActivity(intent)
        } catch (_: Exception) {
            startActivity(
                Intent(
                    Intent.ACTION_VIEW,
                    Uri.parse("https://cafebazaar.ir/app/$packageName"),
                ),
            )
        }
    }

    override fun onDestroy() {
        if (updateServiceBound) {
            try {
                unbindService(updateConnection)
            } catch (_: Exception) {
            }
            updateServiceBound = false
        }
        super.onDestroy()
    }

    companion object {
        private const val CHANNEL = "com.nickapp.bedebestan/bazaar_update"
    }
}

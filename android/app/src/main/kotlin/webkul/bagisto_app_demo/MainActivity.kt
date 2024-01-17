package webkul.bagisto_app_demo
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.File
import org.apache.commons.io.FilenameUtils
import androidx.core.content.FileProvider
import android.content.Intent
import android.net.Uri


class MainActivity : FlutterFragmentActivity() {
    private val EVENTS = "com.webkul.bagisto_mobikul/channel"
    var methodChannelResult: MethodChannel.Result? = null
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            EVENTS
        ).setMethodCallHandler { call, result ->
            methodChannelResult = result;
            if (call.method == "initialLink") {
                val initialUrl = initialLink()
                if (initialUrl != null) {
                    result.success(initialLink())
                } else {
                    result.error("UNAVAILABLE", "No deep link found", null)
                }
            }
            else if (call.method.equals("fileviewer")) {
                var path: String = call.arguments()!!
                var file = File(path)
                val extension = FilenameUtils.getExtension(path)

                val photoURI: Uri = FileProvider.getUriForFile(
                    this.applicationContext,
                    "com.webkul.bagisto.mobikul.provider",
                    file
                )
                val intent = Intent(Intent.ACTION_VIEW)
                intent.setFlags(Intent.FLAG_ACTIVITY_NO_HISTORY)
                intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                intent.setDataAndType(photoURI, "application/" + extension)
                if (intent.resolveActivity(getPackageManager()) != null) {
                    //if device have requested extension app then respective app will open
                    println("File extension app found in the device")
                    startActivity(intent);
                }
                else {
                    //if device don't have requested extension app then all app option will be visible.
                    println("File extension app Not found in the device")

                    intent.setDataAndType(photoURI, "*/*")
                    startActivity(intent);
                }
                result.success(true)

            }

        }
    }


//    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
//        super.onActivityResult(requestCode, resultCode, data)
//        if (requestCode == 101 && resultCode == Activity.RESULT_OK) {
//            methodChannelResult?.success(data?.getStringExtra(CameraSearchActivity.CAMERA_SEARCH_HELPER))
//        }
//    }

    fun initialLink(): String? {
        val uri = intent.data
        Log.d("adasdasda", uri.toString())
        return if (uri != null) {
            uri.toString();
        } else {
            null
        }
    }

}

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
import android.app.Activity
import com.google.ar.core.ArCoreApk
import webkul.bagisto_app_demo.arcore.activities.ArActivity
import webkul.bagisto_app_demo.mlkit.activities.CameraSearchActivity
import okhttp3.*
import org.json.JSONArray
import org.json.JSONObject
import android.util.Base64
import android.widget.Toast
import java.io.IOException
import java.util.UUID
import com.paypal.android.corepayments.CoreConfig
import com.paypal.android.corepayments.Environment
import com.paypal.android.corepayments.PayPalSDKError
import com.paypal.android.paypalwebpayments.PayPalWebCheckoutClient
import com.paypal.android.paypalwebpayments.PayPalWebCheckoutFundingSource
import com.paypal.android.paypalwebpayments.PayPalWebCheckoutListener
import com.paypal.android.paypalwebpayments.PayPalWebCheckoutRequest
import com.paypal.android.paypalwebpayments.PayPalWebCheckoutResult
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.RequestBody.Companion.toRequestBody


class MainActivity : FlutterFragmentActivity() {
    private val client = OkHttpClient()
    private val clientID = ""
    private val secretID = ""
    private val returnUrl = "com.webkul.bagisto.mobikul://paypalpay"
    var accessToken = ""
    private lateinit var uniqueId: String
    private var orderid = ""
    private var paypalPayload: Map<String, Any>? = null
    private var customClientId: String? = null
    private var customSecretKey: String? = null
    private var isSandbox: Boolean = true


    private val EVENTS = "com.webkul.bagisto_mobikul/channel"
    var methodChannelResult: MethodChannel.Result? = null
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            EVENTS
        ).setMethodCallHandler { call, result ->
            try {
                methodChannelResult = result;
                 if (call.method.equals("fileviewer")) {
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
                else if (call.method == "imageSearch") {
                    startImageFinding()
                } else if (call.method == "textSearch") {
                    startTextFinding()
                } else if (call.method == "showAr") {
                    if (call.hasArgument("url")) {
                        Log.d("qdaasdas", call.argument("url") ?: "No Name")
                    }
                    showArActivity(call.argument("name"), call.argument("url"))

                }
                else if(call.method == "paypalPay"){
                    // Receive payload from Flutter
                    val args = call.arguments as? Map<String, Any>
                    paypalPayload = args
                    // Extract clientId and secretKey if present
                    customClientId = args?.get("clientId") as? String
                    customSecretKey = args?.get("secretKey") as? String
                    // Get sandboxMode from Flutter, default to true if not present
                    isSandbox = (args?.get("sandboxMode") as? Boolean) ?: true
                    fetchAccessToken()
                }
            }catch (e: Exception) {
                print(e)
            }
        }
    }


    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == 101 && resultCode == Activity.RESULT_OK) {
            methodChannelResult?.success(data?.getStringExtra(CameraSearchActivity.CAMERA_SEARCH_HELPER))
        }
    }

    private fun startImageFinding() {
        val intent = Intent(this, CameraSearchActivity::class.java)
        intent.putExtra(
            CameraSearchActivity.CAMERA_SELECTED_MODEL,
            CameraSearchActivity.IMAGE_LABELING
        )
        startActivityForResult(intent, 101)
    }

    private fun startTextFinding() {
        val intent = Intent(this, CameraSearchActivity::class.java)
        intent.putExtra(
            CameraSearchActivity.CAMERA_SELECTED_MODEL,
            CameraSearchActivity.TEXT_RECOGNITION
        )
        startActivityForResult(intent, 101)
    }
    private fun showArActivity(name: String?, url: String?){
        val availability = ArCoreApk.getInstance().checkAvailability(this)
        if (availability.isSupported) {
            Log.d("TEST_LOG", "${name}----${url}")
            val intent = Intent(this, ArActivity::class.java)
            intent.putExtra("name", name)
            intent.putExtra("link", url)
            startActivity(intent)
            // methodChannelResult?.success("Supported ");
        } else {
            methodChannelResult?.error("401", "Your device does not support AR feature","");
        }
    }


    private fun getPayPalBaseUrl(): String {
        return if (isSandbox) {
            "https://api-m.sandbox.paypal.com"
        } else {
            "https://api-m.paypal.com"
        }
    }


    private fun fetchAccessToken() {
        // Use custom clientId/secretKey if provided, else fallback to default
        val usedClientId = customClientId?.takeIf { it.isNotEmpty() } ?: clientID
        val usedSecretKey = customSecretKey?.takeIf { it.isNotEmpty() } ?: secretID
        val authString = "$usedClientId:$usedSecretKey"
        val encodedAuthString = Base64.encodeToString(authString.toByteArray(), Base64.NO_WRAP)

        val formBody = FormBody.Builder()
            .add("grant_type", "client_credentials")
            .build()

        val request = Request.Builder()
            .url("${getPayPalBaseUrl()}/v1/oauth2/token")
            .addHeader("Authorization", "Basic $encodedAuthString")
            .addHeader("Content-Type", "application/x-www-form-urlencoded")
            .post(formBody)
            .build()

        client.newCall(request).enqueue(object : Callback {
            override fun onFailure(call: Call, e: IOException) {
                runOnUiThread {
                    Toast.makeText(this@MainActivity, "Token fetch failed", Toast.LENGTH_SHORT).show()
                }
            }

            override fun onResponse(call: Call, response: Response) {
                response.use {
                    val json = JSONObject(it.body!!.string())
                    accessToken = json.getString("access_token")
                    runOnUiThread {
                        startOrder()
                        Toast.makeText(this@MainActivity, "Starting paypal checkout!", Toast.LENGTH_SHORT).show()
                    }
                }
            }
        })
    }


    private fun handlerOrderID(orderID: String) {
        // Use environment based on isSandbox
        val environment = if (isSandbox) Environment.SANDBOX else Environment.LIVE
        val config = CoreConfig(
            customClientId?.takeIf { it?.isNotEmpty() == true } ?: clientID,
            environment = environment
        )
        val payPalWebCheckoutClient = PayPalWebCheckoutClient(this@MainActivity, config, returnUrl)
        payPalWebCheckoutClient.listener = object : PayPalWebCheckoutListener {
            override fun onPayPalWebSuccess(result: PayPalWebCheckoutResult) {
                Log.d(TAG, "onPayPalWebSuccess: $result")
            }

            override fun onPayPalWebFailure(error: PayPalSDKError) {
                Log.d(TAG, "onPayPalWebFailure: $error")
            }

            override fun onPayPalWebCanceled() {
                Log.d(TAG, "onPayPalWebCanceled: ")
            }
        }

        orderid = orderID
        val payPalWebCheckoutRequest =
            PayPalWebCheckoutRequest(orderID, fundingSource = PayPalWebCheckoutFundingSource.PAYPAL)
        payPalWebCheckoutClient.start(payPalWebCheckoutRequest)

    }

    private fun startOrder() {
        uniqueId = UUID.randomUUID().toString()

        // Use the payload from Flutter if available, else fallback to default
        val payload = paypalPayload

        if (payload == null) {
            return
        }

        val orderRequestJson = run {
            val amountMap = ((payload["transactions"] as? List<*>)?.firstOrNull() as? Map<*, *>)?.get("amount") as? Map<*, *>
            val currency = amountMap?.get("currency")?.toString() ?: "USD"
            val total = amountMap?.get("total")?.toString() ?: "5.00"
            JSONObject().apply {
                put("intent", "CAPTURE")
                put("purchase_units", JSONArray().apply {
                    put(JSONObject().apply {
                        put("reference_id", uniqueId)
                        put("amount", JSONObject().apply {
                            put("currency_code", currency)
                            put("value", total)
                        })
                    })
                })
                put("payment_source", JSONObject().apply {
                    put("paypal", JSONObject().apply {
                        put("experience_context", JSONObject().apply {
                            put("payment_method_preference", "IMMEDIATE_PAYMENT_REQUIRED")
                            put("landing_page", "LOGIN")
                            put("user_action", "PAY_NOW")
                        })
                    })
                })
            }
        }

        val requestBody = orderRequestJson.toString().toRequestBody("application/json".toMediaTypeOrNull())

        val request = Request.Builder()
            .url("${getPayPalBaseUrl()}/v2/checkout/orders")
            .addHeader("Authorization", "Bearer $accessToken")
            .addHeader("Content-Type", "application/json")
            .addHeader("PayPal-Request-Id", uniqueId)
            .post(requestBody)
            .build()

        client.newCall(request).enqueue(object : Callback {
            override fun onFailure(call: Call, e: IOException) {
                Log.e(TAG, "Order creation failed", e)
            }

            override fun onResponse(call: Call, response: Response) {
                response.use {
                    val json = JSONObject(it.body!!.string())
                    val orderId = json.getString("id")
                    orderid = orderId
                    runOnUiThread {
                        handlerOrderID(orderId)
                    }
                }
            }
        })
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        Log.d(TAG, "onNewIntent: $intent")

        intent.data?.let { uri ->
            when (uri.getQueryParameter("opType")) {
                "payment" -> captureOrder(orderid)
                "cancel" -> Toast.makeText(this, "Payment Cancelled", Toast.LENGTH_SHORT).show()
            }
        }
    }

    private fun captureOrder(orderID: String) {
        val request = Request.Builder()
            .url("${getPayPalBaseUrl()}/v2/checkout/orders/$orderID/capture")
            .addHeader("Authorization", "Bearer $accessToken")
            .addHeader("Content-Type", "application/json")
            .post("{}".toRequestBody("application/json".toMediaTypeOrNull()))
            .build()

        client.newCall(request).enqueue(object : Callback {
            override fun onFailure(call: Call, e: IOException) {
                Log.e(TAG, "Capture failed", e)
            }

            override fun onResponse(call: Call, response: Response) {
                response.use {
                    val jsonString = it.body!!.string()
                    val json = JSONObject(jsonString)
                    json.put("orderID", orderid)
                    Log.d(TAG, "Final JSON sent to Flutter: $json")

                    val map: Map<String, Any> = json.toMap().filterValues { it != null } as Map<String, Any>

                    runOnUiThread {
                        MethodChannel(
                            flutterEngine?.dartExecutor?.binaryMessenger ?: return@runOnUiThread,
                            EVENTS
                        ).invokeMethod("paypalPaymentResult", map)

                        Toast.makeText(this@MainActivity, "Payment Captured", Toast.LENGTH_SHORT).show()
                    }
                }
            }
        })
    }

    companion object {
        const val TAG = "MyTag"
    }

    fun JSONObject.toMap(): Map<String, Any?> {
        val map = mutableMapOf<String, Any?>()
        val keys = this.keys()
        while (keys.hasNext()) {
            val key = keys.next()
            val value = this.get(key)
            map[key] = when (value) {
                is JSONObject -> value.toMap()
                is org.json.JSONArray -> value.toList()
                else -> value
            }
        }
        return map
    }

    fun org.json.JSONArray.toList(): List<Any?> {
        val list = mutableListOf<Any?>()
        for (i in 0 until this.length()) {
            val value = this.get(i)
            list.add(
                when (value) {
                    is JSONObject -> value.toMap()
                    is org.json.JSONArray -> value.toList()
                    else -> value
                }
            )
        }
        return list
    }

}

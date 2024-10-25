/*
 * Webkul Software.
 *
 * Kotlin
 *
 * @author Webkul <support@webkul.com>
 * @category Webkul
 * @package com.webkul.mobikul
 * @copyright 2010-2018 Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html ASL Licence
 * @link https://store.webkul.com/license.html
 */

package  webkul.bagisto_app_demo.arcore.activities

import android.Manifest
import android.app.Activity
import android.app.ActivityManager
import android.content.Context
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.text.SpannableString
import androidx.core.content.ContextCompat
import androidx.appcompat.app.AppCompatActivity
import android.util.Log
import android.view.MotionEvent
import android.widget.Toast
import androidx.databinding.DataBindingUtil
import com.example.bagisto_app_demo.databinding.ActivityArBinding
import com.example.bagisto_app_demo.R
import com.google.android.material.snackbar.Snackbar
import com.google.ar.core.HitResult
import com.google.ar.core.Plane
import com.google.ar.core.Session
import com.google.ar.sceneform.AnchorNode
import com.google.ar.sceneform.assets.RenderableSource
import com.google.ar.sceneform.rendering.ModelRenderable
import com.google.ar.sceneform.ux.ArFragment
import com.google.ar.sceneform.ux.TransformableNode
import java.util.concurrent.CompletableFuture


class ArActivity : AppCompatActivity() {
    private val MIN_OPENGL_VERSION = 3.1

    val RC_AR = 1011
    private var arModel: String? = null
    private lateinit var mContentViewBinding: ActivityArBinding
    private var arFragment: ArFragment? = null
    private var objectRenderable: ModelRenderable? = null
    private var mUserRequestedInstall = false
    private var mSession: Session? = null

    var anchorNode: AnchorNode? = null
    private var mModelStateSnackBar: Snackbar? = null
    private lateinit var mModelCompletableFuture: CompletableFuture<Void>

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        mContentViewBinding = DataBindingUtil.setContentView(this, R.layout.activity_ar)
        arModel = intent.getStringExtra("link")
        initSupportActionBar()
        if (checkIsSupportedDeviceOrFinish(this)) {

            startInitialization()
        } else {
            Toast.makeText(
                this,
                getString(R.string.the_ar_feature_is_not_supported_by_your_device),
                Toast.LENGTH_SHORT
            ).show()
            this.finish()
        }
    }

     fun initSupportActionBar() {
        setSupportActionBar(mContentViewBinding.toolbar)
        val title = SpannableString(intent.getStringExtra("name") ?: "")
        supportActionBar?.title = title
        supportActionBar?.elevation = 4f
    }
    private fun startInitialization() {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                if (ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED && ContextCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED) {
                    try {

                        arFragment = supportFragmentManager.findFragmentById(R.id.ux_fragment) as ArFragment


                        Toast.makeText(this@ArActivity, getString(R.string.downloading_model), Toast.LENGTH_SHORT).show()

                        // Init renderable
                        loadModel()

                        // Set tap listener
                        arFragment!!.setOnTapArPlaneListener { hitResult: HitResult, plane: Plane?, motionEvent: MotionEvent? ->
                            val anchor = hitResult.createAnchor()
                            if (anchorNode == null) {
                                anchorNode = AnchorNode(anchor)
                                anchorNode?.setParent(arFragment!!.arSceneView.scene)
                                createModel()
                            }
                        }
                    } catch (e: Exception) {
                        Log.d("TAG", e.printStackTrace().toString() + e.message.toString())
                        e.printStackTrace()
                    }
                } else {
                    val permissions = arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.READ_EXTERNAL_STORAGE)
                    requestPermissions(permissions, RC_AR)
                }
            }
        } catch (e: java.lang.Exception) {
            Log.d("TAG", e.printStackTrace().toString() + e.message.toString())
        }
    }

    private fun createModel() {
        try {
            if (anchorNode != null) {
                val node = TransformableNode(arFragment!!.transformationSystem)
                node.scaleController.maxScale = 1.0f
                node.scaleController.minScale = 0.01f
                node.scaleController.sensitivity = 0.1f
                node.setParent(anchorNode)
                node.renderable = objectRenderable

                node.select()
                mModelStateSnackBar = Snackbar.make(mContentViewBinding.arLayout, getString(R.string.model_ready), Snackbar.LENGTH_INDEFINITE).setAction(getString(R.string.dismiss)) {
                    mModelStateSnackBar?.dismiss()
                }
            }
        } catch (e: Exception) {
            Toast.makeText(this@ArActivity, getString(R.string.something_went_wrong), Toast.LENGTH_SHORT).show()

        }
    }

    private fun loadModel() {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                ModelRenderable.builder()
                    .setSource(this,
                        RenderableSource.builder().setSource(
                            this,
                            Uri.parse(arModel),
                            RenderableSource.SourceType.GLB)
                            .setScale(0.75f)
                            .setRecenterMode(RenderableSource.RecenterMode.ROOT)
                            .build())
                    .setRegistryId(arModel)
                    .build()
                    .thenAccept { renderable: ModelRenderable ->
                        objectRenderable = renderable
                        Toast.makeText(this@ArActivity, getString(R.string.model_ready), Toast.LENGTH_SHORT).show()

                    }
                    .exceptionally { throwable: Throwable? ->
                     //   Log.i("Model", "cant load")
                        Toast.makeText(this@ArActivity, getString(R.string.model_error)+throwable?.message, Toast.LENGTH_SHORT).show()
                        mModelStateSnackBar = Snackbar.make(mContentViewBinding.arLayout, getString(R.string.model_error), Snackbar.LENGTH_INDEFINITE).setAction(getString(R.string.try_again)) {
                            mModelStateSnackBar?.dismiss()
                        }
                        null
                    }
            }
        } catch (e: Exception) {
            Toast.makeText(this@ArActivity, getString(R.string.model_error)+e?.message, Toast.LENGTH_SHORT).show()
            e.printStackTrace()
        }
    }



    private fun checkIsSupportedDeviceOrFinish(activity: Activity): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N) {
            Log.e("error", "Sceneform requires Android N or later")
            return false
        }
        val openGlVersionString =
            (activity.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager)
                .deviceConfigurationInfo
                .glEsVersion
        if (java.lang.Double.parseDouble(openGlVersionString) < MIN_OPENGL_VERSION) {
            Log.e("error", "Sceneform requires OpenGL ES 3.1 later")
            return false
        }
        return true
    }

    override fun onDestroy() {
        super.onDestroy()
        if (::mModelCompletableFuture.isInitialized)
            mModelCompletableFuture.cancel(true)
    }
}
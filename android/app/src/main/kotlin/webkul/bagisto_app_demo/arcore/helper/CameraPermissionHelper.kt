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

package  webkul.bagisto_app_demo.arcore.helper

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.provider.Settings
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat


class CameraPermissionHelper {

    companion object {

        private val CAMERA_PERMISSION_CODE = 0
        private val CAMERA_PERMISSION = Manifest.permission.CAMERA

        /**
         * Check to see we have the necessary permissions for this app.
         */
        fun hasCameraPermission(activity: Activity): Boolean {
            return ContextCompat.checkSelfPermission(
                activity,
                CAMERA_PERMISSION
            ) == PackageManager.PERMISSION_GRANTED
        }

        /**
         * Check to see we have the necessary permissions for this app, and ask for them if we don't.
         */
        fun requestCameraPermission(activity: Activity) {
            ActivityCompat.requestPermissions(
                activity, arrayOf(CAMERA_PERMISSION), CAMERA_PERMISSION_CODE
            )
        }
    }

    /**
     * Check to see if we need to show the rationale for this permission.
     */
    fun shouldShowRequestPermissionRationale(activity: Activity): Boolean {
        return ActivityCompat.shouldShowRequestPermissionRationale(activity, CAMERA_PERMISSION)
    }

    /**
     * Launch Application Setting to grant permission.
     */
    fun launchPermissionSettings(activity: Activity) {
        val intent = Intent()
        intent.action = Settings.ACTION_APPLICATION_DETAILS_SETTINGS
        intent.data = Uri.fromParts("package", activity.packageName, null)
        activity.startActivity(intent)
    }
}
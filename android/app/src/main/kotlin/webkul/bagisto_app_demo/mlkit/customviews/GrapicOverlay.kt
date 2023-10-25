///*
// * Copyright 2020 Google LLC. All rights reserved.
// *
// * Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
// *
// *     http://www.apache.org/licenses/LICENSE-2.0
// *
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
// */
//package webkul.opencart.mobikul.mlkit.customviews
//
//import android.content.Context
//import android.graphics.Canvas
//import android.graphics.Matrix
//import android.util.AttributeSet
//import android.view.View
//import webkul.opencart.mobikul.mlkit.customviews.GraphicOverlay.Graphic
//import java.util.*
//
///**
// * A view which renders a series of custom graphics to be overlayed on top of an associated preview
// * (i.e., the camera preview). The creator can add graphics objects, update the objects, and remove
// * them, triggering the appropriate drawing and invalidation within the view.
// *
// *
// * Supports scaling and mirroring of the graphics relative the camera's preview properties. The
// * idea is that detection items are expressed in terms of an image size, but need to be scaled up
// * to the full view size, and also mirrored in the case of the front-facing camera.
// *
// *
// * Associated [Graphic] items should use the following methods to convert to view
// * coordinates for the graphics that are drawn:
// *
// *
// *  1. [Graphic.scale] adjusts the size of the supplied value from the image scale
// * to the view scale.
// *  1. [Graphic.translateX] and [Graphic.translateY] adjust the
// * coordinate from the image's coordinate system to the view coordinate system.
// *
// */
//class GraphicOverlay(context: Context?, attrs: AttributeSet?) : View(context, attrs) {
//    private val lock = Object()
//
//    // Matrix for transforming from image coordinates to overlay view coordinates.
//    private val transformationMatrix = Matrix()
//    var imageWidth = 0
//        private set
//    var imageHeight = 0
//        private set
//
//    // The factor of overlay View size to image size. Anything in the image coordinates need to be
//    // scaled by this amount to fit with the area of overlay View.
//    private var scaleFactor = 1.0f
//
//    // The number of horizontal pixels needed to be cropped on each side to fit the image with the
//    // area of overlay View after scaling.
//    private var postScaleWidthOffset = 0f
//
//    // The number of vertical pixels needed to be cropped on each side to fit the image with the
//    // area of overlay View after scaling.
//    private var postScaleHeightOffset = 0f
//    private var isImageFlipped = false
//    private var needUpdateTransformation = true
//
//    fun setImageSourceInfo(imageWidth: Int, imageHeight: Int, isFlipped: Boolean) {
//        /* Preconditions.checkState(imageWidth > 0, "image width must be positive");
//    Preconditions.checkState(imageHeight > 0, "image height must be positive");*/
//        synchronized(lock) {
//            this.imageWidth = imageWidth
//            this.imageHeight = imageHeight
//            isImageFlipped = isFlipped
//            needUpdateTransformation = true
//        }
//        postInvalidate()
//    }
//
//
//    override fun onDraw(canvas: Canvas) {
//        super.onDraw(canvas)
//
//    }
//
//    /**
//     * Base class for a custom graphics object to be rendered within the graphic overlay. Subclass
//     * this and implement the [Graphic.draw] method to define the graphics element. Add
//     * instances to the overlay using [GraphicOverlay.add].
//     */
//    abstract class Graphic(private val overlay: GraphicOverlay) {
//
//
//        /**
//         * Adjusts the supplied value from the image scale to the view scale.
//         */
//        fun scale(imagePixel: Float): Float {
//            return imagePixel * overlay.scaleFactor
//        }
//
//        /**
//         * Returns the application context of the app.
//         */
//        val applicationContext: Context
//            get() = overlay.context.applicationContext
//
//        fun isImageFlipped(): Boolean {
//            return overlay.isImageFlipped
//        }
//
//        /**
//         * Adjusts the x coordinate from the image's coordinate system to the view coordinate system.
//         */
//        fun translateX(x: Float): Float {
//            return if (overlay.isImageFlipped) {
//                overlay.width - (scale(x) - overlay.postScaleWidthOffset)
//            } else {
//                scale(x) - overlay.postScaleWidthOffset
//            }
//        }
//
//        /**
//         * Adjusts the y coordinate from the image's coordinate system to the view coordinate system.
//         */
//        fun translateY(y: Float): Float {
//            return scale(y) - overlay.postScaleHeightOffset
//        }
//
//        /**
//         * Returns a [Matrix] for transforming from image coordinates to overlay view coordinates.
//         */
//        fun getTransformationMatrix(): Matrix {
//            return overlay.transformationMatrix
//        }
//
//        fun postInvalidate() {
//            overlay.postInvalidate()
//        }
//    }
//}
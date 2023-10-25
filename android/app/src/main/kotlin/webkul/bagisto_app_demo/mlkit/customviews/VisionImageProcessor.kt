/*
 * Copyright 2020 Google LLC. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package  webkul.bagisto_app_demo.mlkit.customviews

import com.google.mlkit.common.MlKitException
import java.nio.ByteBuffer

/**
 * An interface to process the images with different vision detectors and custom image models.
 */
interface VisionImageProcessor {
    /**
     * Processes a bitmap image.
     */
    /*  fun processBitmap(bitmap: Bitmap?, graphicOverlay: GraphicOverlay)
  */
    /**
     * Processes ByteBuffer image data, e.g. used for Camera1 live preview case.
     */
    @Throws(MlKitException::class)
    fun processByteBuffer(
        data: ByteBuffer?, frameMetadata: FrameMetadata?, graphicOverlay: GraphicOverlay
    )

    /**
     * Stops the underlying machine learning model and release resources.
     */
    fun stop()
}
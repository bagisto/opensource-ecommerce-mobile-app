package  webkul.bagisto_app_demo.mlkit.labeldetector

import android.util.Log
import com.google.android.gms.tasks.Task
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.label.ImageLabel
import com.google.mlkit.vision.label.ImageLabeler
import com.google.mlkit.vision.label.ImageLabelerOptionsBase
import com.google.mlkit.vision.label.ImageLabeling
import  webkul.bagisto_app_demo.mlkit.activities.CameraSearchActivity
import  webkul.bagisto_app_demo.mlkit.customviews.GraphicOverlay
import  webkul.bagisto_app_demo.mlkit.customviews.VisionProcessorBase
import java.io.IOException


class LabelDetectorProcessor(
        private val activityInstance: CameraSearchActivity,
        private val options: ImageLabelerOptionsBase
) :
    VisionProcessorBase<List<ImageLabel>>(activityInstance) {

    private val imageLabeler: ImageLabeler = ImageLabeling.getClient(options)

    override fun stop() {
        super.stop()
        try {
            imageLabeler.close()
        } catch (e: IOException) {
            Log.e(
                TAG,
                "Exception thrown while trying to close ImageLabelerClient: $e"
            )
        }
    }

    override fun detectInImage(image: InputImage): Task<List<ImageLabel>> {
        return imageLabeler.process(image)
    }

    override fun onSuccess(labels: List<ImageLabel>, graphicOverlay: GraphicOverlay) {
        activityInstance.updateSpinnerFromResults(labels)
        //   graphicOverlay.add(LabelGraphic(graphicOverlay, labels))
        // graphicOverlay.clear()
        logExtrasForTesting(labels)

    }

    override fun onFailure(e: Exception) {
        Log.w(TAG, "Label detection failed.$e")
    }

    companion object {
        private const val TAG = "LabelDetectorProcessor"

        private fun logExtrasForTesting(labels: List<ImageLabel>?) {
            if (labels == null) {
                Log.v(MANUAL_TESTING_LOG, "No labels detected")
            } else {
                for (label in labels) {
                    Log.v(
                        MANUAL_TESTING_LOG,
                        String.format("Label %s, confidence %f", label.text, label.confidence)
                    )
                }
            }
        }
    }
}

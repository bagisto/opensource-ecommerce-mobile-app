//



import UIKit
import AVFoundation
import MLKit

    class MLKitViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, UIPopoverPresentationControllerDelegate, DetectedItem {
        
        @IBOutlet var captureView: UIImageView!
        @IBOutlet weak var suggestionView: UIView!
        @IBOutlet weak var arrowImg: UIImageView!
        @IBOutlet weak var suggestionBtn: UIButton!
        @IBOutlet weak var crossBtn: UIButton!
        @IBOutlet weak var suggestionTableView: UITableView!
        @IBOutlet weak var suggestionViewLeading: NSLayoutConstraint!
        @IBOutlet weak var suggestionViewTrailing: NSLayoutConstraint!
        @IBOutlet weak var suggestionViewBottom: NSLayoutConstraint!
        @IBOutlet weak var suggestionViewHeight: NSLayoutConstraint!
        
        let captureSession = AVCaptureSession()
        var previewLayer: AVCaptureVideoPreviewLayer!
        var captureDevice: AVCaptureDevice!
        var imageDetector : ImageLabeler?
        var textDetector : TextRecognizer?
        var totalTextString  = [String]()
        var flag = Bool()
        var shouldTakePhoto = false
        var frameCount = 0
        let detectViewModel = DetectViewModel()
        var isSuggestionsShowing = false
        var detectorType: DetectorType!
        var suggestedData : (( String) -> Void)?
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = UIColor.clear
            view.isOpaque = true
            self.suggestionView.layer.cornerRadius = 8
            switch detectorType {
            case .image:
                 let options = ImageLabelerOptions()
                 options.confidenceThreshold = 0.7
                 imageDetector = ImageLabeler.imageLabeler(options: options)
            case .text:
                textDetector = TextRecognizer.textRecognizer()
            default:
                break
            }
            prepareCamera()
           
        }
   
      
              override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
                  // Trait collection will change. Use this one so you know what the state is changing to.
              }
        
        override func viewDidDisappear(_ animated: Bool) {
            self.toggleTorch(on: false)
            captureSession.stopRunning()
            if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
                for input in inputs {
                    captureSession.removeInput(input)
                }
            }
        }
        
        @IBAction func tapCrossBtn(_ sender :UIButton) {
            self.dismiss(animated: true, completion: nil)
        }
        
        @IBAction func tapSuggestionBtn(_ sender: Any) {
            if isSuggestionsShowing {
                isSuggestionsShowing = false
                self.suggestionViewLeading.constant = 20
                self.suggestionViewTrailing.constant = 20
                self.suggestionViewBottom.constant = 20
                self.suggestionViewHeight.constant = 40
                UIView.animate(withDuration: 0.5) {
                    self.suggestionView.layer.cornerRadius = 8
                    self.suggestionView.layoutIfNeeded()
                    self.arrowImg.transform = CGAffineTransform(rotationAngle: 0)
                }
            } else {
                isSuggestionsShowing = true
                self.suggestionViewLeading.constant = 0
                self.suggestionViewTrailing.constant = 0
                self.suggestionViewBottom.constant = 0
                let height = CGFloat(40 * (self.detectViewModel.TextStringValue.count + 1)) > (self.view.frame.size.height*3/4) ? (self.view.frame.size.height*3/4):CGFloat(40 * (self.detectViewModel.TextStringValue.count + 1))
                print(height)
                self.suggestionViewHeight.constant = height
                UIView.animate(withDuration: 0.5) {
                    self.suggestionView.layer.cornerRadius = 0
                    self.suggestionView.layoutIfNeeded()
                    self.arrowImg.transform = CGAffineTransform(rotationAngle: .pi)
                }
            }
        }
        
        func DetectedValue(value: String) {
            self.dismiss(animated: true) {
                self.suggestedData?(value)
            }
           
        }
        
        func UIColorFromRGB(rgbValue: UInt) -> UIColor {
            return UIColor(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        }
        
        func prepareCamera() {
            captureSession.sessionPreset = AVCaptureSession.Preset.medium
            captureDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.back).devices.first
            beginSession()
        }
        
        func beginSession() {
            do {
                let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
                captureSession.addInput(captureDeviceInput)
            } catch {
                print(error.localizedDescription)
                presentCameraSettings()
            }
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            view.layer.addSublayer(previewLayer)
            previewLayer.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.view.frame.size.width, height: self.view.frame.size.height)
            previewLayer.bounds = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.view.bringSubviewToFront(self.suggestionView)
            self.view.bringSubviewToFront(self.crossBtn)
            captureSession.startRunning()
            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.videoSettings = [
                ((kCVPixelBufferPixelFormatTypeKey as NSString) as String): NSNumber(value: kCVPixelFormatType_32BGRA)
            ]
            dataOutput.alwaysDiscardsLateVideoFrames = true
            if captureSession.canAddOutput(dataOutput) {
                captureSession.addOutput(dataOutput)
            }
            captureSession.commitConfiguration()
            let queue = DispatchQueue(label: "captureQueue")
            dataOutput.setSampleBufferDelegate(self, queue: queue)
        }
        
        func presentCameraSettings() {
            let alertController = UIAlertController(title: "", message: "cameraAccessDenied", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "cancel", style: .default) { _ in
                self.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(UIAlertAction(title: "settings", style: .cancel) { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                        self.prepareCamera()
                    })
                }
            })
            self.present(alertController, animated: true)
        }
        
       
        // Process frames only at a specific duration. This skips redundant frames and
        // avoids memory issues.
        func proccess(every: Int, callback: () -> Void) {
            frameCount += 1
            // Process every nth frame
            if frameCount % every == 0 {
                callback()
            }
        }
        
        // Combine all VisionText into one String
        private func flattenVisionImage(visionImageLabel: [ImageLabel]?) {
           
            if let vision = visionImageLabel {
                for i in 0..<vision.count {
                    if totalTextString.contains(vision[i].text) == false {//&& totalTextString.count<=9{
                        print(totalTextString)
                            totalTextString.append(vision[i].text.trimmingCharacters(in: .whitespacesAndNewlines))
                            self.detectViewModel.getValue(data: totalTextString) { (check) in
                                if check {
                                    self.suggestionView.isHidden = false
                                    self.detectViewModel.delegate = self
                                    self.suggestionTableView.delegate = detectViewModel
                                    self.suggestionTableView.dataSource = detectViewModel
                                    self.suggestionTableView.alpha = 1
                                    self.suggestionTableView.reloadData()
                                    let dataStr = "\(self.detectViewModel.TextStringValue.count) Suggestions"
                                    self.suggestionBtn.setTitle(dataStr, for: .normal)
                                }
                            }
                       
                        
                    }
                }
            }
        }
        
        private func flattenVisionText(visionText: Text?) -> String {
            var text = ""
            print(visionText?.blocks as Any)
            visionText?.blocks.forEach() { vText in
                text += " " + vText.text
            }
            if let vision = visionText?.blocks {
                for i in 0..<vision.count {
                    if totalTextString.contains(vision[i].text) == false {//&& totalTextString.count<=9{
                        print(totalTextString)
                            totalTextString.append(vision[i].text.trimmingCharacters(in: .whitespacesAndNewlines))
                            self.detectViewModel.getValue(data: totalTextString) { (check) in
                                if check {
                                    self.suggestionView.isHidden = false
                                    self.detectViewModel.delegate = self
                                    self.suggestionTableView.delegate = detectViewModel
                                    self.suggestionTableView.dataSource = detectViewModel
                                    self.suggestionTableView.alpha = 1
                                    self.suggestionTableView.reloadData()
                                    let dataStr = "\(self.detectViewModel.TextStringValue.count) Suggestions"
                                    self.suggestionBtn.setTitle(dataStr, for: .normal)
                                }
                            }
                       
                    }
                }
            }
            return text
        }
        
      
        func imageOrientation(
          deviceOrientation: UIDeviceOrientation,
          cameraPosition: AVCaptureDevice.Position
        ) -> UIImage.Orientation {
          switch deviceOrientation {
          case .portrait:
            return cameraPosition == .front ? .leftMirrored : .right
          case .landscapeLeft:
            return cameraPosition == .front ? .downMirrored : .up
          case .portraitUpsideDown:
            return cameraPosition == .front ? .rightMirrored : .left
          case .landscapeRight:
            return cameraPosition == .front ? .upMirrored : .down
          case .faceDown, .faceUp, .unknown:
            return .up
          @unknown default:
            return .up
          }
        }
        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            // Detect text every 10 frames
            proccess(every: 10) {
                let image = VisionImage(buffer: sampleBuffer)
                   image.orientation = imageOrientation(
                     deviceOrientation: UIDevice.current.orientation,
                       cameraPosition: .back)
                   switch detectorType {
                   case .image?:
                       imageDetector?.process(image) { labels, error in
                               guard error == nil, let labels = labels else { return }
                               self.flattenVisionImage(visionImageLabel: labels)
                           }
                   case .text?:
                       textDetector?.process(image) { visionText, error in
                               guard error == nil, let visionText = visionText else { return }
                               self.flattenVisionText(visionText: visionText)
                           }
                       
                   default:
                       break
                   }
            }
        }
        
        func toggleTorch(on: Bool) {
            guard let device = AVCaptureDevice.default(for: AVMediaType.video)
                else {return}
            if device.hasTorch {
                do {
                    try device.lockForConfiguration()
                    if on == true {
                        device.torchMode = .on
                    } else {
                        device.torchMode = .off
                    }
                    device.unlockForConfiguration()
                } catch {
                    print("Torch could not be used")
                }
            } else {
                print("Torch is not available")
            }
        }
        
    }

    extension CMSampleBuffer {
        // Converts a CMSampleBuffer to a UIImage
        //
        // Return: UIImage from CMSampleBuffer
        func toUIImage() -> UIImage? {
            if let pixelBuffer = CMSampleBufferGetImageBuffer(self) {
                let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
                let context = CIContext()
                let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
                if let image = context.createCGImage(ciImage, from: imageRect) {
                    return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
                }
            }
            return nil
        }
    }
